# Build stage
FROM amazoncorretto:17-alpine AS builder

WORKDIR /build

# Copy Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .
COPY gradle.properties .

# Copy source code
COPY src src

# Make gradlew executable and build
RUN chmod +x gradlew && ./gradlew bootJar --no-daemon -x test

# Runtime stage
FROM amazoncorretto:17-alpine

WORKDIR /app

# Copy JAR from build stage
COPY --from=builder /build/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]