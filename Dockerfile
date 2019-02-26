##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

FROM zerodowntime/centos

ARG RUNDECK_VERSION=3.0.13-20190123
ARG EXTRA_PACKAGES

EXPOSE 4440

RUN yum -y install \
      gettext \
      git \
      java-1.8.0 \
      python-virtualenv \
      $EXTRA_PACKAGES \
    && yum clean all && rm -rf /var/cache/yum

RUN useradd --home-dir /home/rundeck --shell /bin/bash rundeck

USER rundeck
WORKDIR /home/rundeck

RUN curl -L "https://dl.bintray.com/rundeck/rundeck-maven/rundeck-$RUNDECK_VERSION.war" --output rundeck.war

RUN java -jar rundeck.war --installonly && \
    mkdir /home/rundeck/server/logs /home/rundeck/var/storage

COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d

COPY docker-entrypoint.sh /

VOLUME /home/rundeck/server/data
VOLUME /home/rundeck/server/logs
VOLUME /home/rundeck/projects
VOLUME /home/rundeck/var/storage

ENTRYPOINT ["/docker-entrypoint.sh"]
