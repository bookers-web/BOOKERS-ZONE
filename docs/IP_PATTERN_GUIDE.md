# IP 패턴 등록 가이드

## TBL_IP_AUTH_IP_RANGE 저장 형식

관리자페이지에서 기관 IP를 등록할 때 3가지 형식을 지원한다.
`ip_pattern` 컬럼에 아래 형식 중 하나로 저장한다.

---

### 1. 단일 IP

특정 컴퓨터 1대의 IP를 등록할 때 사용.

| ip_pattern | 매칭 대상 |
|------------|----------|
| `210.95.17.119` | 210.95.17.119 만 |

```sql
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('UIS0000000837', '210.95.17.119');
```

**사용 예시**: 도서관 특정 열람용 PC

---

### 2. CIDR 대역

서브넷 단위로 IP 범위를 등록할 때 사용. `IP주소/프리픽스길이` 형식.

| ip_pattern | 매칭 대상 | 범위 |
|------------|----------|------|
| `210.95.17.0/24` | 210.95.17.0 ~ 210.95.17.255 | 256개 |
| `210.95.0.0/16` | 210.95.0.0 ~ 210.95.255.255 | 65,536개 |
| `192.168.1.0/28` | 192.168.1.0 ~ 192.168.1.15 | 16개 |
| `10.0.0.0/8` | 10.0.0.0 ~ 10.255.255.255 | 16,777,216개 |

```sql
-- 도서관 내부 네트워크 전체 (C클래스)
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('UIS0000000837', '210.95.17.0/24');

-- 기관 전체 대역 (B클래스)
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('UIS0000000837', '210.95.0.0/16');
```

#### CIDR 프리픽스 참고표

| 프리픽스 | 서브넷 마스크 | IP 개수 | 용도 |
|---------|-------------|---------|------|
| /32 | 255.255.255.255 | 1 | 단일 IP (단일 IP 형식과 동일) |
| /28 | 255.255.255.240 | 16 | 소규모 열람실 |
| /24 | 255.255.255.0 | 256 | 일반 도서관 |
| /20 | 255.255.240.0 | 4,096 | 대규모 기관 |
| /16 | 255.255.0.0 | 65,536 | 기관 전체 |

**사용 예시**: 도서관 내부 네트워크 전체, 교육청 산하 기관 대역

---

### 3. 범위 (start~end)

시작 IP ~ 끝 IP를 직접 지정. CIDR로 표현하기 어려운 범위에 사용.

| ip_pattern | 매칭 대상 |
|------------|----------|
| `210.95.17.1~210.95.17.200` | 210.95.17.1 ~ 210.95.17.200 (200개) |
| `210.95.17.100~210.95.18.50` | 서브넷 걸침 (207개) |

```sql
-- 열람실 IP 범위만 (전체가 아닌 일부)
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('UIS0000000837', '210.95.17.100~210.95.17.200');
```

**사용 예시**: CIDR로 딱 떨어지지 않는 범위, 서브넷을 걸치는 범위

---

## 기관당 여러 IP 등록

하나의 기관에 여러 행을 등록하면 **OR 조건**으로 동작한다.
접속자 IP가 하나라도 매칭되면 해당 기관으로 인증된다.

```sql
-- 전라남도교육청 (UIS0000000837) — 도서관별 개별 IP
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.17.119');   -- 교육연수원
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.17.76');    -- 나주도서관
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.17.77');    -- 남평도서관
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.17.120');   -- 담양도서관
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.78.150');   -- 장성도서관
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.79.146');   -- 화순도서관

-- 또는 대역으로 한 줄로 처리
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern) VALUES ('UIS0000000837', '210.95.17.0/24');
```

---

## 형식 자동 판별 로직 (IpUtils.isInRange)

```
ip_pattern에 "~" 포함 → 범위(start~end) 비교
ip_pattern에 "/" 포함 → CIDR 비교
둘 다 없음             → 단일 IP 정확 매칭
```

---

## 관리자 UI 등록 시 유의사항

| 항목 | 설명 |
|------|------|
| **공백** | 앞뒤 공백은 자동 trim 처리됨 |
| **IPv6** | CIDR/범위 매칭은 IPv4만 지원. IPv6는 단일 IP 매칭만 가능 |
| **중복** | 같은 기관에 겹치는 범위를 등록해도 동작에는 문제없음 (첫 매칭 반환) |
| **비활성화** | `is_enabled = false`로 설정하면 해당 행은 매칭에서 제외 |
| **기관 비활성화** | `TBL_INSTITUTION_MASTER.UIS_ZONE_FLAG`가 'Y'가 아니면 해당 기관의 모든 IP 무시 |
