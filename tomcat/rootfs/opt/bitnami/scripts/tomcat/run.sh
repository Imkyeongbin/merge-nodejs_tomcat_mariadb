#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

## Load mariadb
. /opt/bitnami/scripts/mariadb/entrypoint.sh /opt/bitnami/scripts/mariadb/run.sh&

## dockerize - Delay Time In Seconds
. /userContent/delay.sh


# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

## node 실행
. /userContent/runNode.sh

info "** Starting Tomcat **"

start_command=("${TOMCAT_BIN_DIR}/catalina.sh" "run")

if am_i_root; then
    echo "ppp01"
    exec gosu "$TOMCAT_DAEMON_USER" "${start_command[@]}"
    echo "ppp02"
else
    echo "ppp03"
    exec "${start_command[@]}"
    echo "ppp04"
fi

