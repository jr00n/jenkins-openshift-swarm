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

USER 1001
ENTRYPOINT ["/home/jenkins/jenkins-swarm-slave.sh"]
