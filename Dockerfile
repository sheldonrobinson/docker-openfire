FROM alpine:latest
LABEL maintainer="Sheldon Robinson <sheldon.robinson@gmail.com>" \
      maintainer.org="SJ Robinson Consulting" \
      maintainer.org.uri="https://sjrobinsonconsulting.com" \
      version="wood-dragon.1" \
      description="Ignite Realtime Openfire Server image based on Alpine Linux with OpenJDK-17-jre." \
      # custom properties
      com.sjrobinsonconsulting.vendor="SJ Robinson Consulting" \
      com.sjrobinsonconsulting.image.authors="sheldon@sjrobiunsonconsulting.com" \
      # Open container labels
      org.opencontainers.image.version="wood-dragon.1" \
      org.opencontainers.image.description="Ignite Realtime Openfire image based on Alpine Linux" \
      org.opencontainers.image.vendor="SJ Robinson Consulting" \
      org.opencontainers.image.source="https://github.com/sheldonrobinson/docker-openfire"

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
    OPENFIRE_HOME=/var/lib/openfire

    
RUN echo "Updating package list ..." \
 && apk update \
 && echo "Installing openfire and dependencies ..." \
 && apk add --no-cache --upgrade openjdk17-jre-headless java-postgresql-jdbc \
 && apk add --no-cache --upgrade openfire openfire-plugins \
 && echo "Clear cache and fix missing .." \
 && apk cache -v sync 

ENV OPENFIRE_OPTS="-server -DopenfireHome=${OPENFIRE_HOME} -Dopenfire.lib.dir=${OPENFIRE_HOME}/lib -classpath ${OPENFIRE_HOME}/lib/startup.jar"

ARG JAVA_OPTS="-Xmx4G -Xms4G -XX:NewRatio=1 -XX:SurvivorRatio=4 -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:CMSFullGCsBeforeCompaction=1 -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly"
 
ADD --chown=openfire:openfire --chmod=644 https://igniterealtime.org/projects/openfire/plugins/1.0.0/authfiltersanitizer.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.0.1/avatarResizer.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.1.1/bookmarks.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.1.1/certificatemanager.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.9.2/broadcast.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.2.3/dbaccess.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.0.0/exi.jar \
 https://igniterealtime.org/projects/openfire/plugins/2.2.4/gojara.jar \
 https://igniterealtime.org/projects/openfire/plugins/2.6.1/hazelcast.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.0.0/jidvalidation.jar \
 https://igniterealtime.org/projects/openfire/plugins/2.5.0/monitoring.jar \
 https://igniterealtime.org/projects/openfire/plugins/3.3.2/packetFilter.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.10.2/restAPI.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.3.0/userstatus.jar \
 https://igniterealtime.org/projects/openfire/plugins/1.7.4/search.jar \
 /var/lib/openfire/plugins/


RUN echo "Creating logs files ..." 
RUN mkdir -p /var/lib/openfire/logs && touch /var/lib/openfire/logs/openfire.log  && chown -R openfire /var/lib/openfire/logs && chgrp -R openfire /var/lib/openfire/logs
RUN touch /var/log/openfire.log && chown openfire /var/log/openfire.log && chgrp openfire /var/log/openfire.log

RUN echo "OPENFIRE_OPTS=${OPENFIRE_OPTS}"
RUN echo "JAVA_OPTS=${JAVA_OPTS}"

VOLUME ["${OPENFIRE_HOME}/conf", "${OPENFIRE_HOME}/logs", "${OPENFIRE_HOME}/lib", "${OPENFIRE_HOME}/resources/security/hotdeploy", "/var/log"]
EXPOSE 5222/tcp 5223/tcp 5229/tcp 5262/tcp 5263/tcp 5275/tcp 5276/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp
ENTRYPOINT ["sh", "-c", "${JAVA_HOME}/bin/java ${JAVA_OPTS} ${OPENFIRE_OPTS} -jar ${OPENFIRE_HOME}/lib/startup.jar" ]
