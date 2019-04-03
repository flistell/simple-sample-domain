#!/bin/sh
#
#Copyright (c) 2018, 2019 Oracle and/or its affiliates. All rights reserved.
#
#Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#
# Build the sample domain home image. You must build the archive file and download the weblogic deploy
# install image prior to executing this shell script.

# parse the ADMIN_HOST, ADMIN_PORT, MS_PORT, and DOMAIN_NAME from the sample properties file and pass
# as a string of --build-arg in the variable BUILD_ARG

DOMAIN_NAME="myapp-domain-fl"
. ../container-scripts/setEnv.sh properties/${DOMAIN_NAME}.properties

docker build \
    $DOCKER_OPTS \
    $BUILD_ARG \
    --build-arg WDT_MODEL=properties/wdt-domain-model_empty.yaml \
    --build-arg WDT_VARIABLE=properties/${DOMAIN_NAME}.properties \
    --force-rm=true \
    -t ${DOMAIN_NAME}-base-image:build -f Dockerfile_base .
if [ $? -eq 0 ]; then
    ID=$(docker image list --format="{{.ID}}" ${DOMAIN_NAME}-base-image:build)
    docker tag ${DOMAIN_NAME}-base-image:build acsitaly01/${DOMAIN_NAME}-base-image:$ID
    docker push acsitaly01/${DOMAIN_NAME}-base-image:$ID
    if [ $? -eq 0 ]; then
        echo 
        echo "PUSHED: acsitaly01/${DOMAIN_NAME}-base-image:$ID"
        echo
    fi
else
    echo "ERROR WHILE BUILDING..."
fi
