#FROM docker.io/bitnami/minideb:buster
# FROM nvidia/cuda:11.6.0-devel-ubuntu20.04 # 드라이버 버전의 영향으로 실행 불가능
# 11.3.1 버전은 우분투 20.04.1을 써서 libxml2 라이브러리의 리포지토리 문제로 libxml2을 포함하지 않은 imagemagick이 만들어짐
FROM nvidia/cuda:11.3.1-devel-ubuntu20.04
LABEL maintainer "Lucas Im <lucas@userContentssoft.co.kr>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/common/bin:$PATH"

COPY mariadb/prebuildfs /
COPY tomcat9.0/prebuildfs /

# apt 소스를 archive.ubuntu.com에서 mirror.kakao.com로 변경(속도 향상)
RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

## install node.js
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY nodejs/prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl ghostscript git gzip imagemagick libbz2-1.0 libc6 libgcc1 liblzma5 libncursesw6 libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libstdc++6 libtinfo6 pkg-config procps tar unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-14.17.0-0-linux-amd64-debian-10.tar.gz && \
    echo "445d6ffbde4c69c382f1d1614f014fb29c716756e6e91e9d5792bfb5268ea4d1  /tmp/bitnami/pkg/cache/node-14.17.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-14.17.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-14.17.0-0-linux-amd64-debian-10.tar.gz
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="14.17.0-debian-10-r6" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

#EXPOSE 3000

## install mariaDB, tomcat

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar xmlstarlet zlib1g acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libgcc1 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.3.0-2" --checksum d89528e5d733f34ae030984584659ff10a36370d40332bd8d41c047764d39cda
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb" "10.5.9-0" --checksum ad98767779ea9ca977578df982a92a0ab258a61babe7dbe29ee4af04bcdbc333
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-7" --checksum 900545c4f346a0ece8abf2caf64fd9d4ab7514967d4614d716bf7362b24f828b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.62-0" --checksum 19b1e7b113180f5a17a1155d36a23d5da65e741337d8f89c0e97a9fb6535921c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY mariadb/rootfs /
COPY tomcat9.0/rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
RUN /opt/bitnami/scripts/mariadb/postunpack.sh
ENV APP_VERSION="9.0.62" \
    BITNAMI_APP_NAME="tomcat" \
    JAVA_HOME="/opt/bitnami/java" \
    # BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.5.9-debian-10-r58" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"\
    MARIADB_ROOT_USER="userContentssoft" \
    MARIADB_ROOT_PASSWORD="!userContents!" \
    MARIADB_DATABASE="agent" \
    TZ="Asia/Seoul" \
    AGENT_PORT="8019" \
    WEBUI_PORT="8020" \
    DB_PORT="8036" \
    OCR_ADDRESS_AGENT="http://localhost:8019/ocr" \
    OCR_ADDRESS_DIRECT="http://userContentsagentocr:30006" \
    HANA_BANK_OPTION="false" \
    ALL_CORE="0" \
    BASE_URL_LOCATION="http://10.60.64.131:18080" \
    TOMCAT_PASSWORD="@userContents@"
# ENV BITNAMI_DEBUG=true


# // 테스트시엔 주석처리
RUN apt-get update && apt-get -y install vim nano net-tools psmisc rename


EXPOSE 8020 8019

COPY @externalFiles /@externalFiles

#Dockerize install & imagemagick heic지원 버전 설치 (libxml2-dev 누락됨) // 테스트시엔 주석처리
RUN chmod g+rwX -R /@externalFiles && \
apt-get install -y build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev libde265-dev pkg-config m4 libtool automake autoconf && \
cd /usr/src/ && \
cp -r /@externalFiles/. . && rm -rf /@externalFiles && \
cp dockerize /usr/local/bin && rm dockerize && \
tar -xvf libheif-1.12.0.tar.gz && \
rm libheif-1.12.0.tar.gz && \
cd libheif-1.12.0/ && \
./autogen.sh && \
./configure && \
make && \
make install && \
cd /usr/src/ && \
tar xvzf ImageMagick.tar.gz && \
rm ImageMagick.tar.gz && \
cd ImageMagick-7.1.0-29/ && \
./configure --with-heic=yes --with-webp=yes && \
make && \
make install && \
ldconfig /usr/local/lib
# make check

# 테스트용
# RUN cd /usr/src/ && \
# cp -r /@externalFiles/. . && rm -rf /@externalFiles && \
# cp dockerize /usr/local/bin

COPY userContents /userContents
RUN chmod g+rwX -R /userContents

## nodeApp(total)
# RUN pwd && sleep 20
COPY nodeApp /nodeApp

#npm 최신 버전 설치 // 테스트시엔 주석처리
RUN mkdir -p /.npm/_logs && chmod -R 775 /.npm && npm install -g npm && cp -R /nodeApp/static / && chmod -R g+rwX nodeApp && cd nodeApp && npm install --unsafe-perm && npm install -g pm2 

# odr data extra resources 만들기
RUN mkdir -p /home/odrGeneral/data && mkdir -p /home/odrGeneral/extra && mkdir -p /home/odrGeneral/resources && chmod -R 770 /home/odrGeneral/ \
# .nuxt 디렉토리 미리 생성, nodeApp/node_modules/.cache 디렉토리 미리 생성
    && mkdir -p /nodeApp/.nuxt && chmod g+rwX /nodeApp/.nuxt && mkdir -p /nodeApp/node_modules/.cache && chmod g+rwX /nodeApp/node_modules/.cache \
    # .pm2/logs 미리 생성
    && mkdir -p /.pm2/logs && chmod g+rwX -R /.pm2 \
    # /bitnami/mariadb폴더를 미리 생성, 심볼릭 링크로 userContentsdata에 연결
    && mkdir -p /bitnami/mariadb && ln -s /bitnami/mariadb /userContentsdata && chmod g+rwX -R /userContentsdata

USER 1001

WORKDIR /nodeApp

## entrypoint, CMD는 tomcat으로
## ENTRYPOINT [ "/opt/bitnami/scripts/tomcat/entrypoint.sh" , "/opt/bitnami/scripts/tomcat/run.sh" ]
ENTRYPOINT [ "/userContents/run.sh" ]