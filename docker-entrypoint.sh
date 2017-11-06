#!/bin/bash

set -e
cd ${MIST_HOME}

if [ "$1" = 'mist' ]; then
  export IP=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

  export JAVA_OPTS="$JAVA_OPTS -Dmist.cluster.host=$IP -Dmist.log-service.host=$IP"
  shift
  echo """./bin/mist-master start --config ${MIST_CONF} --router-config ${MIST_ROUTER} -java-args ${JAVA_OPTS} --debug true $@"""
  exec ./bin/mist-master start --config ${MIST_CONF} --router-config ${MIST_ROUTER} -java-args ${JAVA_OPTS} --debug true $@
elif [ "$1" = 'worker' ]; then 
  #export IP=`getent ahostsv4 dev-pca-mist.singularity.k.9dev.io | awk '{ print $1; exit }'`
  export MYIP=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`
  
  echo """exec ./bin/mist-worker --runner local --master ${MIST_MASTER_IP}:2551 --bind-address ${MYIP}:0 --name ${MIST_WORKER_NAME} --context-name ${MIST_WORKER_CONTEXT} --mode ${MIST_WORKER_MODE}"""
  exec ./bin/mist-worker --runner local --master ${MIST_MASTER_IP}:2551 --bind-address ${MYIP}:0 --name ${MIST_WORKER_NAME} --context-name ${MIST_WORKER_CONTEXT} --mode ${MIST_WORKER_MODE}
  
fi
