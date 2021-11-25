#!/bin/bash

# shellcheck disable=SC1091

echo "merge-tomcat&node&mariaDB&nodeApp ver 20211125"

TEST=1000
TEST2=$( stat -c '%u' server3 )
if [ ${TEST2:-"99999"} = "$TEST" ]; then
    echo "니꺼임 $TEST2"
    else
    echo "니꺼아님 $TEST2"
fi

