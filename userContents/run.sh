#!/bin/bash

# shellcheck disable=SC1091

echo "merge-tomcat&node&mariaDB&nodeApp ver 20220419"

echo "nodeApp gitlab tag : 1279de8391d820f68a7b1017d1454e0db3d4757c"

cp -R -f /static /nodeApp

. /userContents/arg.sh

. /opt/bitnami/scripts/tomcat/entrypoint.sh /opt/bitnami/scripts/tomcat/run.sh

#. /userContents/delay_tomcat.sh

#. /userContents/cpROOT.sh

#while true
#do
#    sleep 1
