#FROM docker.io/bitnami/minideb:buster
FROM nvidia/cuda:11.3.1-devel-ubuntu20.04
LABEL maintainer "Im Kyeongbin <lkbzbcg15@gmail.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/common/bin:$PATH"

COPY mariadb/prebuildfs /
COPY tomcat/prebuildfs /
COPY java_1.8/prebuildfs /

# apt 소스를 archive.ubuntu.com에서 mirror.kakao.com로 변경(속도 향상)
RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
##Install java 1.8.292
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libsqlite3-dev libssl-dev locales procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.292-0-linux-amd64-debian-10.tar.gz && \
    echo "700e2d8391934048faefb45b4c3a2af74bc7b85d4c4e0e9a24164d7256456ca2  /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY java_1.8/rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.292-debian-10-r6" \
    JAVA_HOME="/opt/bitnami/java" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:$PATH"


## install node.js 14.17.0
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

EXPOSE 3000

## install mariaDB, tomcat

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar zlib1g acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libgcc1 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.3.0-2" --checksum d89528e5d733f34ae030984584659ff10a36370d40332bd8d41c047764d39cda
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb" "10.5.9-0" --checksum ad98767779ea9ca977578df982a92a0ab258a61babe7dbe29ee4af04bcdbc333
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
# RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.11-0" --checksum 8cf28afc1090b0fec1ad841012ead25b59d2d5f4212742c3d62e6007ef57850b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.45-3" --checksum 18c141133b677b78001d1ffeb931d3382b909a04438facc5e2c13e38e166d9a3

RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY mariadb/rootfs /
COPY tomcat/rootfs /
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
RUN /opt/bitnami/scripts/mariadb/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.5.9-debian-10-r58" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"\
    MARIADB_ROOT_USER="lucas" \
    MARIADB_ROOT_PASSWORD="!lucas!" \
    MARIADB_DATABASE="agent" \
    TZ="Asia/Seoul" \
    AGENT_PORT="18019" \
    WEBUI_PORT="18020" \
    DB_PORT="18036" \
    OCR_ADDRESS_AGENT="http://localhost:18019/ocr" \
    OCR_ADDRESS_DIRECT="" \
    HANA_BANK_OPTION="false" \
    ALL_CORE="0" \
    BASE_URL_LOCATION="http://10.60.64.131:18080"
# ENV BITNAMI_DEBUG=true


RUN apt-get update && apt-get -y install vim nano net-tools psmisc rename

EXPOSE 18019


COPY userContent /userContent
RUN chmod g+rwX /userContent

## nodeApp(total)
# COPY nodeApp /nodeApp

#npm 최신 버전 설치
# RUN npm install -g npm && cp -R /nodeApp/static / && chmod -R g+rwX nodeApp && cd nodeApp && npm install --unsafe-perm && npm install -g pm2
RUN npm install -g npm && npm install -g pm2

# RUN pwd && sleep 20
EXPOSE 13301

# .nuxt 디렉토리 미리 생성, nodeApp/node_modules/.cache 디렉토리 미리 생성    
RUN mkdir -p /nodeApp/.nuxt && chmod g+rwX /nodeApp/.nuxt && mkdir -p /nodeApp/node_modules/.cache && chmod g+rwX /nodeApp/node_modules/.cache \
    # .pm2/logs 미리 생성
    && mkdir -p /.pm2/logs && chmod g+rwX -R /.pm2 \
    # /bitnami/mariadb폴더를 미리 생성, 심볼릭 링크로 userContentdata에 연결
    && mkdir -p /bitnami/mariadb && ln -s /bitnami/mariadb /userContentdata && chmod g+rwX -R /userContentdata
    # && useradd -g root userContent


#Dockerize install
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


USER 1001

# WORKDIR /app

## entrypoint, CMD는 tomcat으로
## ENTRYPOINT [ "/opt/bitnami/scripts/tomcat/entrypoint.sh" , "/opt/bitnami/scripts/tomcat/run.sh" ]
ENTRYPOINT [ "/userContent/run.sh" ]