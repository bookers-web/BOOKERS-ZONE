# Bookers Zone 아키텍처 문서

## 1. 프로젝트 개요

**Bookers Zone**은 도서관/기관의 **IP 기반 인증 및 동시접속 관리 서비스**이다.
기관 내부 네트워크(허용된 IP)에서 접속하면 별도 로그인 없이 관내 이용자로 진입하여 도서를 열람할 수 있다.

| 항목 | 값 |
|------|------|
| Tech Stack | Java 21, Spring Boot 3.4.3, MyBatis 3.0.4, MySQL, JSP |
| Build | Gradle 8.x |
| Package | `life.bks.zone` |
| Port | 8081 (운영), 8082 (개발 테스트) |

---

## 2. 핵심 프로세스

### 2.1 관내 이용자 진입 흐름

```
사용자 브라우저 (기관 내부 IP)
    │
    ▼
[IpAuthInterceptor] ─── IP 허용 확인
    │                    └─ TBL_IP_AUTH_IP_RANGE에서 IP 매칭
    │                    └─ TBL_INSTITUTION_MASTER.UIS_ZONE_FLAG = 'Y' 확인
    │
    ▼ (IP 허용됨)
[GET /login] ─── 랜딩 페이지 (기관명, 동시접속 수 표시)
    │
    ▼ (비회원 진입 클릭)
[GET /zone/enter] ─── PageController.zoneEnter()
    │
    ├─ 1. ipAuthService.findConfigByIp(clientIp)
    │     └─ IP 매칭 → TBL_ZONE_CONFIG 조회 (기관 설정)
    │
    ├─ 2. ipAuthService.createSession(uisCode, clientIp, userAgent)
    │     ├─ TBL_ZONE_CONFIG SELECT FOR UPDATE (동시접속 잠금)
    │     ├─ 만료 세션 정리 (20분 초과)
    │     ├─ 동시접속 체크 (currentCount >= maxConcurrent → 거부)
    │     ├─ guestLoginService.createZoneGuest(uisCode, clientIp)
    │     │     ├─ TBL_SEQUENCES FOR UPDATE (시퀀스 잠금)
    │     │     ├─ INSERT TBL_B2B_MEMBER_MASTER (세션당 개별 guest)
    │     │     └─ return umCode ("UM00000XXXXXX")
    │     ├─ INSERT TBL_IP_AUTH_SESSION (session_id, um_code 포함)
    │     └─ return SessionCreateResponse(sessionId, umCode)
    │
    ├─ 3. 쿠키 설정: BKS_ZONE_SESSION = sessionId (20분 TTL)
    │
    ├─ 4. HttpSession에 기관 정보 저장
    │     ├─ UM_UIS_CODE, UIS_UCP_CODE, ZONE_SESSION_ID
    │     ├─ UM_CODE (guest umCode — 정산용)
    │     └─ UIS_NAME, UIS_KEYCOLOR, UIS_WEB_LOGO_URL 등
    │
    └─ 5. redirect → /front/home/main.do (메인 페이지)
```

### 2.2 페이지 요청 인증 (인터셉터)

```
모든 페이지 요청
    │
    ▼
[IpAuthInterceptor.preHandle()]
    │
    ├─ IP 허용 확인 (findConfigByIp)
    │   └─ 실패 → www.bookers.life로 리다이렉트
    │
    ├─ 쿠키에서 sessionId 추출 (BKS_ZONE_SESSION)
    │
    ├─ 세션 검증 (validateSession)
    │   ├─ 세션 존재 + 만료 안됨 + IP 일치 → 통과
    │   ├─ refreshSession() → last_active_at 갱신
    │   └─ 쿠키 TTL 갱신 (renewSessionCookie)
    │
    └─ 세션 없음/만료 → /login으로 리다이렉트
        (단, /login, /, /zone/enter는 인터셉터 통과)
```

### 2.3 도서 열람 (웹뷰어)

```
도서 열기 버튼 클릭
    │
    ▼
[POST /api/guest/viewer] ─── GuestLoginController
    │
    ├─ ViewerService.getViewerUrl(sessionId, bookId)
    │   ├─ 세션 검증
    │   ├─ DRM 토큰 생성 (HMAC-SHA256)
    │   └─ 뷰어 URL 반환
    │
    └─ return ViewerRedirectResponse(viewerUrl)

[GET /front/myLibrary/webViewer.json] ─── WebviewerController
    │
    ├─ HttpSession에서 UM_CODE, UM_UIS_CODE 조회
    │
    └─ WebviewerService.processWebviewer()
        ├─ 서재 생성 (없으면)
        ├─ 도서 추가
        └─ DRM 뷰어 URL 반환
```

### 2.4 세션 정리 (스케줄러)

```
[SessionCleanupScheduler] ─── @Scheduled(fixedRate = 60000)
    │
    └─ ipAuthService.cleanupExpiredSessions()
        ├─ last_active_at < (현재 - 20분) 인 세션 조회
        └─ 일괄 DELETE
```

---

## 3. 패키지 구조

```
src/main/java/life/bks/zone/
├── config/                        # Spring 설정
│   ├── DataSourceConfig.java      #   단일 DataSource + MyBatis 설정
│   ├── WebConfig.java             #   인터셉터 등록 + CORS + 리소스 핸들러
│   └── SchedulerConfig.java       #   @EnableScheduling
│
├── controller/
│   ├── PageController.java        #   랜딩(/login) + 비회원 진입(/zone/enter)
│   ├── WebviewerController.java   #   웹뷰어 (/front/myLibrary/webViewer.json)
│   ├── ErrorController.java       #   에러 페이지
│   ├── auth/
│   │   ├── IpAuthController.java  #   REST: IP 인증 API (/api/ip-auth/**)
│   │   └── GuestLoginController.java  # REST: 뷰어 URL (/api/guest/viewer)
│   ├── home/                      #   [레거시] 메인, 도서 목록
│   ├── lounge/                    #   [레거시] 독서 라운지
│   └── mypage/                    #   [레거시] 마이페이지
│
├── service/
│   ├── auth/
│   │   ├── IpAuthService.java          # IP 인증 인터페이스
│   │   ├── IpAuthServiceImpl.java      # IP 인증 구현 (세션 CRUD, 동시접속 관리)
│   │   ├── GuestLoginService.java      # Guest 생성 인터페이스
│   │   ├── GuestLoginServiceImpl.java  # Guest 생성 구현 (세션당 개별 계정)
│   │   ├── ViewerService.java          # 뷰어 인터페이스
│   │   └── ViewerServiceImpl.java      # DRM 뷰어 URL 생성
│   ├── home/                      #   [레거시]
│   ├── lounge/                    #   [레거시]
│   ├── member/                    #   회원 서비스
│   ├── mypage/                    #   [레거시]
│   └── webviewer/                 #   웹뷰어 서비스
│
├── mapper/                        # MyBatis Mapper (신규 패턴)
│   ├── ZoneConfigMapper.java      #   TBL_ZONE_CONFIG
│   ├── IpAuthIpRangeMapper.java   #   TBL_IP_AUTH_IP_RANGE
│   ├── IpAuthSessionMapper.java   #   TBL_IP_AUTH_SESSION
│   ├── IpAuthLogMapper.java       #   TBL_IP_AUTH_LOG
│   ├── InstitutionMapper.java     #   TBL_INSTITUTION_MASTER
│   └── bookers/
│       ├── B2bMemberMapper.java   #   TBL_B2B_MEMBER_MASTER (회원)
│       └── WebviewerMapper.java   #   서재/도서 관련
│
├── domain/                        # DB 엔티티 (신규 패턴)
│   ├── ZoneConfig.java            #   기관 동시접속 설정
│   ├── IpAuthIpRange.java         #   IP 범위 패턴
│   ├── IpAuthSession.java         #   접속 세션
│   ├── IpAuthLog.java             #   인증 로그
│   ├── B2bMember.java             #   회원
│   ├── InstitutionInfo.java       #   기관 정보
│   └── WebviewerBook.java         #   도서 정보
│
├── dto/                           # API 요청/응답
│   ├── ApiResponse.java           #   공통 응답 래퍼
│   ├── IpAuthCheckResponse.java   #   IP 인증 확인 응답
│   ├── SessionCreateRequest.java  #   세션 생성 요청
│   ├── SessionCreateResponse.java #   세션 생성 응답 (sessionId + umCode)
│   ├── SessionValidateResponse.java # 세션 검증 응답
│   ├── ViewerRedirectResponse.java  # 뷰어 URL 응답
│   └── WebviewerResponse.java     #   웹뷰어 응답
│
├── interceptor/
│   └── IpAuthInterceptor.java     #   모든 요청 IP/세션 인증
│
├── scheduler/
│   └── SessionCleanupScheduler.java # 만료 세션 정리 (1분 주기)
│
├── util/
│   └── IpUtils.java               #   IP 추출, CIDR 매칭
│
├── dao/                           #   [레거시] 새 파일 추가 금지
└── vo/                            #   [레거시] 새 파일 추가 금지
```

---

## 4. 테이블 구조

### 4.1 Zone 전용 테이블 (DDL 관리 대상)

#### TBL_ZONE_CONFIG — 기관별 동시접속 설정
| 컬럼 | 타입 | 설명 |
|------|------|------|
| **uis_code** (PK) | VARCHAR(50) | 기관 코드 |
| max_concurrent | INT | 최대 동시접속 수 (기본 100) |
| created_at | DATETIME | 생성일 |
| updated_at | DATETIME | 수정일 (ON UPDATE) |

#### TBL_IP_AUTH_IP_RANGE — IP 범위 패턴
| 컬럼 | 타입 | 설명 |
|------|------|------|
| **id** (PK) | BIGINT AUTO_INCREMENT | |
| uis_code | VARCHAR(50) | 기관 코드 |
| ip_version | VARCHAR(10) | IPv4/IPv6 (기본 v4) |
| ip_pattern | VARCHAR(255) | 단일 IP 또는 CIDR |
| is_enabled | BOOLEAN | 활성화 여부 |
| created_at | DATETIME | 생성일 |
| updated_at | DATETIME | 수정일 |

#### TBL_IP_AUTH_SESSION — 접속 세션
| 컬럼 | 타입 | 설명 |
|------|------|------|
| **session_id** (PK) | VARCHAR(36) | UUID |
| uis_code | VARCHAR(50) | 기관 코드 |
| client_ip | VARCHAR(45) | 클라이언트 IP |
| user_agent | VARCHAR(512) | 브라우저 UA |
| um_code | VARCHAR(20) | 회원 코드 (정산용) |
| created_at | DATETIME | 생성일 |
| last_active_at | DATETIME | 마지막 활동 (만료 기준) |

#### TBL_IP_AUTH_LOG — 인증/열람 로그
| 컬럼 | 타입 | 설명 |
|------|------|------|
| **id** (PK) | BIGINT AUTO_INCREMENT | |
| session_id | VARCHAR(36) | 세션 ID |
| uis_code | VARCHAR(50) | 기관 코드 |
| client_ip | VARCHAR(45) | 클라이언트 IP |
| action | VARCHAR(50) | 액션 (ENTER, BOOK_VIEW 등) |
| book_id | VARCHAR(50) | 도서 ID (선택) |
| created_at | DATETIME | 생성일 |

### 4.2 참조하는 기존 테이블 (SELECT/UPDATE만)

| 테이블 | 용도 | Zone에서 하는 작업 |
|--------|------|-------------------|
| TBL_INSTITUTION_MASTER | 기관 정보 | SELECT (UIS_ZONE_FLAG='Y' 필터), 기관명/로고 등 조회 |
| TBL_B2B_MEMBER_MASTER | 회원 | INSERT (Zone guest 생성), SELECT |
| TBL_SEQUENCES | 시퀀스 | SELECT FOR UPDATE + UPDATE (MEMBER_MASTER_SEQ) |
| TBL_CONTENTS_MASTER | 도서 정보 | SELECT (웹뷰어) |
| TBL_MEMBER_LIBRARY | 회원 서재 | INSERT/SELECT (웹뷰어) |
| TBL_MEMBER_LIBRARY_BOOK | 서재 도서 | INSERT/SELECT (웹뷰어) |
| TBL_MEMBER_LIBRARY_BOOK_HISTORY | 열람 이력 | INSERT (웹뷰어) |
| TBL_MEMBER_DEVICE | 디바이스 | SELECT (마이페이지) |

### 4.3 삭제된 테이블

| 테이블 | 처리 | 대체 |
|--------|------|------|
| TBL_IP_AUTH_CONFIG | RENAME → TBL_IP_AUTH_CONFIG_BAK | TBL_ZONE_CONFIG + TBL_INSTITUTION_MASTER.UIS_ZONE_FLAG |

---

## 5. API 엔드포인트

### 5.1 REST API (`/api/**`)

| Method | URL | 설명 | 인터셉터 제외 |
|--------|-----|------|:---:|
| GET | `/api/ip-auth/check` | IP 인증 확인 (기관 정보 + 동시접속 현황) | O |
| POST | `/api/ip-auth/session` | 세션 생성 | O |
| GET | `/api/ip-auth/session/validate` | 세션 검증 | O |
| DELETE | `/api/ip-auth/session/{sessionId}` | 세션 삭제 (로그아웃) | O |
| GET | `/api/ip-auth/session/count` | 동시접속 수 조회 | O |
| POST | `/api/guest/viewer` | 뷰어 URL 요청 | O |

### 5.2 페이지 컨트롤러

| Method | URL | 설명 | 인터셉터 |
|--------|-----|------|:---:|
| GET | `/`, `/login` | 랜딩 페이지 | 제외 |
| GET | `/zone/enter` | 비회원 관내 진입 | 제외 |
| GET | `/front/home/main.do` | 메인 페이지 | 적용 |
| GET | `/front/myLibrary/webViewer.json` | 웹뷰어 | 적용 |

### 5.3 인터셉터 제외 패턴

```
/api/ip-auth/**    — IP 인증 API
/api/guest/**      — 게스트 API
/error/**          — 에러 페이지
/health            — 헬스체크
/css/**, /js/**, /images/**, /fonts/**, /font/**  — 정적 리소스
```

---

## 6. 설정

### 6.1 DataSource (단일)

```yaml
# application-dev.yml
spring.datasource:
  url: jdbc:mysql://133.186.244.130:3306/bookers_index_test2
  username: dev_user

# application-prod.yml
spring.datasource:
  url: jdbc:mysql://133.186.244.130:3306/bookers
  username: cmsBuker
```

### 6.2 MyBatis 설정

```java
@MapperScan(basePackages = "life.bks.zone.mapper")  // 모든 하위 패키지 포함
// mapUnderscoreToCamelCase = true
// typeAliasesPackage = "life.bks.zone.vo,life.bks.zone.domain"
// mapperLocations = "classpath:mappers/**/*.xml"
```

### 6.3 DRM 설정

```yaml
# dev
drm.token.secret-key: "테스트키"
drm.viewer.base-url: https://viewer.bookers.life

# prod
drm.token.secret-key: "운영키"
drm.viewer.base-url: https://newviewer.bookers.life
```

---

## 7. 동시성 제어

### 7.1 세션 생성 시 동시접속 제어

```
createSession() — @Transactional
  ├─ SELECT ... FROM TBL_ZONE_CONFIG WHERE uis_code = ? FOR UPDATE  ← 기관별 행 잠금
  ├─ 만료 세션 DELETE
  ├─ COUNT(*) 동시접속 확인
  ├─ maxConcurrent 초과 → 거부
  └─ INSERT 세션
```

`FOR UPDATE`로 같은 기관에 대한 동시 세션 생성 요청을 직렬화한다.

### 7.2 Guest 계정 생성 시 시퀀스 제어

```
createZoneGuest() — 외부 트랜잭션 참여 (@Transactional 없음)
  ├─ SELECT ... FROM TBL_SEQUENCES WHERE seq_name = ? FOR UPDATE  ← 시퀀스 잠금
  ├─ UPDATE seq_currval + 1
  └─ INSERT TBL_B2B_MEMBER_MASTER (고유 umCode 보장)
```

GuestLoginService는 `@Transactional`이 없어 IpAuthServiceImpl의 트랜잭션에 참여한다.
이로써 세션 생성 + guest 생성이 하나의 트랜잭션으로 묶인다.

---

## 8. 세션 생명주기

```
생성: /zone/enter → createSession()
  └─ 쿠키 BKS_ZONE_SESSION 설정 (maxAge=20분)
  └─ TBL_IP_AUTH_SESSION INSERT (last_active_at = NOW())

갱신: 매 요청마다 IpAuthInterceptor
  └─ refreshSession() → last_active_at = NOW()
  └─ 쿠키 TTL 갱신

만료: 마지막 활동 후 20분 경과
  └─ SessionCleanupScheduler (1분 주기) → DELETE
  └─ 또는 createSession() 내부에서 정리

삭제: DELETE /api/ip-auth/session/{id}
  └─ TBL_IP_AUTH_SESSION DELETE
  └─ 쿠키 삭제 (maxAge=0)
```

---

## 9. Guest 계정 (정산용)

### 왜 세션당 개별 계정인가?

같은 IP(같은 컴퓨터)에서 여러 사람이 순차적으로 접속할 수 있다.
각 사용자가 도서를 열람하면 주문(order)이 생성되고, 이를 기관별로 정산해야 한다.
따라서 **세션당 개별 UM_CODE**가 필요하다.

### Guest 계정 필드

| 필드 | 값 | 설명 |
|------|------|------|
| um_code | UM + LPAD(seq, 11, '0') | 고유 회원 코드 |
| um_userid | zone_{uisCode}_{seq} | 고유 사용자 ID |
| um_uis_code | 기관 코드 | 소속 기관 |
| um_reg_type | Z | Zone 관내이용자 |
| um_name | 관내이용자_{clientIp} | 표시 이름 |
| um_reg_userid | zone_system | 등록자 |
| um_useyn | Y | 사용 여부 |
| um_free_account | Y | **개발 전용** (운영 배포 시 제거) |

### ⚠️ 운영 배포 시 주의

`GuestLoginServiceImpl.java`에서 `.umFreeAccount("Y")` 라인을 **제거**해야 한다.
이 필드는 개발 환경에서 주문이 들어가지 않게 하기 위한 것이며, 운영에서는 불필요하다.

---

## 10. 기관 등록 절차

새로운 기관을 Zone 서비스에 등록하려면:

```sql
-- 1. 기관 Zone 활성화
UPDATE TBL_INSTITUTION_MASTER
SET UIS_ZONE_FLAG = 'Y'
WHERE UIS_CODE = '기관코드';

-- 2. 동시접속 설정
INSERT INTO TBL_ZONE_CONFIG (uis_code, max_concurrent)
VALUES ('기관코드', 100);

-- 3. IP 범위 등록 (기관당 N개)
INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('기관코드', '210.95.17.119');  -- 단일 IP

INSERT INTO TBL_IP_AUTH_IP_RANGE (uis_code, ip_pattern)
VALUES ('기관코드', '192.168.1.0/24');  -- CIDR 범위
```

---

## 11. 마이그레이션 이력

| 파일 | 내용 | 상태 |
|------|------|------|
| V001_ip_auth_table_separation.sql | TBL_IP_AUTH_IP_RANGE 생성 + IP 데이터 분리 | 실행 완료 |
| V003_zone_config_migration.sql | TBL_ZONE_CONFIG 생성 + UIS_ZONE_FLAG 설정 + TBL_IP_AUTH_CONFIG 백업 | 실행 완료 |
| DDL_zone_tables.sql | 전체 테이블 CREATE/DROP DDL (참조용) | — |
| DEPLOY_all_migrations.sql | V001+V003 통합 실행 스크립트 | 실행 완료 |
| V002_fieldtest_jeonnam_edu.sql | 전라남도교육청 필드테스트 데이터 | 대기 |

---

## 12. 빌드 및 실행

```bash
# 빌드
./gradlew build

# 실행 (기본)
./gradlew bootRun

# 개발 테스트 (포트 8082)
nohup ./gradlew bootRun -x test --args='--server.port=8082' > /tmp/bootrun8082.log 2>&1 &

# 테스트
./gradlew test

# 클린 빌드
./gradlew clean build
```
