#!/bin/bash
cp _reference/env_docker_local_ocr_all_kebhanabank.env nodeApp
\mv -f nodeApp/env_docker_local_ocr_all_kebhanabank.env nodeApp/.env
# 주의!! DOCKER_UID는 도커 구동환경의 UID에 따라 바뀌어야 합니다. 예컨데 id 명령어를 쳤을 때 uid가 1005고, 그 아이디로 구동한다면 DOCKER_UID=1005가 되어야 합니다.
DOCKER_UID=1001

# userContentsdata 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/hana/userContentsdata/data/agent ]; then
    sudo mkdir -p /dat/hana/userContentsdata/data/agent
    
fi
# /dat/hana/userContentsdata/data의 UID를 확인하고 DAT_MARIADB_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_MARIADB_UID=$( stat -c '%u' /dat/hana/userContentsdata/data )
if [ ${DAT_MARIADB_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/hana/userContentsdata

fi

# static 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/hana/static ]; then
    sudo mkdir -p /dat/hana/static
    
fi
# /dat/hana/static의 UID를 확인하고 DAT_STATIC_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_STATIC_UID=$( stat -c '%u' /dat/hana/static )
if [ ${DAT_STATIC_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/hana/static

fi

# 정상적으로 디폴트 로고를 표시하기 위해서 hanalogo1.png, hanalogo2.png의 파일명으로 /dat/hana/static폴더에 미리 넣어놔야 합니다.
\sudo cp -f _reference/static/hanalogo1.png /dat/hana/static
\sudo cp -f _reference/static/hanalogo2.png /dat/hana/static

docker build -t userContentsagent_webui_hana:20220419 .
docker run --name userContentsagent_webui_hana -d -u $DOCKER_UID -v /dat/hana/userContentsdata:/userContentsdata -v /dat/hana/static:/nodeApp/static --restart=always -p 8020:8020 -p 8019:8019 userContentsagent_webui_hana:20220419 --pa 8019 --pw 8020 --pd 8036 -t 180 --aaocr http://cloudocr.userContentssoft.net:13019/ocr --hana true --adocr http://cloudocr.userContentssoft.net:13008 --allcore 0 --baseurl http://cloudocr.userContentssoft.net:13310 --statichost http://localhost:8020

### -e ALLOW_EMPTY_PASSWORD=yes ###
##root로 접근(mkdir: cannot create directory시)
# => -u root