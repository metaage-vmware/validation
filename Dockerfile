FROM harbor.sysage.com.tw/base/core

COPY target/validation.jar /root
# if you want to prevent zombei proccess, try to uncomment next line.
# RUN apk set ENTRYPOINT [--no-cache, tini, ...]

ENTRYPOINT java -jar /root/validation.jar