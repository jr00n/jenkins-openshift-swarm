# The FROM will be replaced when building in OpenShift
FROM openshift/jenkins-slave-maven-centos7

MAINTAINER Jeroen Wolff <jeroen.wolff@gmail.com>
LABEL io.k8s.display-name="Jenkins Slave - With Swarm plugin installed" \
      io.k8s.description="The jenkins slave swarm image has the swarm plugin on top of the jenkins slave maven image." \
      io.openshift.tags="openshift,jenkins,slave,swarm"


ENV JENKINS_SWARM_VERSION 2.2
ENV JNLP_SLAVE_VERSION 2.52

RUN curl -sSLo $HOME/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION-jar-with-dependencies.jar \
  && curl -sSLo $HOME/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JNLP_SLAVE_VERSION/remoting-$JNLP_SLAVE_VERSION.jar

COPY jenkins-swarm-slave.sh /$HOME
USER root
RUN chmod +x $HOME/jenkins-swarm-slave.sh

#Install OpenShift Tools
RUN curl -L https://github.com/openshift/origin/releases/download/v1.3.0/openshift-origin-client-tools-v1.3.0-3ab7af3d097b57f933eccef684a714f2368804e7-linux-64bit.tar.gz | \
    tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-*

#Install IBM JDK 8
#ENV IBM_JAVA_VERSION 1.8.0_sr3fp20
# sum = 25f7a7a68535ae1bbd825505060aa8d55bda3a746bab3723f1b13a67d02a45be
#ENV IBM_JAVA_VERSION 1.8.0_sr4fp1
# sum = 2b4377c4a8b6934a17ee8e2ec673b4a3d3b97f0b568ef5e20a6ea2e676345bf3
#http://demo-resources/ibm-java-sdk-8.0-4.1-x86_64-archive.bin

#RUN ESUM="25f7a7a68535ae1bbd825505060aa8d55bda3a746bab3723f1b13a67d02a45be" \
#    && BASE_URL="https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/meta/" \
#    && YML_FILE="sdk/linux/x86_64/index.yml" \
#    && curl -s -A UA_IBM_JAVA_Docker -o /tmp/index.yml $BASE_URL/$YML_FILE \
#    && JAVA_URL=$(cat /tmp/index.yml | sed -n '/'$IBM_JAVA_VERSION'/{n;p}' | sed -n 's/\s*uri:\s//p' | tr -d '\r') \
#    && curl -s -A UA_IBM_JAVA_Docker -o /tmp/ibm-java.bin $JAVA_URL \
#    && echo "$ESUM  /tmp/ibm-java.bin" | sha256sum -c - \
#    && echo "INSTALLER_UI=silent" > /tmp/response.properties \
#    && echo "USER_INSTALL_DIR=/opt/ibm/java" >> /tmp/response.properties \
#    && echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties \
#    && mkdir -p /opt/ibm \
#    && chmod +x /tmp/ibm-java.bin \
#    && /tmp/ibm-java.bin -i silent -f /tmp/response.properties \
#    && rm -f /tmp/response.properties \
#    && rm -f /tmp/index.yml \
#    && rm -f /tmp/ibm-java.bin

#Voor de demo is het internet veel te traag...lokaal oplossen...zucht...
#10.0.2.2 is de gatway naar vagrant host os...mijn macbook dus, daar een ngnix server draaien met resourcses.
RUN curl -o /tmp/ibm-java.bin  http://10.0.2.2/ibm-java-sdk-8.0-4.1-x86_64-archive.bin \
    && echo "INSTALLER_UI=silent" > /tmp/response.properties \
    && echo "USER_INSTALL_DIR=/opt/ibm/java" >> /tmp/response.properties \
    && echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties \
    && mkdir -p /opt/ibm \
    && chmod +x /tmp/ibm-java.bin \
    && /tmp/ibm-java.bin -i silent -f /tmp/response.properties \
    && rm -f /tmp/response.properties \
    && rm -f /tmp/index.yml \
    && rm -f /tmp/ibm-java.bin

ENV JAVA_HOME=/opt/ibm/java/jre \
    PATH=/opt/ibm/java/bin:$PATH


USER 1001
ENTRYPOINT ["/home/jenkins/jenkins-swarm-slave.sh"]
