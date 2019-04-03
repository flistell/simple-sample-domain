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

VERSION="1.0"

docker build \
    $DOCKER_OPTS \
    $BUILD_ARG \
    --build-arg WDT_MODEL=properties/wdt-domain-model_app-deployment.yaml \
    --build-arg WDT_VARIABLE=properties/${DOMAIN_NAME}.properties \
    --build-arg WDT_ARCHIVE=archive_${VERSION}.zip \
    --force-rm=true \
    -t ${DOMAIN_NAME}-app-image-$VERSION:build \
    -f Dockerfile_app_${VERSION} .
if [ $? -eq 0 ]; then
    ID=$(docker image list --format="{{.ID}}" ${DOMAIN_NAME}-app-image-$VERSION:build)
    docker tag ${DOMAIN_NAME}-app-image-$VERSION:build acsitaly01/${DOMAIN_NAME}-app-image-$VERSION:$ID
    docker push acsitaly01/${DOMAIN_NAME}-app-image-$VERSION:$ID
fi
