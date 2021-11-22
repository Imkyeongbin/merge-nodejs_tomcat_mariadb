#!/bin/bash

echo "foreground waiting"

dockerize -wait file:///userContent/mariadb_setting_done -timeout 180s -wait-retry-interval 5s

echo "foreground waiting end"
rm -f /userContent/mariadb_setting_done