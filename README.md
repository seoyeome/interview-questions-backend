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

### 답변 관련
- POST /api/questions/{id}/answers - 답변 추가
- PUT /api/questions/{id}/answers/{answerId} - 답변 수정
- DELETE /api/questions/{id}/answers/{answerId} - 답변 삭제

## 개발 환경 설정

프로젝트를 실행하기 위해서는 Java 17 이상이 필요합니다.



서버는 기본적으로 http://localhost:8080에서 실행됩니다.