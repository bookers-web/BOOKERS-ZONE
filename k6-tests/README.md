# Bookers Zone 부하/동시성 테스트

## 설치

```bash
# macOS
brew install k6

# Windows
choco install k6

# Docker
docker pull grafana/k6
```

## 테스트 실행

### 1. 동시접속 제한 테스트
15명이 동시에 접속 시도 → 10명만 성공해야 함 (MAX_CONCURRENT=10)

```bash
cd k6-tests
k6 run concurrent-limit-test.js
```

**기대 결과:**
- session_success: 10
- session_fail: 5

---

### 2. 부하 테스트
점진적으로 부하 증가 (10 → 50 → 100 VUs)

```bash
k6 run load-test.js
```

**기대 결과:**
- p95 응답시간 < 500ms
- 에러율 < 10%

---

### 3. Race Condition 테스트
20명이 동시에 세션 생성 시도 → FOR UPDATE 락 검증

```bash
k6 run race-condition-test.js
```

**기대 결과:**
- 정확히 10개 세션 생성
- 10개 요청 거부

---

## 테스트 전 준비

```bash
# 1. 앱 실행 확인
curl http://localhost:8081/api/ip-auth/check

# 2. 세션 초기화 (필요 시)
curl -X DELETE http://localhost:8081/api/ip-auth/session
```

## 결과 분석

| 지표 | 정상 범위 | 주의 |
|------|----------|------|
| p95 응답시간 | < 200ms | > 500ms면 성능 이슈 |
| 에러율 | < 1% | > 5%면 안정성 이슈 |
| 처리량 | > 100 req/s | < 50 req/s면 병목 확인 |

## 고급 옵션

```bash
# HTML 리포트 생성
k6 run --out json=result.json load-test.js
# 이후 k6-reporter 등으로 시각화

# 특정 VU 수로 실행
k6 run --vus 50 --duration 30s load-test.js

# 환경변수로 URL 변경
k6 run -e BASE_URL=http://prod-server:8081 load-test.js
```
