# Interview Questions Backend

면접 준비를 위한 질문과 답변을 관리하는 웹 애플리케이션의 백엔드 부분입니다.

## 기술 스택

- Spring Boot
- Java
- Gradle
- Spring Data JPA
- H2 Database (개발용)

## API 엔드포인트

### 질문 관련
- GET /api/questions - 모든 질문 조회
- GET /api/questions/{id} - 특정 질문 조회
- POST /api/questions - 새로운 질문 추가
- PUT /api/questions/{id} - 질문 수정
- DELETE /api/questions/{id} - 질문 삭제