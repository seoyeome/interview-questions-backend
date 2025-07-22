# 📚 Interview Questions Backend

면접 질문을 관리하고 학습할 수 있는 웹 애플리케이션의 백엔드 프로젝트입니다.

## 🛠 기술 스택

### 프레임워크 & 라이브러리
- [Spring Boot](https://spring.io/projects/spring-boot) - 자바/코틀린 웹 애플리케이션 프레임워크
- [Kotlin](https://kotlinlang.org/) - JVM 기반 프로그래밍 언어
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa) - ORM 프레임워크
- [QueryDSL](http://querydsl.com/) - 타입 안전 쿼리 빌더
- [Flyway](https://flywaydb.org/) - 데이터베이스 마이그레이션 관리

### 보안
- [Spring Security](https://spring.io/projects/spring-security) - 인증 및 권한 관리
- [JWT](https://jwt.io/) - JSON Web Token 기반 인증

### 데이터베이스
- [PostgreSQL](https://www.postgresql.org/) - 관계형 데이터베이스

### API 문서화
- [SpringDoc OpenAPI](https://springdoc.org/) - OpenAPI 3.0 문서 자동 생성

### 성능 최적화
- [Spring Cache](https://docs.spring.io/spring-framework/reference/integration/cache.html) - 캐싱 지원
- [Caffeine](https://github.com/ben-manes/caffeine) - 고성능 캐싱 라이브러리

### 모니터링
- [Spring Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html) - 애플리케이션 모니터링
- [Micrometer](https://micrometer.io/) - 메트릭 수집 및 Prometheus 연동

### 비동기 처리
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html) - 비동기 프로그래밍

### 개발 도구
- [Gradle](https://gradle.org/) - 빌드 자동화 도구
- [JUnit 5](https://junit.org/junit5/) - 테스트 프레임워크
- [MockK](https://mockk.io/) - 코틀린 모킹 라이브러리

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
./gradlew bootRun
```

또는 Docker를 사용하여 실행할 수 있습니다:

```bash
# 백엔드만 실행
docker build -t interview-questions-backend .
docker run -p 8080:8080 -e DB_USERNAME=postgres -e DB_PASSWORD=postgres interview-questions-backend

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
│   │           ├── config/           # 애플리케이션 설정
│   │           └── interview/
│   │               ├── domain/       # 도메인 모델 및 비즈니스 로직
│   │               │   ├── category/     # 카테고리 관련 기능
│   │               │   ├── question/     # 질문 관련 기능
│   │               │   └── subcategory/  # 서브카테고리 관련 기능
│   │               └── global/       # 전역 설정 및 유틸리티
│   └── resources/
│       ├── db/
│       │   └── migration/        # Flyway 마이그레이션 스크립트
│       └── application*.yml      # 애플리케이션 설정 파일
└── test/                         # 테스트 코드
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

- `/api/categories` - 카테고리 관리
- `/api/subcategories` - 서브카테고리 관리
- `/api/questions` - 질문 관리
- `/api/auth` - 인증 및 사용자 관리
- `/actuator` - 애플리케이션 상태 모니터링

자세한 API 문서는 애플리케이션 실행 후 Swagger UI에서 확인할 수 있습니다.

## 🔒 환경 변수

애플리케이션 실행에 필요한 환경 변수:

- `DB_USERNAME` - 데이터베이스 사용자 이름
- `DB_PASSWORD` - 데이터베이스 비밀번호
- `DB_HOST` - 데이터베이스 호스트 (기본값: localhost)
- `DB_PORT` - 데이터베이스 포트 (기본값: 5432)
- `DB_NAME` - 데이터베이스 이름 (기본값: interview_questions)

## 📝 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.
