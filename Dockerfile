# syntax=docker/dockerfile:1.4
# maven build
FROM maven:3-jdk-11-slim AS build
ADD ./src /app/src
ADD ./pom.xml /app
WORKDIR app
#RUN ls -alh
#RUN echo "$MAVEN_CONFIG"
RUN mvn clean package spring-boot:repackage -B -DskipTests -X
COPY --link /app/target/validation.jar /target

FROM harbor.metaage.tech/base/core:jre-11 AS runtime
COPY target/validation.jar /root
# if you want to prevent zombei proccess, try to uncomment next line.
# RUN apk set ENTRYPOINT [--no-cache, tini, ...]

ENTRYPOINT java -jar /root/validation.jar