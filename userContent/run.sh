#!/bin/bash

# shellcheck disable=SC1091

echo "merge-tomcat&node&mariaDB ver 20211117"

. /userContent/arg.sh

. /opt/bitnami/scripts/tomcat/entrypoint.sh /opt/bitnami/scripts/tomcat/run.sh

