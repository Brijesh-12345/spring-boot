# ---------- Stage 1 : Build ----------
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests


# ---------- Stage 2 : Runtime ----------
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# create non-root user
RUN useradd -m appuser

# copy only jar from build stage
COPY --from=build /build/target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]


