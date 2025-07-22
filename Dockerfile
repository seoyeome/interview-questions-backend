FROM openjdk:17-jdk-slim

WORKDIR /app

COPY build/libs/*.jar app.jar

# 포트 관리 스크립트 실행
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/app/docker-entrypoint.sh"]
