FROM maven:3.6.3-adoptopenjdk-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# switch to a non-root user
RUN groupadd -r app && useradd --create-home -r -g app app
USER app
ENV MAVEN_CONFIG "/home/app/.m2"

WORKDIR /home/app

# compile Java
COPY --chown=app:app spring-boot-http-service /home/app/spring-boot-http-service
WORKDIR /home/app/spring-boot-http-service
RUN mvn package
WORKDIR /home/app
RUN mv spring-boot-http-service/target/spring-boot-http-service.war /home/app
RUN rm -rf /home/app/spring-boot-http-service

# compile JavaScript
COPY --chown=app:app phrase-frontend /home/app/phrase-frontend
WORKDIR /home/app/phrase-frontend
RUN npm install && npm run prod

# download Tomcat
WORKDIR /home/app/
RUN curl -O http://ftp.man.poznan.pl/apache/tomcat/tomcat-9/v9.0.38/bin/apache-tomcat-9.0.38.tar.gz
RUN tar zxf apache-tomcat-9.0.38.tar.gz
RUN rm -rf apache-tomcat-9.0.38/webapps/docs apache-tomcat-9.0.38/webapps/examples apache-tomcat-9.0.38/webapps/host-manager apache-tomcat-9.0.38/webapps/manager
WORKDIR /home/app/apache-tomcat-9.0.38/

#install Java application in Tomcat 
RUN mv /home/app/spring-boot-http-service.war webapps/
RUN rm webapps/ROOT/*.*

#install JavaScript application in Tomcat  
RUN mv /home/app/phrase-frontend/dist/phrase-frontend/* webapps/ROOT/

EXPOSE 8080
CMD ["/home/app/apache-tomcat-9.0.38/bin/catalina.sh", "run"]