FROM maven:3.6.3-adoptopenjdk-8

COPY spring-boot-http-service /spring-boot-http-service
WORKDIR /spring-boot-http-service
RUN mvn package
WORKDIR /
RUN mv spring-boot-http-service/target/spring-boot-http-service-0.0.1-SNAPSHOT.jar .
RUN rm -rf spring-boot-http-service
RUN groupadd -r app && useradd -r -g app app
RUN chown app spring-boot-http-service-0.0.1-SNAPSHOT.jar

USER app
EXPOSE 8080
CMD ["java", "-jar", "spring-boot-http-service-0.0.1-SNAPSHOT.jar"]
