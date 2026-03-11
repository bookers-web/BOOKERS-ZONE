-- ============================================================
-- IP 인증 테이블 분리 마이그레이션
-- TBL_IP_AUTH_CONFIG에서 IP 패턴을 TBL_IP_AUTH_IP_RANGE로 분리
-- ============================================================
-- 실행 전 반드시 백업:
--   mysqldump -u cmsBuker -p bookers TBL_IP_AUTH_CONFIG > backup_ip_auth_config.sql
-- ============================================================

-- 1. 신규 테이블 생성: IP 범위 (N per institution)
CREATE TABLE IF NOT EXISTS TBL_IP_AUTH_IP_RANGE (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    uis_code VARCHAR(50) NOT NULL COMMENT '기관 코드',
    ip_version VARCHAR(10) DEFAULT 'v4' COMMENT 'IPv4/IPv6',
    ip_pattern VARCHAR(255) NOT NULL COMMENT '단일 IP 또는 CIDR (예: 192.168.0.0/16)',
    is_enabled BOOLEAN DEFAULT true COMMENT '활성화 여부',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_uis_code (uis_code),
    INDEX idx_enabled (is_enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='IP 인증 범위 패턴';

-- 2. 기존 데이터 마이그레이션: 콤마 구분 ip_pattern → 개별 행으로 분리
--    MySQL에서 콤마 split을 위해 프로시저 사용
DELIMITER //
CREATE PROCEDURE migrate_ip_patterns()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_uis_code VARCHAR(50);
    DECLARE v_ip_version VARCHAR(10);
    DECLARE v_ip_pattern TEXT;
    DECLARE cur CURSOR FOR
        SELECT uis_code, ip_version, ip_pattern
        FROM TBL_IP_AUTH_CONFIG
        WHERE ip_pattern IS NOT NULL AND ip_pattern != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_uis_code, v_ip_version, v_ip_pattern;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 콤마로 split하여 개별 INSERT
        SET @remaining = v_ip_pattern;
        WHILE LENGTH(@remaining) > 0 DO
            SET @comma_pos = LOCATE(',', @remaining);
            IF @comma_pos > 0 THEN
                SET @single_pattern = TRIM(SUBSTRING(@remaining, 1, @comma_pos - 1));
                SET @remaining = SUBSTRING(@remaining, @comma_pos + 1);
            ELSE
                SET @single_pattern = TRIM(@remaining);
                SET @remaining = '';
            END IF;

            IF LENGTH(@single_pattern) > 0 THEN
                INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_version, ip_pattern, is_enabled)
                VALUES (v_uis_code, v_ip_version, @single_pattern, true);
            END IF;
        END WHILE;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

CALL migrate_ip_patterns();
DROP PROCEDURE IF EXISTS migrate_ip_patterns;

-- 3. 중복 uis_code 행 정리 (첫 번째 행만 유지)
--    먼저 확인: SELECT uis_code, COUNT(*) FROM TBL_IP_AUTH_CONFIG GROUP BY uis_code HAVING COUNT(*) > 1;
DELETE t1 FROM TBL_IP_AUTH_CONFIG t1
INNER JOIN TBL_IP_AUTH_CONFIG t2
ON t1.uis_code = t2.uis_code AND t1.id > t2.id;

-- 4. uis_code에 UNIQUE 제약조건 추가
ALTER TABLE TBL_IP_AUTH_CONFIG ADD UNIQUE INDEX uq_uis_code (uis_code);

-- 5. ip_version, ip_pattern 컬럼 제거 (더 이상 사용하지 않음)
ALTER TABLE TBL_IP_AUTH_CONFIG DROP COLUMN ip_version;
ALTER TABLE TBL_IP_AUTH_CONFIG DROP COLUMN ip_pattern;

-- ============================================================
-- 마이그레이션 검증 쿼리
-- ============================================================
-- 기관별 config 확인 (1:1 관계)
-- SELECT * FROM TBL_IP_AUTH_CONFIG;

-- IP 범위 확인 (기관당 N개)
-- SELECT * FROM TBL_IP_AUTH_IP_RANGE ORDER BY uis_code;

-- 결합 조회 확인
-- SELECT c.uis_code, c.uis_name, c.max_concurrent, r.ip_pattern
-- FROM TBL_IP_AUTH_CONFIG c
-- JOIN TBL_IP_AUTH_IP_RANGE r ON c.uis_code = r.uis_code
-- WHERE c.is_enabled = true AND r.is_enabled = true;
-- ============================================================