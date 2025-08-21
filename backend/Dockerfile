# ===== Builder stage =====
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom and download deps first (better cache)
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -DskipTests clean package

# ===== Runtime stage =====
FROM openjdk:17-jdk-slim
WORKDIR /

# Install curl for healthchecks used by docker-compose
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Copy built jar
COPY --from=builder /app/target/*.jar /app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"] 
