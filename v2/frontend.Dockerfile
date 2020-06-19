FROM maven:3.6.3-adoptopenjdk-8 AS builder

COPY spring-boot-http-service /spring-boot-http-service
WORKDIR /spring-boot-http-service
RUN mvn package

FROM adoptopenjdk:8-jre-hotspot
RUN groupadd -r app && useradd -r -g app app
COPY --from=builder --chown=app:app spring-boot-http-service/target/spring-boot-http-service-0.0.1-SNAPSHOT.jar .

USER app
EXPOSE 8080
CMD ["java", "-jar", "spring-boot-http-service-0.0.1-SNAPSHOT.jar"]
