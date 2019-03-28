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

BASE_VER="1.1"

docker build \
    $DOCKER_OPTS \
    $BUILD_ARG \
    --build-arg WDT_MODEL=empty-domain.yaml \
    --build-arg WDT_VARIABLE=properties/${DOMAIN_NAME}.properties \
    --force-rm=true \
    -t domain1-base-image:$BASE_VER -f Dockerfile_base .
if [ $? -eq 0 ]; then
    docker tag domain1-base-image:$BASE_VER acsitaly01/domain1-base-image:$BASE_VER
    docker push acsitaly01/domain1-base-image:$BASE_VER
    if [ $? -eq 0 ]; then
        echo "PUSHED: acsitaly01/domain1-base-image:$BASE_VER"
    fi
else
    echo "ERROR WHILE BUILDING..."
fi
