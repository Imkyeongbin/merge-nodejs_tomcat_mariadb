#!/bin/bash
# cp _reference/env_docker_local_ocr_all_ibk.env nodeApp
# \mv -f nodeApp/env_docker_local_ocr_all_ibk.env nodeApp/.env
# 주의!! DOCKER_UID는 도커 구동환경의 UID에 따라 바뀌어야 합니다. 예컨데 id 명령어를 쳤을 때 uid가 1005고, 그 아이디로 구동한다면 DOCKER_UID=1005가 되어야 합니다.
DOCKER_UID=1001

# userContentdata 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/ibk/ocrdatas/data/agent ]; then
    sudo mkdir -p /dat/ibk/ocrdatas/data/agent
    
fi
# /dat/userContentdata/data의 UID를 확인하고 DAT_MARIADB_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_MARIADB_UID=$( stat -c '%u' /dat/ibk/ocrdatas/data )
if [ ${DAT_MARIADB_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/ibk/ocrdatas

fi

# static 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/ibk/uploads ]; then
    sudo mkdir -p /dat/ibk/uploads
    
fi
# /dat/static의 UID를 확인하고 DAT_STATIC_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_STATIC_UID=$( stat -c '%u' /dat/ibk/uploads )
if [ ${DAT_STATIC_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/ibk/uploads

fi


docker build -t user_content_full_ibk:20211125 .
docker run --name user_content_full_ibk -d -u $DOCKER_UID -v /dat/ibk/ocrdatas:/userContentdata -v /dat/ibk/uploads:/nodeApp/static --restart=always -p 18020:18020 -p 18019:18019 user_content_full_ibk:20211125 --pa 18019 --pw 18020 --pd 18036 -t 180 --aaocr http://www.userContentsoft.net:13019/ocr --adocr http://www.userContentsoft.net:13008 --allcore 0 --baseurl http://www.userContentsoft.net:13310
# docker run --name user_content_full -d -u $DOCKER_UID -v /dat/mariadb:/bitnami/mariadb -v /dat/uploads:/nodeApp/server/uploads --restart=always -p 18020:18020 -p 18019:18019 user_content_full:20211125 --pa 18019 --pw 18020 --pd 18036 -t 180 --hana false --aaocr http://www.userContentsoft.net:13019/ocr
# docker run --name user_content_full --restart=always --net=host user_content_full:20211125
# docker run --name user_content   --restart=always --net=host user_content:20211125 --pa 11111 --pw 22222 --pd 33333 -t 180 --a_ocr http://127.0.0.1:18019/ocr
# docker run --name userContent_jntma_c --restart=always -d -e TZ=Asia/Seoul -p 18019:18019 -p 3000:3000 -p 23306:23306 -p 8443:8443 -v /dat/mariadb:/bitnami/mariadb userContent_jntm

### -e ALLOW_EMPTY_PASSWORD=yes ###
##root로 접근(mkdir: cannot create directory시)
# => -u root
#docker run --name userContent_jntma_c --restart=always -u root --net=host -e ODR_HTTP_PORT_NUMBER=8800 -v /dat/mariadb:/bitnami/mariadb userContent_jntm
#docker run --name userContent_jntma_c --restart=always -d -e TZ=Asia/Seoul -p 18019:18019 -p 3000:3000 -p 23306:23306 -p 8443:8443 -v /dat/mariadb:/bitnami/mariadb -u root userContent_jntm
