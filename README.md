# 📚 Interview Questions Backend

면접 질문을 관리하고 학습할 수 있는 웹 애플리케이션의 백엔드 프로젝트입니다.

## 🛠 기술 스택

### 프레임워크 & 라이브러리
- [Spring Boot](https://spring.io/projects/spring-boot) 3.2 - 자바/코틀린 웹 애플리케이션 프레임워크
- [Kotlin](https://kotlinlang.org/) - JVM 기반 프로그래밍 언어
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa) - ORM 프레임워크
- [QueryDSL](http://querydsl.com/) - 타입 안전 쿼리 빌더
- [Flyway](https://flywaydb.org/) - 데이터베이스 마이그레이션 관리

### 인증 & 보안
- [Spring Security](https://spring.io/projects/spring-security) - 인증 및 권한 관리
- [JWT](https://jwt.io/) - JSON Web Token 기반 쿠키 인증 (HttpOnly, Secure)
- [OAuth 2.0](https://oauth.net/2/) - 소셜 로그인 (카카오)
- 개인정보보호법 준수 Soft Delete 구현

### 데이터베이스
- [PostgreSQL](https://www.postgresql.org/) - 관계형 데이터베이스

### AI 통합
- [Google Gemini API](https://ai.google.dev/) - AI 기반 질문 설명 생성

### API 문서화
- [SpringDoc OpenAPI](https://springdoc.org/) - OpenAPI 3.0 문서 자동 생성

### 성능 최적화
- [Spring Cache](https://docs.spring.io/spring-framework/reference/integration/cache.html) - 캐싱 지원
- [Caffeine](https://github.com/ben-manes/caffeine) - 고성능 캐싱 라이브러리

### 모니터링 & 로깅
- [Spring Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html) - 애플리케이션 모니터링
- [Micrometer](https://micrometer.io/) - 메트릭 수집 및 Prometheus 연동
- [Sentry](https://sentry.io/) - 실시간 에러 추적 및 모니터링
- [Grafana Cloud](https://grafana.com/) - 메트릭 시각화 및 대시보드

### 스케줄링
- [Spring Scheduling](https://spring.io/guides/gs/scheduling-tasks) - 자동화 작업 스케줄링
- 매일 새벽 3시 30일 경과 사용자 데이터 자동 삭제

### 비동기 처리
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html) - 비동기 프로그래밍

### 개발 도구
- [Gradle](https://gradle.org/) - 빌드 자동화 도구
- [JUnit 5](https://junit.org/junit5/) - 테스트 프레임워크
- [MockK](https://mockk.io/) - 코틀린 모킹 라이브러리

## ✨ 주요 기능

### 질문 관리
- 카테고리/서브카테고리별 질문 분류
- 질문 검색 및 필터링
- AI 기반 질문 설명 자동 생성 (Google Gemini)

### 사용자 인증 & 관리
- 이메일/비밀번호 기반 회원가입/로그인
- 카카오 OAuth 2.0 소셜 로그인
- JWT 토큰 기반 쿠키 인증 (HttpOnly, Secure, SameSite=None)
- 사용자 프로필 관리 (닉네임 수정, 비밀번호 변경)
- 역할 기반 권한 관리 (USER, ADMIN)

### 개인정보보호법 준수
- **Soft Delete 방식의 회원 탈퇴**
  - 탈퇴 즉시 로그인 차단
  - 30일간 데이터 보관 (법적 요구사항 대응)
  - 30일 경과 후 자동 완전 삭제
- **카카오 OAuth 연결 해제**
  - 회원 탈퇴 시 카카오 계정 연결 자동 해제
- **자동 정리 스케줄러**
  - 매일 새벽 3시 실행
  - 보관 기간 경과 데이터 자동 삭제

### 모니터링 & 관찰성
- Sentry를 통한 실시간 에러 추적
- Grafana Cloud를 통한 메트릭 수집 및 시각화
- Spring Actuator 헬스 체크 엔드포인트

## 🚀 시작하기

### 필수 요구사항
- JDK 17 이상
- PostgreSQL 14 이상
- Docker (선택 사항)

### 설치 방법

1. 저장소 클론
```bash
git clone git@github.com:seoyeome/interview-questions-backend.git
cd interview-questions-backend
```

2. 환경 변수 설정
```bash
# .env.example 파일을 복사하여 .env 파일 생성
cp ../.env.example ../.env

# 필요한 경우 .env 파일 편집하여 실제 값으로 변경
```

3. 애플리케이션 빌드
```bash
./gradlew build
```

4. 애플리케이션 실행
```bash
# 환경 변수 설정 후 실행
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
export GEMINI_API_KEY=your_gemini_api_key
export KAKAO_CLIENT_ID=your_kakao_client_id
export KAKAO_CLIENT_SECRET=your_kakao_client_secret
export JWT_SECRET=your_jwt_secret
./gradlew bootRun
```

또는 Docker를 사용하여 실행할 수 있습니다:

```bash
# 백엔드만 실행
docker build -t interview-questions-backend .
docker run -p 8080:8080 \
  -e DB_USERNAME=postgres \
  -e DB_PASSWORD=postgres \
  -e GEMINI_API_KEY=your_key \
  interview-questions-backend

# 또는 Docker Compose로 전체 스택 실행
cd ..
docker-compose up -d
```

이제 [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)에서 API 문서를 확인할 수 있습니다.

## 📁 프로젝트 구조

```
src/
├── main/
│   ├── kotlin/
│   │   └── com/
│   │       └── example/
│   │           └── interview/
│   │               ├── InterviewApplication.kt    # 메인 애플리케이션
│   │               ├── domain/                    # 도메인 모델 및 비즈니스 로직
│   │               │   ├── ai/                    # AI 질문 생성
│   │               │   ├── auth/                  # 인증 (회원가입, 로그인)
│   │               │   ├── category/              # 카테고리 관리
│   │               │   ├── question/              # 질문 관리
│   │               │   ├── subcategory/           # 서브카테고리 관리
│   │               │   └── user/                  # 사용자 관리
│   │               │       ├── domain/            # User 엔티티, Repository
│   │               │       └── presentation/      # UserController (프로필, 탈퇴)
│   │               └── infrastructure/            # 인프라 계층
│   │                   ├── ai/                    # Gemini API 통합
│   │                   ├── common/                # 공통 DTO (ApiResponse)
│   │                   ├── config/                # 설정 클래스
│   │                   ├── oauth/                 # 카카오 OAuth 연동
│   │                   ├── scheduler/             # 자동 정리 스케줄러
│   │                   ├── security/              # JWT, OAuth2 핸들러
│   │                   └── webhook/               # 웹훅 처리
│   └── resources/
│       ├── db/
│       │   └── migration/                    # Flyway 마이그레이션 스크립트
│       └── application*.yml                   # 애플리케이션 설정 파일
└── test/                                      # 테스트 코드
```

## 🔧 설정 파일

- `application.yml` - 기본 애플리케이션 설정
- `application-docker.yml` - Docker 환경 설정
- `application-prod.yml` - 프로덕션 환경 설정
- `build.gradle.kts` - Gradle 빌드 설정
- `Dockerfile` - Docker 이미지 빌드 설정
- `railway.json` - Railway 배포 설정

## 🌐 API 엔드포인트

주요 API 엔드포인트는 다음과 같습니다:

### 인증 & 사용자
- `POST /api/v1/auth/signup` - 회원가입
- `POST /api/v1/auth/login` - 로그인
- `POST /api/v1/auth/logout` - 로그아웃
- `GET /oauth2/authorization/kakao` - 카카오 OAuth 로그인 시작
- `GET /api/v1/user/profile` - 프로필 조회
- `PATCH /api/v1/user/nickname` - 닉네임 수정
- `PATCH /api/v1/user/password` - 비밀번호 변경
- `DELETE /api/v1/user` - 회원 탈퇴 (Soft Delete)

### 질문 관리
- `GET /api/questions` - 질문 목록 조회
- `GET /api/questions/{id}` - 질문 상세 조회
- `POST /api/questions` - 질문 생성 (ADMIN)
- `PUT /api/questions/{id}` - 질문 수정 (ADMIN)
- `DELETE /api/questions/{id}` - 질문 삭제 (ADMIN)
- `POST /api/questions/{id}/generate-explanation` - AI 설명 생성

### 카테고리 관리
- `GET /api/categories` - 카테고리 목록
- `POST /api/categories` - 카테고리 생성 (ADMIN)
- `GET /api/subcategories` - 서브카테고리 목록
- `POST /api/subcategories` - 서브카테고리 생성 (ADMIN)

### 모니터링
- `GET /actuator/health` - 애플리케이션 상태 확인
- `GET /actuator/metrics` - 메트릭 정보

자세한 API 문서는 애플리케이션 실행 후 Swagger UI에서 확인할 수 있습니다.

## 🔒 환경 변수

애플리케이션 실행에 필요한 환경 변수:

### 데이터베이스
- `DB_USERNAME` - 데이터베이스 사용자 이름
- `DB_PASSWORD` - 데이터베이스 비밀번호
- `DB_HOST` - 데이터베이스 호스트 (기본값: localhost)
- `DB_PORT` - 데이터베이스 포트 (기본값: 5432)
- `DB_NAME` - 데이터베이스 이름 (기본값: interview_questions)

### 인증 & 보안
- `JWT_SECRET` - JWT 토큰 서명 키 (Base64 인코딩된 256비트 이상 키)
- `KAKAO_CLIENT_ID` - 카카오 OAuth 클라이언트 ID
- `KAKAO_CLIENT_SECRET` - 카카오 OAuth 클라이언트 시크릿

### AI 통합
- `GEMINI_API_KEY` - Google Gemini API 키

### 모니터링 (선택 사항)
- `SENTRY_DSN` - Sentry 에러 추적 DSN
- `GRAFANA_OTLP_ENDPOINT` - Grafana OTLP 엔드포인트
- `GRAFANA_INSTANCE_ID` - Grafana 인스턴스 ID
- `GRAFANA_API_KEY` - Grafana API 키

## 🗄️ 데이터베이스 스키마

주요 테이블:
- `users` - 사용자 정보 (이메일, 닉네임, 비밀번호, OAuth 정보, 탈퇴 상태)
- `categories` - 질문 카테고리
- `subcategories` - 서브카테고리
- `questions` - 면접 질문 및 AI 생성 설명
- `flyway_schema_history` - 마이그레이션 이력

## 📊 모니터링

### Sentry
- 실시간 에러 추적 및 스택 트레이스
- 성능 모니터링
- 릴리스 추적

### Grafana Cloud
- 애플리케이션 메트릭 수집
- 커스텀 대시보드
- 알림 설정

## 🔐 보안 고려사항

- JWT 토큰은 HttpOnly, Secure 쿠키로 저장 (XSS 공격 방지)
- SameSite=None 설정으로 CORS 환경 지원
- 비밀번호는 BCrypt로 해시화
- OAuth 액세스 토큰은 암호화된 데이터베이스에 저장
- 개인정보보호법 준수를 위한 30일 데이터 보관 정책

## 📝 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.
