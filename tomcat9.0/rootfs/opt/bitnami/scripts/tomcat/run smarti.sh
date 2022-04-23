#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

## Load mariadb
. /opt/bitnami/scripts/mariadb/entrypoint.sh /opt/bitnami/scripts/mariadb/run.sh&

## dockerize - Delay Time In Seconds
. /userContents/delay.sh


# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

## node 실행
. /userContents/runNode.sh


info "** Starting Tomcat **"

if am_i_root; then
    exec gosu "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
else
    exec "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
fi
