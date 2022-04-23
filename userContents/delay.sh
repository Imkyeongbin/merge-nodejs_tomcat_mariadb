#!/bin/bash

echo "foreground waiting"
#for var in {1..60}
#do
#  var=$var
#  sleep 1
#done

dockerize -wait file:///userContents/mariadb_setting_done -timeout 180s -wait-retry-interval 5s

echo "foreground waiting end"
rm -f /userContents/mariadb_setting_done