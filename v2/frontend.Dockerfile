FROM maven:3.6.3-adoptopenjdk-8 AS maven-builder
COPY spring-boot-http-service /spring-boot-http-service
WORKDIR /spring-boot-http-service
RUN mvn package


FROM node:lts-buster AS node-builder
COPY phrase-frontend /phrase-frontend
WORKDIR /phrase-frontend
RUN npm install && npm run prod


FROM busybox AS tomcat-builder
RUN wget http://ftp.man.poznan.pl/apache/tomcat/tomcat-9/v9.0.36/bin/apache-tomcat-9.0.36.tar.gz
RUN tar zxf apache-tomcat-9.0.36.tar.gz
RUN rm -rf apache-tomcat-9.0.36/webapps/docs \
    apache-tomcat-9.0.36/webapps/examples \
    apache-tomcat-9.0.36/webapps/host-manager \
    apache-tomcat-9.0.36/webapps/manager \
    apache-tomcat-9.0.36/webapps/ROOT/*.* 


FROM adoptopenjdk:8u252-b09-jre-hotspot-bionic
RUN groupadd -r app && useradd --create-home -r -g app app
USER app
COPY --chown=app:app --from=tomcat-builder /apache-tomcat-9.0.36 /home/app/apache-tomcat-9.0.36
COPY --chown=app:app --from=maven-builder /spring-boot-http-service/target/spring-boot-http-service.war /home/app/apache-tomcat-9.0.36/webapps/
COPY --chown=app:app --from=node-builder /phrase-frontend/dist/phrase-frontend/* /home/app/apache-tomcat-9.0.36/webapps/ROOT/

EXPOSE 8080
CMD ["/home/app/apache-tomcat-9.0.36/bin/catalina.sh", "run"]
