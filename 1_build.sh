#!/bin/bash
cp _reference/env_docker_local_ocr_all.env nodeApp
\mv -f nodeApp/env_docker_local_ocr_all.env nodeApp/.env
# 주의!! DOCKER_UID는 도커 구동환경의 UID에 따라 바뀌어야 합니다. 예컨데 id 명령어를 쳤을 때 uid가 1005고, 그 아이디로 구동한다면 DOCKER_UID=1005가 되어야 합니다.
DOCKER_UID=1001

# userContentsdata 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/userContentsdata/data/agent ]; then
    sudo mkdir -p /dat/userContentsdata/data/agent
    
fi
# /dat/userContentsdata/data의 UID를 확인하고 DAT_MARIADB_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_MARIADB_UID=$( stat -c '%u' /dat/userContentsdata/data )
if [ ${DAT_MARIADB_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/userContentsdata

fi

# static 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/static ]; then
    sudo mkdir -p /dat/static
    
fi
# /dat/static의 UID를 확인하고 DAT_STATIC_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_STATIC_UID=$( stat -c '%u' /dat/static )
if [ ${DAT_STATIC_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/static

fi


docker build -t userContentsagent_webui:20220419 .
docker run --name userContentsagent_webui -d -u $DOCKER_UID -v /dat/userContentsdata:/userContentsdata -v /dat/static:/nodeApp/static --restart=always -p 8020:8020 -p 8019:8019 userContentsagent_webui:20220419 --pa 8019 --pw 8020 --pd 8036 -t 180 --aaocr http://cloudocr.userContentssoft.net:13019/ocr --adocr http://cloudocr.userContentssoft.net:13008 --allcore 0 --baseurl http://cloudocr.userContentssoft.net:13310

### -e ALLOW_EMPTY_PASSWORD=yes ###
##root로 접근(mkdir: cannot create directory시)
# => -u root
