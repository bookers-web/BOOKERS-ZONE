-- ============================================================
-- 필드테스트 데이터: 전라남도교육청 (UIS0000000837)
-- 사전 조건: V001 + V003 마이그레이션 실행 완료
-- ============================================================

-- 1. 기관 설정 등록 (TBL_ZONE_CONFIG)
INSERT INTO TBL_ZONE_CONFIG (uis_code, max_concurrent)
VALUES ('UIS0000000837', 100);

-- 1-1. 기관 Zone 활성화 (TBL_INSTITUTION_MASTER)
UPDATE TBL_INSTITUTION_MASTER SET UIS_ZONE_FLAG = 'Y' WHERE UIS_CODE = 'UIS0000000837';

-- 2. 도서관별 IP 등록 (6개 도서관)
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_version, ip_pattern, is_enabled) VALUES
('UIS0000000837', 'v4', '210.95.17.119', true),   -- 교육연수원
('UIS0000000837', 'v4', '210.95.17.76', true),    -- 나주도서관
('UIS0000000837', 'v4', '210.95.17.77', true),    -- 남평도서관
('UIS0000000837', 'v4', '210.95.17.120', true),   -- 담양도서관
('UIS0000000837', 'v4', '210.95.78.150', true),   -- 장성도서관
('UIS0000000837', 'v4', '210.95.79.146', true);   -- 화순도서관

-- ============================================================
-- 검증 쿼리
-- ============================================================
-- SELECT z.uis_code, z.max_concurrent, i.UIS_NAME, r.ip_pattern
-- FROM TBL_ZONE_CONFIG z
-- JOIN TBL_INSTITUTION_MASTER i ON z.uis_code = i.UIS_CODE
-- JOIN TBL_IP_AUTH_IP_RANGE r ON z.uis_code = r.uis_code
-- WHERE z.uis_code = 'UIS0000000837';
--
-- 예상 결과: 6행 (기관 1개 × IP 6개)
-- ============================================================

-- 롤백 (필요 시)
-- DELETE FROM TBL_IP_AUTH_IP_RANGE WHERE uis_code = 'UIS0000000837';
-- DELETE FROM TBL_ZONE_CONFIG WHERE uis_code = 'UIS0000000837';
-- UPDATE TBL_INSTITUTION_MASTER SET UIS_ZONE_FLAG = NULL WHERE UIS_CODE = 'UIS0000000837';
