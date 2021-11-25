#!/bin/bash
cp _reference/env_docker_local_ocr_all.env nodeApp
\mv -f nodeApp/env_docker_local_ocr_all.env nodeApp/.env
# 주의!! DOCKER_UID는 도커 구동환경의 UID에 따라 바뀌어야 합니다. 예컨데 id 명령어를 쳤을 때 uid가 1005고, 그 아이디로 구동한다면 DOCKER_UID=1005가 되어야 합니다.
DOCKER_UID=1001

# mariadb 바인딩할 폴더를 미리 생성하고 $DOCKER_UID 유저에게 폴더의 소유권을 줍니다.
if [ ! -d /dat/userContentdata/data/agent ]; then
    sudo mkdir -p /dat/userContentdata/data/agent
    
fi
# /dat/userContentdata/data의 UID를 확인하고 DAT_MARIADB_UID에 대입한다. 파일이 없으면 null만 남는다.
DAT_MARIADB_UID=$( stat -c '%u' /dat/userContentdata/data )
if [ ${DAT_MARIADB_UID:-"a9999"} != "$DOCKER_UID" ]; then
    sudo chown -R $DOCKER_UID /dat/userContentdata

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


docker run --name user_content_full -d -u $DOCKER_UID -v /dat/userContentdata:/bitnami/userContentdata -v /dat/static:/nodeApp/static --restart=always -p 18020:18020 -p 18019:18019 user_content_full:20211125 --pa 18019 --pw 18020 --pd 18036 -t 180 --aaocr http://www.userContentsoft.net:13019/ocr --adocr http://www.userContentsoft.net:13008 --allcore 0 --baseurl http://www.userContentsoft.net:13310
# nvidia-docker run --name user_content_full -d -u $DOCKER_UID -v /dat/mariadb:/bitnami/mariadb -v /dat/static:/nodeApp/server/uploads --restart=always -p 18020:18020 -p 18019:18019 user_content_full:20211125 --pa 18019 --pw 18020 --pd 18036 -t 180 --hana false --aaocr http://www.userContentsoft.net:13019/ocr
#docker run --name user_content --restart=always -e JAVA_OPTS="-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true" -p 18019:18019 -p 18020:18020 user_content:20211125

#docker run --name user_content_full   --restart=always --net=host user_content_full:20211125

#docker run --name userContent_jntma_c --restart=always --net=host -v /dat/mariadb:/var/lib/mysql userContent_jntma --pt 18019 --pn 18020 --pm 18036 -t 120
# docker run --name userContent_jntma_c --restart=always -p 18019:18019 -p 3000:3000 -p 23306:23306 -p 8443:8443 -v /dat/mariadb:/bitnami/mariadb userContent_jntm

### -e ALLOW_EMPTY_PASSWORD=yes ###
##root로 접근(mkdir: cannot create directory시)
# => -u root
# docker run --name userContent_jntma_c --restart=always -e JAVA_OPTS="-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true" -d --net=host -e ODR_HTTP_PORT_NUMBER=8800 -v /dat/mariadb:/bitnami/mariadb -u root userContent_jntm
# docker run --name userContent_jntma_c --restart=always -d -p 18019:18019 -p 3000:3000 -p 23306:23306 -p 8443:8443 -v /dat/mariadb:/bitnami/mariadb -u root userContent_jntm