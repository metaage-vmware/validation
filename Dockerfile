# maven build
FROM maven:3-jdk-11-slim AS build
WORKDIR /source

# resolve maven dependency download to cache layer
ADD ./pom.xml ./
RUN mvn -ntp -B dependency:go-offline
# package srping app
ADD ./src ./src
#RUN echo "$MAVEN_CONFIG"
RUN mvn -ntp -B -DskipTests package && \
    mkdir -p target/dependency && \
    (cd target/dependency; jar -xf ../*.jar)

# docker build
FROM harbor.metaage.tech/test/core:jre-11-mcr AS runtime

ENV APP_HOME=/app
ARG DEPENDENCY=/source/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib ${APP_HOME}/lib
COPY --from=build ${DEPENDENCY}/META-INF ${APP_HOME}/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes ${APP_HOME}
# if you want to prevent zombei proccess, try to uncomment next line.
# RUN apk set ENTRYPOINT [--no-cache, tini, ...]
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.sysage.validation.ServerApplication"]