##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

FROM centos:7

ARG RUNDECK_VERSION=3.0.13-20190123
ARG EXTRA_PACKAGES

EXPOSE 4440

RUN yum -y install \
      gettext \
      git \
      java-1.8.0 \
      python-virtualenv \
      https://repo.rundeck.org/latest.rpm \
      $EXTRA_PACKAGES \
    && yum clean all && rm -rf /var/cache/yum

RUN useradd --home-dir /home/rundeck --shell /bin/bash rundeck

USER rundeck
WORKDIR /home/rundeck

RUN curl -L "https://dl.bintray.com/rundeck/rundeck-maven/rundeck-$RUNDECK_VERSION.war" --output rundeck.war

RUN java -jar rundeck.war --installonly && \
    mkdir /home/rundeck/server/logs /home/rundeck/var/storage

COPY templates /templates
COPY docker-entrypoint.sh /

VOLUME /home/rundeck/server/data
VOLUME /home/rundeck/server/logs
VOLUME /home/rundeck/var/storage

ENTRYPOINT ["/docker-entrypoint.sh"]
