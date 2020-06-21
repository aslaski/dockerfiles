FROM maven:3.6.3-adoptopenjdk-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#install node
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
#   nodejs \
#   yarn \
#   && rm -rf /var/lib/apt/lists/*

RUN groupadd -r app && useradd --create-home -r -g app app
USER app
ENV MAVEN_CONFIG "/home/app/.m2"

WORKDIR /home/app

# java
COPY --chown=app:app spring-boot-http-service /home/app/spring-boot-http-service
WORKDIR /home/app/spring-boot-http-service
RUN mvn package
WORKDIR /home/app
RUN mv spring-boot-http-service/target/spring-boot-http-service.war /home/app
RUN rm -rf /home/app/spring-boot-http-service

# compile javascript
# TODO
#COPY phrase-frontend /phrase-frontend
#WORKDIR /phrase-frontend

# tomcat
RUN curl -O http://ftp.man.poznan.pl/apache/tomcat/tomcat-9/v9.0.36/bin/apache-tomcat-9.0.36.tar.gz
RUN tar zxf apache-tomcat-9.0.36.tar.gz
RUN rm -rf apache-tomcat-9.0.36/webapps/docs apache-tomcat-9.0.36/webapps/examples apache-tomcat-9.0.36/webapps/host-manager apache-tomcat-9.0.36/webapps/manager
RUN mv spring-boot-http-service.war apache-tomcat-9.0.36/webapps/

EXPOSE 8080
CMD ["/home/app/apache-tomcat-9.0.36/bin/catalina.sh", "run"]
