##### Ubuntu ver 20.04 & nvidia/cuda:11.3.1

##### Node.js ver 14.17.0

##### Tomcat ver 9.0.45    기본 PORT=>18019

##### mariadb ver 10.5.9   기본 PORT=>18036

##### java ver 1.8.292-0



**통상 빌드 & 실행 파일(실행 파일들은 Merge-Nodejs_Tomcat_Mariadb 디렉토리에서 실행하셔야 합니다.)**

```
sh 1_build.sh
```


##### Run단계에서 이미지 뒤에 붙을 수 있는 옵션이 있습니다. --pa, --pd는 각각 톰캣, DB의 포트이며, -t는 db와 톰캣 구동 사이에 최대 대기할 초입니다. -t옵션은 간혹 마리아db 세팅도중에 노드가 실행되어 마리아db없이 작동하다 에러가 뜨는 것을 방지하기 위해 만들어진 딜레이 컨트롤 옵션이고 기본값은 120(초)입니다.

  ```
  docker run --name user_content_full -p 13333:13333 user_content_full:20211117 --pa 13333 --pd 33333 -t 120 --aaocr http://user_content_full:13333/ocr --adocr http://user_contentocr:12345 --allcore 0 --baseurl http://yourBase.com:18080
  ```


##### 주의) 실행시 톰캣의 포트가 18019로 바뀝니다. 즉 접속하려면
  - `localhost:18019` 으로 접속해야합니다.
  - ~~만일 다른 포트로 접속하려면 Run 단계에서 이미지 뒤에
  `--pa (임의의 포트넘버)`
  옵션을 줘서 변경하면 됩니다. 예를 들면,
  
  ```
  docker run --name user_content_full -p 12345:12345 user_content_full:20211117 --pa 12345
  ```


- ver. 20211117 : 현행 도커파일은 Dockerfile_UJNTMAg와 동일합니다.

- arg.sh의 마지막 단계에서 OCR_ADDRESS_DIRECT_CHANGED를 보여주던 것을 OCR_ADDRESS_DIRECT를 보여주게 변경

- 기본 OCR_ADDRESS_AGENT="http://localhost:18019/ocr"

  OCR_ADDRESS_DIRECT="http://user_contentocr:12345"

  로 변경

- `1_build.sh`과, `1_build_ibk.sh`에서 mariadb가 /bitnami/userContentdata에 바인딩 되던 도커옵션을 /userContentdata에 바인딩 되게 변경함(내부 마리아db 심볼릭 링크된 위치)

- OCR_ADDRESS가 OCR_ADDRESS_AGENT로 변수명이 바뀌었습니다. --aocr옵션도 변수명 따라 --aaocr로 바뀌었습니다.

- 기존 nodeApp의 static 디렉토리에 있던 파일을 도커 내부 static에 복사한 이후 다시 nodeApp에 복사하여 파일을 유지합니다.

- /bitnami/mariadb의 심볼릭 링크 디렉토리 /userContentdata를 생성합니다. db예정 디렉토리를 /userContentdata에 v옵션으로 묶으면 됩니다.

- Dockerize용 생성파일(mariadb_setting_done)이 생성 확인될 때마다 삭제되도록 바꿨습니다.

- 도커파일에서 ENV에 OCR_ADDRESS_DIRECT가 추가되었습니다.
기본값은 `http://www.userContentsoft.net:13008`입니다.

- runNode.sh파일 내용이 바꼈습니다.

~~`npm run dev&`~~ => ~~`npm run build && npm run start&`~~

=> `npm run build && PORT=$WEBUI_PORT pm2 start /userContent/ecosystem.config.js --only UI$ALL_CORE`

- node에서 필요한 두 디렉토리를 도커파일에서 미리 만듭니다. (nodeApp/.nuxt , nodeApp/node_modules/.cache 디렉토리 미리 생성)

- 도커파일에서 `RUN chmod -R g+rwX nodeApp` 명령을 추가했습니다.

- nvidia/cuda:11.3.1-devel-ubuntu20.04 기반으로 만들어졌습니다.

- psmisc추가되었습니다.

- 1_build.sh, 2_(run).sh에 DOCKER_UID 변수를 추가해서 해당 변수에 맞춰 DB소유자나 u 옵션에 해당하는 UID가 변동하게 만들었습니다.

- 도커파일에서 RUN 명령을 간략화 했습니다. 한 명령에 다른 명령들을 &&으로 붙여서 실행시켜 빌드 시간을 단축했습니다.

- ENV를 다소 추가했습니다. AGENT_PORT="18019", WEBUI_PORT="18020", DB_PORT="18036"

- 옵션 명을 변경했습니다. 

- nodeApp에서 추가로 파일 변경시 필요할 참고 파일을 _reference에 옮겼습니다.

- 소스 아카이브를 archive.ubuntu.com에서 mirror.kakao.com로 변경했습니다.(빌드 속도 향상)

- .env파일들을 _reference 디렉토리에 추가했습니다.

- 도커라이즈 최대 딜레이를 180초로 변경했습니다.

- userContent폴더 안에 arg.sh, delay.sh, run.sh 파일 등을 넣어놓았습니다.

- Dockerize가 추가되었습니다. Dockerize는 마리아db세팅 완료 후 재시작하기 직전까지 대기하는 용도로 스크립트를 짜놓았습니다. mariadb/rootfs/opt/bitnami/scripts/mariadb/run.sh에서 touch로 userContent폴더에 mariadb_setting_done를 만드는 것을 기다리는 스크립트입니다. 만약 정상구동이 안되어 마리아db세팅이 완료되지 않았고 딜레이시간이 다됐다면 도커구동을 종료합니다.

- 1. 현재 Run단계에서 로컬디스크에 /dat/mariadb디렉토리가 없을 때 v옵션을 달 경우,
  `cannot create directory ‘/bitnami/mariadb/data’: Permission denied`
   에러가 뜹니다. 그 경우 Run단계에서 -u root 옵션을 이미지 앞에 추가 하고 1차적으로 실행하면 디렉토리를 생성해 줍니다. 경우에 따라 sudo권한이 필요할 수 있습니다. 다만 -u root를 넣을 경우에 톰캣이 정상 구동을 하지 않기 때문에 톰캣을 구동하기 위해서는 다시 -u root 옵션을 빼고 Run 단계를 실행해야 합니다.
  2. 혹은, /dat/mariadb 디렉토리를 생성해주고
  `sudo chown -R 1001:1001 <directory>`
   로 소유권을 바꿔주면 -u root 넣어주고 두번 실행할 거 없이 마리아db가 정상 세팅됩니다.

- 포트를 빌드단계에서 바꾸고자 할 때에는
  - 톰캣의 경우 tomcat/rootfs/opt/bitnami/script/libtomcat.sh 와 
  userContent/arg.sh 파일,
  - mariadb의 경우 userContent/arg.sh 파일을 변경해줘야 합니다.

- userContent/run.sh로 구동합니다.

- VIM, NANO 추가 되었습니다.

- NET-TOOLS 추가 되었습니다.

- 성공적으로 구동된 환경은 virtualbox - 우분투 20.04입니다. 윈도우 10에서 실행했을 때 dockerfile 6번째 명령에서 install_packages를 못 읽어서 실패했습니다.

- bitnami에 있던 스크립트와 이미지를 기반으로 만들었습니다.

- CMD와 Entrypoint에서의 일인데, 자바와 노드는 별반 명령어가 없습니다.(CMD node/CMD bash)
- Dockerfile에서 Entrypoint와 CMD 명령어 중 하나가 실행되고 있어야 도커 컨테이너가 유지가 되므로, Entrypoint단계에서 톰캣을 돌리기로 했습니다.

- 자바를 1.8.292 버전으로 추가하였습니다.



## **마리아db-bitnami 바뀐 점**

### **1. mariadb/rootfs/opt/bitnami/scripts/mariadb/entrypoint.sh**



19 if [[ "$1" = "/opt/bitnami/scripts/mariadb/run.sh" ]]; then

    info "** Starting MariaDB setup **"
    
    /opt/bitnami/scripts/mariadb/setup.sh
    
    info "** MariaDB setup finished! **"

23 fi





19

  info "** Starting MariaDB setup **"

  /opt/bitnami/scripts/mariadb/setup.sh

  info "** MariaDB setup finished! **"

23

### **2. mariadb/rootfs/opt/bitnami/scripts/mariadb/run.sh**

34라인

touch /userContent/mariadb_setting_done



## tomcat 바뀐 점

### tomcat/rootfs/opt/bitnami/scripts/libtomcat.sh

47라인

export TOMCAT_SHUTDOWN_PORT_NUMBER="${ODR_SHUTDOWN_PORT_NUMBER:-8005}"

export TOMCAT_HTTP_PORT_NUMBER="${ODR_HTTP_PORT_NUMBER:-18019}"

export TOMCAT_AJP_PORT_NUMBER="${ODR_AJP_PORT_NUMBER:-8009}"

export TOMCAT_HOME="${TOMCAT_HOME:-$TOMCAT_BASE_DIR}"

export TOMCAT_USERNAME="${ODR_USERNAME:-user}"

export TOMCAT_PASSWORD="${ODR_PASSWORD:-}"

52라인


57라인

export JAVA_OPTS="${JAVA_OPTS:--Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Duser.home=$TOMCAT_HOME}"

### tomcat/rootfs/opt/bitnami/scripts/tomcat/run.sh

10라인

\## Load mariadb

. /opt/bitnami/scripts/mariadb/entrypoint.sh /opt/bitnami/scripts/mariadb/run.sh&

\## dockerize - Delay Time In Seconds

. /userContent/delay.sh

14라인



24라인

\## node 실행
. /userContent/runNode.sh

### userContent/prebuildfs/scripts/libcomponent.sh => opt/bitnami/scripts/libcomponent.sh

50라인

        \#  rm "${CACHE_ROOT}/${base_name}.tar.gz"

        if [ -f "${CACHE_ROOT}/${base_name}.tar.gz.sha256" ]; then

            echo "Using the local sha256 from ${CACHE_ROOT}/${base_name}.tar.gz.sha256"
        
            package_sha256="$(< "${CACHE_ROOT}/${base_name}.tar.gz.sha256")"
        
            \#  rm "${CACHE_ROOT}/${base_name}.tar.gz.sha256"
        
        fi
    
    else

	curl --remote-name --silent "${DOWNLOAD_URL}/${base_name}.tar.gz"
  
    fi
  
    if [ -n "$package_sha256" ]; then
  
        echo "Verifying package integrity"
  
        echo "$package_sha256  ${base_name}.tar.gz" | sha256sum --check -
  
    fi
  
    tar --directory "${directory}" --extract --gunzip --file "${base_name}.tar.gz" --no-same-owner --strip-components=2 "${base_name}/files/"
  
    \#  rm "${base_name}.tar.gz"

64라인


#### 1_build.sh 

`sh 1_build.sh`

- docker build부터 시작하는 쉘스크립트입니다.


#### 2_(run).sh

`sh 2_\(run\).sh`

- docker run부터 시작하는 쉘스크립트입니다.





- Docker-compose는 이미 쉘스크립트 작업으로 단축해놨기 때문에 스킵하였습니다.
- Dockerfile_다음에 붙은 알파벳은 각각
  - U - Ubuntu 20.04
  - J - java 1.8
  - N - node.js
  - T - Tomcat
  - M - MariaDB
  - Ag - nodeApp
    를 의미합니다. 알파벳의 순서는 Dockerfile 내에서의 명령 처리 순서를 의미합니다. 
- NTM은 자바 11.0.11-0버전입니다. 필요한 것을 Dockerfile로 바꿔서 빌드하면 됩니다. 다만 실행시 추가적인 exec가 필요합니다.


- 테스트
  - -v /dat/mariadb:/bitnami/mariadb 옵션을 줬을때, 로컬디스크에 /dat/mariadb가 없을 경우
  `RUN mkdir -p /bitnami/mariadb/data`
  `RUN chmod -R 777 /bitnami/mariadb`
  을 빌드단계에서 실행해도 permission denied가 뜹니다.

  -  `RUN mkdir -p /home/odrGeneral/data`
  `RUN mkdir -p /home/odrGeneral/extra`
  `RUN mkdir -p /home/odrGeneral/resources`
  `RUN chmod -R 707 /home/odrGeneral/` 명령을 빌드단계에서 줘도,
  도커루트 권한 없이 `docker exec -it user_content_full bash`의 명령 등으로 도커 내부에 들어갔을 경우 permission denied가 뜨면서 디렉토리에 못 들어갑니다. 그룹권한에 7으로 줬을 경우엔 들어가집니다.

  - tomcat run.sh 파일에서 35번부터 45번 라인 즉,

  start_command=("${TOMCAT_BIN_DIR}/catalina.sh" "run")

  if am_i_root; then
  
    echo "ppp01"
  
    exec gosu "$TOMCAT_DAEMON_USER" "${start_command[@]}"
  
    echo "ppp02"
  
  else
  
    echo "ppp03"
  
    exec "${start_command[@]}"
  
    echo "ppp04"
  
  fi

  exec라인 양쪽에다가 &을 넣어도 도커 블락이 종료되고, exec를 빼도 종료됨. 35번라인에 run을 start로 바꿔도 종료됩니다.

  - . /opt/bitnami/scripts/libcomponent.sh를 사용하는 라인에서의 상황입니다. cache를 남겨놓는 dockerfile로 만든 도커로도 캐시가 바로 남지 않습니다. 심지어 내부에 접속해서 임의의 디렉토리에서 실행해도 남지 않습니다. 다만 해당 캐시 디렉토리에서 실행하면 캐시가 남습니다.
  `/tmp/bitnami/pkg/cache` 가 해당 캐시 디렉토리입니다.

  - uid가 같은 디렉토리를 생성해서 -u <해당 uid> 옵션을 줄 경우 정상작동하나, root그룹의 uname(예를 들어 userContent)이 같은 디렉토리를 생성해서 -u <해당 uname> 옵션을 줄 경우 비트나미 마리아db를 만드는 과정에서 Permission denied가 뜹니다.
  `mkdir: cannot create directory ‘/bitnami/mariadb/data’: Permission denied`
  테스트 해본 명령 `RUN useradd -g root userContent`
  한 편, -u <해당 uid>옵션을 줘서 비트나미 마리아db를 만들면, 나중에 -u root 옵션으로 진입할 경우, 비트나미 마리아db를 도커파일에서 UID 1001로 관리하기 때문에, 같지 않을 경우 접속이 안되는 문제가 발생합니다.

#### **Email**

lkbzbcg15@gmail.com
