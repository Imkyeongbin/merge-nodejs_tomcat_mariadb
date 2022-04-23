#!/bin/bash

echo "foreground waiting tomcat"
#for var in {1..60}
#do
#  var=$var
#  sleep 1
#done

dockerize -wait tcp://:$ODR_HTTP_PORT_NUMBER -timeout 180s -wait-retry-interval 5s

echo "foreground waiting tomcat end"