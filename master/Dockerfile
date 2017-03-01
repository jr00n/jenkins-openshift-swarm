FROM jenkins:2.19.4
MAINTAINER jr00n
USER root

USER jenkins
ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false"


#Add reference config to disable security and a demo job
COPY configuration /usr/share/jenkins/ref

#Add plugins
#ENV JENKINS_UC_DOWNLOAD=http://10.0.2.2/download
RUN /usr/local/bin/install-plugins.sh swarm:2.1 greenballs:1.15 workflow-aggregator:2.4 git:3.0.1 openshift-pipeline:1.0.40
