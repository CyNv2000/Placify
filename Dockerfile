# Build the Spring Boot backend from the repository root used by Render.
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY backend/pom.xml .
RUN mvn dependency:go-offline -B
COPY backend/src ./src
RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN mkdir -p /tmp/uploads
COPY --from=build /app/target/TnP_Connect-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
