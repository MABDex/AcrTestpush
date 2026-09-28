# Stage 1: Build-Umgebung
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /app

# Maven Wrapper & Dependencies vorab cachen
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Ausführungsrechte für mvnw vergeben:
RUN chmod +x mvnw

RUN ./mvnw dependency:go-offline -B || true

# Quellcode kopieren und Paket bauen (Tests im Build überspringen)
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Schlankes Runtime-Image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Nicht-Root-Benutzer für Sicherheit
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Gebautes JAR aus Stage 1 übernehmen
COPY --from=builder /app/target/testAcr-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]