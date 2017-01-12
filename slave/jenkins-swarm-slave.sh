#!/bin/bash

master_username=${JENKINS_USERNAME:-"admin"}
master_password=${JENKINS_PASSWORD:-"password"}
slave_executors=${EXECUTORS:-"1"}

source /usr/local/bin/generate_container_user

echo "Running Jenkins Swarm Plugin...."

# jenkins swarm slave
JAR=`ls -1 /home/jenkins/swarm-client-*.jar | tail -n 1`
JENKINS_URL=http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT}

if [[ -z "$JENKINS_URL" ]]; then
  echo "Jenkins URL must be available";
  exit 1;
fi

#check if Jenkins is online before starting slave
echo "Waiting for Jenkins ($JENKINS_URL) to get ready..."
while ! curl --output /dev/null --silent --head --fail $JENKINS_URL; do sleep 1 && echo -n .; done;

#PARAMS="-master http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT}${JENKINS_CONTEXT_PATH} -tunnel ${JENKINS_SLAVE_SERVICE_HOST}:${JENKINS_SLAVE_SERVICE_PORT}${JENKINS_SLAVE_CONTEXT_PATH} -username ${master_username} -password ${master_password} -executors ${slave_executors}"
PARAMS="-master ${JENKINS_URL}${JENKINS_CONTEXT_PATH} -username ${master_username} -password ${master_password} -executors ${slave_executors} -labels ${SLAVE_LABEL}"

java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
