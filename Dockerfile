FROM openjdk:8u121-jdk-alpine

LABEL version=2.0.0

ARG SENTRY_VERSION=2.1.0
ARG HADOOP_VERSION=2.10.1

WORKDIR /opt

RUN wget https://downloads.apache.org/sentry/${SENTRY_VERSION}/apache-sentry-${SENTRY_VERSION}-bin.tar.gz \
 && wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
 && tar zxvf apache-sentry-${SENTRY_VERSION}-bin.tar.gz \
 && tar zxvf hadoop-${HADOOP_VERSION}.tar.gz \
 && apk add --no-cache bash

COPY sentry-site.xml /opt/apache-sentry-${SENTRY_VERSION}-bin
COPY sentry.ini /opt/apache-sentry-${SENTRY_VERSION}-bin

WORKDIR /opt/apache-sentry-${SENTRY_VERSION}-bin

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
RUN bin/sentry --command schema-tool --conffile sentry-site.xml --dbType derby --initSchema

EXPOSE 8038
ENTRYPOINT ["bin/sentry", "--command", "service", "-c", "sentry-site.xml"]