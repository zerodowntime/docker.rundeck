#!/bin/bash -e

if [ -z ${RUNDECK_SERVER_UUID:+ok} ]; then
  export RUNDECK_SERVER_UUID="$(uuidgen)"
fi

if [ -z ${RUNDECK_GRAILS_URL:+ok} ]; then
  export RUNDECK_GRAILS_URL="http://127.0.0.1:4440"
fi

confd -onetime || exit 2

exec java \
  -XX:+UnlockExperimentalVMOptions \
  -XX:MaxRAMFraction="${JVM_MAX_RAM_FRACTION:-1}" \
  -XX:+UseCGroupMemoryLimitForHeap \
  "${@}" \
  -jar rundeck.war
