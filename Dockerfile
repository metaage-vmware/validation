# maven build
FROM maven:3-jdk-11-slim AS build

ENV HOME=/app
RUN mkdir -p $HOME
WORKDIR app

# resolve maven dependency download to cache layer
ADD ./pom.xml $HOME
RUN mvn -ntp -B dependency:go-offline -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true
# package srping app
ADD ./src $HOME/src
#RUN echo "$MAVEN_CONFIG"
RUN mvn -ntp -B package spring-boot:repackage -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true

# docker build
FROM harbor.metaage.tech/base/core:jre-11 AS runtime
COPY --from=build /app/target/validation.jar /root
# if you want to prevent zombei proccess, try to uncomment next line.
# RUN apk set ENTRYPOINT [--no-cache, tini, ...]

ENTRYPOINT java -jar /root/validation.jar