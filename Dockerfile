# Stage 1: Build-Umgebung mit vorinstalliertem Maven
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Dependencies cachen
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Quellcode kopieren und JAR erstellen
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Schlankes Runtime-Image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

RUN useradd -m appuser && chown -R appuser /app
USER appuser

COPY --from=builder /app/target/testAcr-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]