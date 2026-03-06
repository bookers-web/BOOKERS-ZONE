# Bookers Zone IP 인증 서비스 시연 가이드

| 항목 | 내용 |
|------|------|
| 작성일 | 2026-02-23 |
| 대상 | 내부 팀/리더 |
| 시연 환경 | 로컬 개발 서버 (localhost:8081) |
| 예상 소요 | 약 11분 |

---

## 1. 사전 준비

### 1.1 로컬 IP 등록 확인

로컬 접속 시 클라이언트 IP가 `0:0:0:0:0:0:0:1`(IPv6) 또는 `127.0.0.1`(IPv4)로 잡힙니다.
**TBL_IP_AUTH_CONFIG에 해당 IP가 등록되어 있어야** 정상 시연이 가능합니다.

```sql
-- 현재 설정 확인
SELECT * FROM TBL_IP_AUTH_CONFIG;

-- 로컬 테스트용 설정이 없다면 등록
-- ※ 시연 임팩트를 위해 max_concurrent = 3 권장 (4번째부터 차단)
INSERT INTO TBL_IP_AUTH_CONFIG 
  (uis_code, uis_name, ip_version, ip_pattern, max_concurrent, is_enabled, created_at, updated_at)
VALUES 
  ('UIS0000000013', '시연용 도서관', 'IPv6', '0:0:0:0:0:0:0:1', 3, true, NOW(), NOW());

INSERT INTO TBL_IP_AUTH_CONFIG 
  (uis_code, uis_name, ip_version, ip_pattern, max_concurrent, is_enabled, created_at, updated_at)
VALUES 
  ('UIS0000000013', '시연용 도서관', 'IPv4', '127.0.0.1', 3, true, NOW(), NOW());
```

> **TIP**: k6 테스트(시나리오 3, 5)는 `X-Forwarded-For` 헤더로 IP를 시뮬레이션하므로,
> `10.0.0.0/24` 대역도 추가로 등록해두면 편리합니다.

```sql
INSERT INTO TBL_IP_AUTH_CONFIG 
  (uis_code, uis_name, ip_version, ip_pattern, max_concurrent, is_enabled, created_at, updated_at)
VALUES 
  ('UIS0000000013', '시연용 도서관', 'IPv4', '10.0.0.0/24', 10, true, NOW(), NOW());
```

### 1.2 서버 실행 및 확인

```bash
# 앱 실행 (IntelliJ Run 또는 터미널)
cd bookers_zone
./gradlew bootRun

# 실행 확인 — clientIp 필드로 로컬 IP 확인 가능
curl -s http://localhost:8081/api/ip-auth/check | python3 -m json.tool
```

### 1.3 기존 세션 초기화

```bash
curl -X DELETE "http://localhost:8081/api/ip-auth/session/all"
```

### 1.4 k6 설치 (시나리오 3, 5 시연 시 필요)

```bash
brew install k6
```

---

## 2. 시연 시나리오

### 시나리오 1 — 정상 접속 플로우 (브라우저) `⏱ 2분`

> 비회원 관내 이용자가 로그인 없이 전자책을 이용하는 기본 플로우를 보여줍니다.

**시연 순서:**

1. 브라우저에서 `http://localhost:8081` 접속
2. **로그인 페이지** 확인
   - "비회원 관내 이용자" / "회원 서비스" 두 옵션이 표시됨
   - 하단 안내 문구에 **동시접속 제한 인원(3명)** 이 표시됨
3. **"비회원 관내 이용자 — 바로 이용하기"** 클릭
4. `/front/home/main.do`로 자동 이동 → 추천도서 목록 + 공지사항 확인
5. 브라우저 개발자 도구(F12) → Application → Cookies 탭에서 **`BKS_ZONE_SESSION`** 쿠키 확인

**설명 포인트:**

- IP 대역으로 기관을 자동 식별하므로 별도 로그인이 필요 없습니다
- 세션 쿠키는 `HttpOnly` 설정으로 JavaScript에서 접근 불가 → XSS 공격 방어
- 쿠키 만료 시간 20분, 요청할 때마다 자동 갱신 (슬라이딩 윈도우 방식)

---

### 시나리오 2 — 동시접속 제한 `⏱ 3분` ★ 핵심

> `max_concurrent=3` 설정에 의해 4번째 사용자가 차단되는 모습을 보여줍니다.

**시연 순서:**

#### Step 1: 세션 초기화

```bash
curl -X DELETE "http://localhost:8081/api/ip-auth/session/all"
```

#### Step 2: 3개 세션 생성 (각각 다른 IP)

```bash
# 세션 1
curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.1" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool

# 세션 2
curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.2" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool

# 세션 3
curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.3" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool
```

각각 `"success": true`와 `sessionId`가 반환되는 것을 확인합니다.

#### Step 3: 4번째 세션 생성 시도 → 차단

```bash
curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.4" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool
```

**기대 응답:**

```json
{
  "success": true,
  "data": {
    "success": false,
    "message": "현재 동시 이용자 수가 많아 접속이 어렵습니다. 잠시 후 다시 시도해 주세요.",
    "errorCode": "MAX_CONCURRENT_EXCEEDED"
  }
}
```

#### Step 4: 세션 1개 삭제 후 재시도 → 성공

```bash
# 세션 1 삭제 (Step 2에서 받은 세션1의 sessionId 사용)
curl -s -X DELETE http://localhost:8081/api/ip-auth/session \
  -H "Cookie: BKS_ZONE_SESSION={세션1의-sessionId}"

# 4번째 사용자 재시도 → 이번에는 성공
curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.4" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool
```

**설명 포인트:**

- 기관별로 동시접속 수를 개별 설정할 수 있습니다
- 초과 시 명확한 에러 메시지와 에러코드(`MAX_CONCURRENT_EXCEEDED`)를 반환합니다
- 한 자리가 비면 즉시 새 사용자가 입장할 수 있습니다

---

### 시나리오 3 — Race Condition 방어 (k6) `⏱ 2분` ★ 기술적 하이라이트

> 20명이 **동시에** 세션 생성을 요청해도 정확히 설정된 수만큼만 성공하는 것을 보여줍니다.

**시연 순서:**

```bash
# 세션 초기화
curl -X DELETE "http://localhost:8081/api/ip-auth/session/all"

# Race Condition 테스트 실행
cd bookers_zone/k6-tests
k6 run race-condition-test.js
```

**기대 출력:**

```
========== RACE CONDITION TEST ==========
Sessions Created: 10
Sessions Rejected: 10
Expected: Created = 10, Rejected = 10

Result: PASS - No race condition detected
=========================================
```

**설명 포인트:**

- 20명이 밀리초 단위로 동시에 요청해도 DB의 `SELECT FOR UPDATE` 비관적 락으로 정확히 제한 수만큼만 통과합니다
- 일반적인 `SELECT → 카운트 체크 → INSERT` 패턴에서는 Race Condition으로 초과 생성될 수 있지만, 비관적 락으로 완벽히 방어했습니다

---

### 시나리오 4 — 세션 IP 바인딩 (세션 하이재킹 방어) `⏱ 2분`

> 세션 쿠키를 탈취하더라도 다른 IP에서는 사용할 수 없음을 보여줍니다.

**시연 순서:**

#### Step 1: 세션 생성

```bash
curl -X DELETE "http://localhost:8081/api/ip-auth/session/all"

curl -s -X POST http://localhost:8081/api/ip-auth/session \
  -H "Content-Type: application/json" \
  -H "X-Forwarded-For: 10.0.0.1" \
  -d '{"uisCode":"UIS0000000013"}' | python3 -m json.tool

# 응답에서 sessionId를 메모 (예: "abc-123-def")
```

#### Step 2: 같은 IP에서 검증 → 성공

```bash
curl -s "http://localhost:8081/api/ip-auth/session/validate" \
  -H "Cookie: BKS_ZONE_SESSION={sessionId}" \
  -H "X-Forwarded-For: 10.0.0.1" | python3 -m json.tool
```

```json
{
  "success": true,
  "data": {
    "valid": true,
    "message": "유효한 세션입니다."
  }
}
```

#### Step 3: 다른 IP에서 같은 세션으로 검증 → 차단

```bash
curl -s "http://localhost:8081/api/ip-auth/session/validate" \
  -H "Cookie: BKS_ZONE_SESSION={sessionId}" \
  -H "X-Forwarded-For: 10.0.0.99" | python3 -m json.tool
```

```json
{
  "success": true,
  "data": {
    "valid": false,
    "message": "세션 IP가 일치하지 않습니다."
  }
}
```

**설명 포인트:**

- 세션 생성 시 클라이언트 IP를 함께 저장하고, 매 요청마다 IP 일치 여부를 검증합니다
- 세션 쿠키가 유출되더라도 다른 네트워크에서는 사용할 수 없습니다

---

### 시나리오 5 — 부하 테스트 (선택) `⏱ 2분`

> 100명 동시접속 환경에서의 서버 응답 성능을 보여줍니다.

```bash
cd bookers_zone/k6-tests
k6 run load-test.js
```

**기대 출력:**

```
========== LOAD TEST SUMMARY ==========
Total Requests: ~6,600건
Request Rate: ~82 req/s

Response Time:
  - Avg: ~184ms
  - p95: ~647ms
  - Max: ~2,250ms

Error Rate: 0.00%
========================================
```

**설명 포인트:**

| 지표 | 측정값 | 의미 |
|------|--------|------|
| 에러율 | 0.00% | 100명 동시접속에서도 오류 없음 |
| 평균 응답 | ~184ms | 사용자 체감 지연 없음 |
| 처리량 | ~82 req/s | 초당 82건 처리 가능 |

---

## 3. 시연 흐름 요약

```
 0분  사전 준비 (세션 초기화, DB 확인)
      │
 1분  시나리오 1: 브라우저 정상 플로우
      │  로그인 → 비회원 입장 → 메인 → 쿠키 확인
      │
 3분  시나리오 2: 동시접속 제한 ★ 핵심
      │  3명 생성 → 4번째 차단 → 1명 삭제 → 재시도 성공
      │
 6분  시나리오 3: Race Condition 방어 ★ 기술적 하이라이트
      │  k6로 20명 동시 → 정확히 10명만 통과
      │
 8분  시나리오 4: IP 바인딩 (세션 하이재킹 방어)
      │  같은 IP → 성공 / 다른 IP → 차단
      │
10분  시나리오 5: 부하 테스트 결과 (선택)
      │  100명 동시 → 에러율 0%, 평균 184ms
      │
11분  Q&A
```

---

## 4. 주의사항

| 항목 | 내용 |
|------|------|
| DB 연결 | `133.186.244.130:3306`에 접속 가능해야 함 |
| 로컬 IP 확인 | `/api/ip-auth/check` 응답의 `clientIp` 필드로 확인 |
| max_concurrent | 시연용으로 **3** 권장 (10이면 curl 10번 필요) |
| k6 UIS 코드 | 스크립트에 `UIS0000000013` 하드코딩 → DB에 해당 설정 필수 |
| k6 설치 | `brew install k6` (미설치 시 시나리오 3, 5 불가) |
| 세션 초기화 | 각 시나리오 시작 전 반드시 `DELETE /api/ip-auth/session/all` 실행 |

---

## 5. FAQ (예상 질문)

**Q: 허용되지 않은 IP에서 접속하면 어떻게 되나요?**
A: `IpAuthInterceptor`가 모든 요청을 가로채서 `https://www.bookers.life/`로 리다이렉트합니다. 기관 IP 대역이 아니면 아예 서비스에 진입할 수 없습니다.

**Q: 세션이 만료되면 어떻게 되나요?**
A: 20분간 활동이 없으면 세션이 만료됩니다. 만료된 세션은 60초 주기의 스케줄러가 자동으로 정리하여 동시접속 슬롯을 반환합니다. 사용자는 다시 로그인 페이지로 이동됩니다.

**Q: 기관별로 동시접속 수를 다르게 설정할 수 있나요?**
A: 네. `TBL_IP_AUTH_CONFIG` 테이블의 `max_concurrent` 값을 기관별로 개별 설정 가능합니다.

**Q: IPv4와 IPv6 모두 지원하나요?**
A: 네. IP 패턴에 `192.168.1.0/24`(IPv4 CIDR), `0:0:0:0:0:0:0:1`(IPv6) 등 다양한 형식을 지원합니다.

---

**문서 끝**
