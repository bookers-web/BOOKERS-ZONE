-- ============================================================
-- TBL_IP_AUTH_CONFIG → TBL_ZONE_CONFIG 마이그레이션
-- 사전 조건: V001_ip_auth_table_separation.sql 실행 완료
-- ============================================================
-- 실행 전 반드시 백업:
--   mysqldump -u cmsBuker -p bookers TBL_IP_AUTH_CONFIG > backup_ip_auth_config_v003.sql
-- ============================================================

-- 1. TBL_ZONE_CONFIG 생성 (uis_code를 PK로, id 자동증가 제거)
CREATE TABLE IF NOT EXISTS TBL_ZONE_CONFIG (
    uis_code VARCHAR(50) PRIMARY KEY COMMENT '기관 코드 (TBL_INSTITUTION_MASTER FK)',
    max_concurrent INT NOT NULL DEFAULT 100 COMMENT '최대 동시접속 수',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Zone 기관별 동시접속 설정';

-- 2. 기존 데이터 마이그레이션
INSERT INTO TBL_ZONE_CONFIG (uis_code, max_concurrent, created_at, updated_at)
SELECT uis_code, max_concurrent, created_at, updated_at
FROM TBL_IP_AUTH_CONFIG;

-- 3. 활성화된 기관의 UIS_ZONE_FLAG 설정
--    TBL_IP_AUTH_CONFIG.is_enabled = true → TBL_INSTITUTION_MASTER.UIS_ZONE_FLAG = 'Y'
UPDATE TBL_INSTITUTION_MASTER i
INNER JOIN TBL_IP_AUTH_CONFIG c ON i.UIS_CODE = c.uis_code
SET i.UIS_ZONE_FLAG = 'Y'
WHERE c.is_enabled = true;

-- 4. TBL_IP_AUTH_CONFIG 백업 후 삭제
RENAME TABLE TBL_IP_AUTH_CONFIG TO TBL_IP_AUTH_CONFIG_BAK;

-- ============================================================
-- 검증 쿼리
-- ============================================================
-- 기관별 설정 확인
-- SELECT z.uis_code, z.max_concurrent, i.UIS_NAME, i.UIS_ZONE_FLAG
-- FROM TBL_ZONE_CONFIG z
-- LEFT JOIN TBL_INSTITUTION_MASTER i ON z.uis_code = i.UIS_CODE;
--
-- IP 범위 + 기관 활성화 확인
-- SELECT r.uis_code, r.ip_pattern, i.UIS_NAME, i.UIS_ZONE_FLAG
-- FROM TBL_IP_AUTH_IP_RANGE r
-- INNER JOIN TBL_INSTITUTION_MASTER i ON r.uis_code = i.UIS_CODE
-- WHERE r.is_enabled = true AND i.UIS_ZONE_FLAG = 'Y';
-- ============================================================

-- 롤백 (필요 시)
-- RENAME TABLE TBL_IP_AUTH_CONFIG_BAK TO TBL_IP_AUTH_CONFIG;
-- DROP TABLE IF EXISTS TBL_ZONE_CONFIG;
-- UPDATE TBL_INSTITUTION_MASTER SET UIS_ZONE_FLAG = NULL WHERE UIS_ZONE_FLAG = 'Y';
