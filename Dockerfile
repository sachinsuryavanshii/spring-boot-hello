# Multi-stage or lightweight JRE 21 runtime image
FROM eclipse-temurin:21-jre-alpine

LABEL maintainer="Antigravity Student"
LABEL description="Spring Boot Hello Service"

WORKDIR /app

# Copy the built jar from target directory
COPY target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
