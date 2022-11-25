# maven build
FROM maven:3-jdk-11-slim AS build
ENV SKIP_SSL="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"
WORKDIR /source

# resolve maven dependency download to cache layer
ADD ./pom.xml ./
RUN mvn -ntp -B dependency:go-offline $SKIP_SSL
# package srping app
ADD ./src ./src
#RUN echo "$MAVEN_CONFIG"
RUN mvn -ntp -B -DskipTests package $SKIP_SSL

# docker build
FROM harbor.metaage.tech/base/core:jre-11 AS runtime
ENV APP_HOME=/app
COPY --from=build /source/target/validation.jar ./app.jar
# if you want to prevent zombei proccess, try to uncomment next line.
# RUN apk set ENTRYPOINT [--no-cache, tini, ...]

ENTRYPOINT java -jar ./app.jar