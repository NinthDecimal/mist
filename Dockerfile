FROM docker.jiwiredev.com/nined/spark-box:cobol-be80181
MAINTAINER lblokhin@ninthdecimal.com

ENV SPARK_DIST http://jenkins-01.jiwiredev.com/job/spark-distribution/72/artifact/release/spark-2.0.3-20161205/spark-2.0.3-SNAPSHOT-bin-2.7.0-mapr-1703.tgz

ENV MIST_HOME=/usr/share/mist \
    SPARK_VERSION=2.1.0 \
    LOG_LEVEL=${LOG_LEVEL:-warn}
    
COPY . ${MIST_HOME}
COPY ./docker-entrypoint.sh /
   
RUN echo "Update 2017-06-27" \
 && echo 'deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list \
 && echo 'deb https://get.docker.com/ubuntu docker main' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y --force-yes \
    python-pip \
    libpq-dev \
    libboost-python-dev \
 && apt-get -y autoremove \
 && apt-get -y clean all \
 && apt-get -y autoclean all \
 && pip install --upgrade pip \
 && rm -fr /tmp/* /var/tmp/* \
 && pip install --extra-index-url http://pypi.jiwiredev.com/simple --trusted-host pypi.jiwiredev.com --user nd-singularity \
 && /usr/local/bin/spark-dist \
 && confd -onetime -backend etcd -prefix=/${OPENV} -log-level=${LOG_LEVEL} -confdir=/etc/confd/spark \
 && . /etc/spark/spark-env.sh 

ARG PCA_SCALA_VER
ENV PCA_SCALA_HOME /data/apps/pca-scala/releases/$PCA_SCALA_VER

RUN cd /tmp \
 && wget -c http://eng-01.jiwiredev.com:5050/nexus/content/repositories/jiwire/com/jiwire/pca/pca-scala/$PCA_SCALA_VER/pca-scala-$PCA_SCALA_VER.jar \
 && mkdir -p $PCA_SCALA_HOME \
 && mv /tmp/pca-scala-$PCA_SCALA_VER.jar $PCA_SCALA_HOME/ \
 && ln -s $PCA_SCALA_HOME/pca-scala-$PCA_SCALA_VER.jar $PCA_SCALA_HOME/pca-scala.jar \
 && ln -s $PCA_SCALA_HOME /data/apps/pca-scala/current \
 && cd ${MIST_HOME} \
 && ./sbt/sbt -DsparkVersion=2.1.0 mist/basicStage </dev/null \
 && chmod +x /docker-entrypoint.sh

EXPOSE 2004
ENTRYPOINT ["/docker-entrypoint.sh"]
