##### Ubuntu ver 20.04 & nvidia/cuda:11.3.1

##### Node.js ver 14.17.0

##### Tomcat ver 9.0.62    기본 PORT=>8019

##### mariadb ver 10.5.9   기본 PORT=>8036

##### nodeApp   기본 PORT=>8020

##### Run단계에서 이미지 뒤에 붙을 수 있는 옵션이 10개가 있습니다.
 - --pa, --pw, --pd는 각각 Agent, WebUI, DB의 포트입니다.
 - -t는 db와 WebUI 구동 사이에 최대 대기할 초입니다. -t옵션은 간혹 마리아db 세팅도중에 노드가 실행되어 마리아db없이 작동하다 에러가 뜨는 것을 방지하기 위해 만들어진 딜레이 컨트롤 옵션이고 기본값은 120(초)입니다.
 - --aaocr <URL> 은 OCR의 AGENT의 ADDRESS입니다.
 - --adocr <URL> 은 OCR에 직접 연결하는 ADDRESS 입니다. 호스트와 포트번호까지만 있으면 상세 주소는 자동으로 붙습니다.
 - --hana true는 하나은행용 변수 옵션을 켜는 것입니다.
 - --allcore 1은 모든 코어수 만큼 웹ui용 프로세스를 만드는 옵션이며 최초 실행시에는 권장하지 않습니다. 0은 웹ui가 한 프로세스만 사용합니다.
 - --baseurl 뒤에는 하나은행 agent 주소가 들어가면 됩니다.
 - --statichost은 하나은행용 옵션으로, 웹UI의 주소를 --statichost 뒤에 적은 주소로 고정합니다.

  ```
  docker run --name userContentsagent_webui -p 13333:13333 userContentsagent_webui:20220419 --pa 13333 --pw 22222 --pd 33333 -t 120 --aaocr http://userContentsagent_webui:13333/ocr --hana true --adocr http://userContentsagentocr:30006 --allcore 0 --baseurl http://10.60.64.131:18080 --statichost http://cloudocr.userContentssoft.net:13301
  ```


##### 주의) 실행시 톰캣(에이전트)의 포트가 8019로 바뀝니다. 즉 접속하려면
  - `localhost:8019` 으로 접속해야합니다.
  - ~~만일 다른 포트로 접속하려면 Run 단계에서 이미지 뒤에
  `--pa (임의의 포트넘버)`
  옵션을 줘서 변경하면 됩니다. 예를 들면,
  
  ```
  docker run --name userContentsagent_webui -p 12345:12345 userContentsagent_webui:20220419 --pa 12345
  ```

##### nodeApp를 git clone한 이후 정상 구동하기 위해선 1_build.sh 파일에서 `.env`파일을 교체해줘야할 수 있습니다.

* env파일에 대한 설명은 아래와 같습니다.
  - env_CO13008_local.env은 cloudocr.userContentssoft.net으로 연결하고 OCR_DEMO_UPLOAD_URL이 cloudocr의 13008포트로 연결되는 환경변수 파일
  - env_CO15019_local.env은 cloudocr.userContentssoft.net으로 연결하고 OCR_DEMO_UPLOAD_URL이 cloudocr의 15019포트로 연결되는 환경변수 파일
  - env_docker_local_ocr_all_kebhanabank.env은 docker의 내부에 있는 mariadb로 연결하고 OCR_DEMO_UPLOAD_URL은 OCR_ADDRESS_AGENT변수로 받고, OCR_DEMO_UPLOAD_URL_HANABANK은 OCR_ADDRESS_DIRECT변수로 받고, 실제 쓰이는 OCR_DEMO_UPLOAD_URL을 망라해놓고 하나은행 변수를 HANA_BANK_OPTION 변수로 받고 BASE_URL을 BASE_URL_LOCATION으로 받는 환경변수 파일, 하나은행 id와 패스워드를 사용한 것.
  - env_docker_local_ocr_all.env은 docker의 내부에 있는 mariadb로 연결하고 OCR_DEMO_UPLOAD_URL은 OCR_ADDRESS_AGENT변수로 받고, OCR_DEMO_UPLOAD_URL_HANABANK은 OCR_ADDRESS_DIRECT변수로 받고, 실제 쓰이는 OCR_DEMO_UPLOAD_URL을 망라해놓고 하나은행 변수를 HANA_BANK_OPTION 변수로 받고 BASE_URL을 BASE_URL_LOCATION으로 받는 환경변수 파일
  - env_docker_local.env은 docker의 내부에 있는 mariadb로 연결하는 환경변수 파일
  - env_ubuntu_local.env은 lucas 노트북의 버추얼박스 호스트 우분투에 있는 mariadb로 연결하는 환경변수 파일





- ver. 20220419 : 현행 도커파일은 Dockerfile_J11T9와 동일합니다.

- bitnami tomcat의 최신 버전은 기본적으로 패스워드를 요구합니다. Dockerfile내의 특별한 변경이 없었을 경우, 기본 id와 패스워드는 `manager` / `@userContents@` 입니다. 만일 톰캣에서 비밀번호를 요구하는 일이 있을 경우 해당 항목을 입력하면 될 것입니다.

- bitnami의 Dockerfile 소스 내용을 활용하는 경우, 타겟 디렉토리 내부에 있는 shell파일을 실행하다가 Permission denied로 막히는 경우가 있습니다. 그리하여 새로 올린 tomcat9.0 디렉토리는 `chmod -R 775` 속성을 줬습니다.

- cuda 11.3.1 버전은 우분투 20.04.1을 써서 2022년 3월 31일 현재 libxml2-dev 의 리포지토리 문제로 libxml2-dev를 사용하지않은 imagemagick이 만들어집니다.

- ~~nvidia/cuda 버전을 11.3.1-devel-ubuntu20.04 에서 11.6.0-devel-ubuntu20.04 로 변경했습니다.~~ 11.3.1-devel-ubuntu20.04로 롤백합니다. 2022년 3월 31일 현재 사내에서 쓰고 있는 드라이버와 호환이 되는 최신 버전입니다.

- imagemagick heic지원 버전 설치하는 RUN항목을 추가했습니다. 해당 항목에 dockerize도 wget으로 파일을 다운받던 것에서 해당 파일을 /@externalFiles 디렉토리에 포함시키는 것으로 변경해서 동시에 설치합니다.

- EXPOSE 18020을 8020으로 변경했습니다.

- EXPOSE 13301을 삭제했습니다. EXPOSE 18019를 18020으로 변경했습니다.(WEB UI포트)

- AGENT_ID와 AGENT_KEY가 .env에 빈값으로 추가되었습니다. 에이전트를 정상적으로 활용하기 위해서는 .env를 변경 후 한번 리스타트해야합니다.

- ~~runNode에 pm2 delete all을 넣어도 실행되게 개선했습니다. 노드 앱을 다시 리스타트하는 게 편해졌습니다. 하지만 여전히 arg.sh에서 변경된 변수는 재설정하고 앱을 다시 올려야 합니다.~~ 도커가 해당 단계에서 풀려서 restartNode라는 shell을 따로 만들었습니다.

- ecosystem.config.js를 다듬었습니다. 이제는 도커내부에서 runNode.sh명령과 OCR_ADDRESS_DIRECT등의 변수를 변경하면 도커 리스타트 없이 노드 앱을 다시 올릴 수 있습니다. 

- --statichost 옵션으로 하나은행의 고정 호스트 주소명을 지정할 수 있습니다. 매번 해당 주소의 연계된 URL로 들어갑니다.

예) --statichost http://cloudocr.userContentssoft.net:13301

- userContentsagent_full:YYYYMMDD 이던 이미지명을 userContentsagent_webui:YYYYMMDD 로 개명했습니다. build단계에서 'webui'로 나옵니다.

- arg.sh의 마지막 단계에서 OCR_ADDRESS_DIRECT_CHANGED를 보여주던 것을 OCR_ADDRESS_DIRECT를 보여주게 변경

- 기본 OCR_ADDRESS_AGENT="http://localhost:18019/ocr"

  OCR_ADDRESS_DIRECT="http://userContentsagentocr:30006"

  로 변경

- `1_build.sh`과, `1_build_ibk.sh`에서 mariadb가 /bitnami/userContentsdata에 바인딩 되던 도커옵션을 /userContentsdata에 바인딩 되게 변경함(내부 마리아db 심볼릭 링크된 위치)

- OCR_ADDRESS가 OCR_ADDRESS_AGENT로 변수명이 바뀌었습니다. --aocr옵션도 변수명 따라 --aaocr로 바뀌었습니다.

- 기존 nodeApp의 static 디렉토리에 있던 파일을 도커 내부 static에 복사한 이후 다시 nodeApp에 복사하여 파일을 유지합니다.

- /bitnami/mariadb의 심볼릭 링크 디렉토리 /userContentsdata를 생성합니다. db예정 디렉토리를 /userContentsdata에 v옵션으로 묶으면 됩니다.

- 1_build_kebhana.sh 파일이 추가되었습니다. 하나은행 환경에 필요한 .env파일을 가져옵니다. 1_build.sh 파일은 기존 환경에 필요한 .env파일을 copy해서 가져옵니다.

- ~~Dockerfile_User_Hana 파일과 Dockerfile_User_userContents 파일이 추가되었습니다. 각각 하나은행 값과(특히 DB유저명과 암호) 디폴트 값으로 나뉩니다.~~ DB유저명과 암호가 변경될 필요가 없었으므로 Dockerfile = Dockerfile_UJNTMAg 하나만 사용하게 되었습니다.

- BASE_URL이 환경변수와 .env파일에 추가되었습니다. BASE_URL은 `--baseurl http://<주소:포트>` 옵션에 의해 변경될 수 있습니다.

- _reference/server는 원활한 하나은행 에이전트 연동을 위한 참고 파일이 있습니다.

- Dockerize용 생성파일(mariadb_setting_done)이 생성 확인될 때마다 삭제되도록 바꿨습니다.

- 도커파일에서 ENV에 ALL_CORE 옵션이 추가되었습니다. 연동하는 --allcore 옵션이 추가되었습니다.
`--allcore 0`은 단일 프로세스만 노드를 동작시킵니다.
`--allcore 1`은 모든 코어의 갯수만큼의 프로세스 수로 노드를 동작시킵니다.
디폴트는 0입니다.

- package.json의 포트가 13002면 정상동작하게 arg.sh를 변경했습니다.

- 도커파일에서 ENV에 OCR_ADDRESS_DIRECT가 추가되었습니다.
기본값은 `http://cloudocr.userContentssoft.net:13008`입니다.

--adocr 옵션이 추가되었습니다. `--adocr http://cloudocr.userContentssoft.net:13008`의 형태로 OCR을 다이렉트로 지정해줘서 사용할 때 쓰는 옵션입니다.

- runNode.sh파일 내용이 바꼈습니다.

~~`npm run dev&`~~ => ~~`npm run build && npm run start&`~~

=> `npm run build && PORT=$WEBUI_PORT pm2 start /userContents/ecosystem.config.js --only UI$ALL_CORE`

- node에서 필요한 두 디렉토리를 도커파일에서 미리 만듭니다. (nodeApp/.nuxt , nodeApp/node_modules/.cache 디렉토리 미리 생성)

- HANA_BANK를 도커파일 env 환경변수에 추가했습니다. HANA_BANK를 불러오는 옵션도 arg.sh에 추가했습니다.

- _reference에 ver.md에 깃랩 태그를, 생성한 이미지와 같이 적어두었습니다. run파일에도 깃랩 태그를 echo로 알리게 처리해놓았습니다.

- _reference에 서버 이미지가 누락될시 생기는 버그 컨트롤용 이미지를 추가했습니다.

- 도커파일에서 `RUN chmod -R g+rwX nodeApp` 명령을 추가했습니다.

- nvidia/cuda:11.3.1-devel-ubuntu20.04 기반으로 만들어졌습니다.

- psmisc추가되었습니다.

- 1_build.sh, 2_(run).sh에 DOCKER_UID 변수를 추가해서 해당 변수에 맞춰 DB소유자나 u 옵션에 해당하는 UID가 변동하게 만들었습니다.

- 도커파일에서 RUN 명령을 간략화 했습니다. 한 명령에 다른 명령들을 &&으로 붙여서 실행시켜 빌드 시간을 단축했습니다.

- ENV를 다소 추가했습니다. AGENT_PORT="18019", WEBUI_PORT="18020", DB_PORT="18036", OCR_ADDRESS="http://127.0.0.1:18019/ocr"

- 옵션 명을 변경했습니다. 

- nodeApp에서 추가로 파일 변경시 필요할 참고 파일을 _reference에 옮겼습니다.

- 소스 아카이브를 archive.ubuntu.com에서 mirror.kakao.com로 변경했습니다.(빌드 속도 향상)

- .env파일들을 _reference 디렉토리에 추가했습니다.

- 도커라이즈 최대 딜레이를 180초로 변경했습니다.

- 원래는 nodeApp를 root에 COPY했는데 이젠 /nodeApp에 COPY합니다.- Dockerize가 추가되었습니다. Dockerize는 마리아db세팅 완료 후 재시작하기 직전까지 대기하는 용도로 스크립트를 짜놓았습니다. mariadb/rootfs/opt/bitnami/scripts/mariadb/run.sh에서 touch로 userContents폴더에 mariadb_setting_done를 만드는 것을 기다리는 스크립트입니다. 만약 정상구동이 안되어 마리아db세팅이 완료되지 않았고 딜레이시간이 다됐다면 도커구동을 종료합니다.


- userContents폴더 안에 ROOT.war파일, arg.sh, cpROOT.sh, delay.sh, run.sh 파일 등을 넣어놓았습니다. => ROOT.war, cpROOT.sh 제거했습니다.

- Dockerize가 추가되었습니다. Dockerize는 마리아db세팅 완료 후 재시작하기 직전까지 대기하는 용도로 스크립트를 짜놓았습니다. mariadb/rootfs/opt/bitnami/scripts/mariadb/run.sh에서 touch로 userContents폴더에 mariadb_setting_done를 만드는 것을 기다리는 스크립트입니다. 만약 정상구동이 안되어 마리아db세팅이 완료되지 않았고 딜레이시간이 다됐다면 도커구동을 종료합니다.

- 1. 현재 Run단계에서 로컬디스크에 /dat/mariadb디렉토리가 없을 때 v옵션을 달 경우,
  `cannot create directory ‘/bitnami/mariadb/data’: Permission denied`
   에러가 뜹니다. 그 경우 Run단계에서 -u root 옵션을 이미지 앞에 추가 하고 1차적으로 실행하면 디렉토리를 생성해 줍니다. 경우에 따라 sudo권한이 필요할 수 있습니다. 다만 -u root를 넣을 경우에 톰캣이 정상 구동을 하지 않기 때문에 톰캣을 구동하기 위해서는 다시 -u root 옵션을 빼고 Run 단계를 실행해야 합니다.
  1. 혹은, /dat/mariadb 디렉토리를 생성해주고
  `sudo chown -R 1001:1001 <directory>`
   로 소유권을 바꿔주면 -u root 넣어주고 두번 실행할 거 없이 마리아db가 정상 세팅됩니다.

- 포트를 빌드단계에서 바꾸고자 할 때에는
  - 톰캣의 경우 tomcat/rootfs/opt/bitnami/script/libtomcat.sh 와 
  userContents/arg.sh 파일,
  - mariadb의 경우 userContents/arg.sh 파일,
  - nodeApp의 경우 nodeApp/package.json 파일의 port,
  userContents/arg.sh 파일을 변경해줘야 합니다.

- ~~도커 내부 루트에서 `. cpROOT.sh` 명령을 실행하면 도커 이미지 내부의 userContents디렉토리 내부에 있던 ROOT.war 파일이 /app 디렉토리로 복사됩니다.~~ 그냥 따로 올립니다.

- userContents/run.sh로 구동합니다.

- VIM, NANO 추가 되었습니다.

- NET-TOOLS 추가 되었습니다.

- 성공적으로 구동된 환경은 virtualbox - 우분투 20.04입니다. 윈도우 10에서 실행했을 때 dockerfile 6번째 명령에서 install_packages를 못 읽어서 실패했습니다.

- bitnami에 있던 스크립트와 이미지를 기반으로 만들었습니다.


- CMD와 Entrypoint에서의 일인데, 자바와 노드는 별반 명령어가 없습니다.(CMD node/CMD bash)
- Dockerfile에서 Entrypoint와 CMD 명령어 중 하나가 실행되고 있어야 도커 컨테이너가 유지가 되므로, Entrypoint단계에서 톰캣을 돌리기로 했습니다.

- 자바를 1.8.292 버전으로 추가하였습니다.
- userContents에 ROOT.war 파일을 추가하였고, ROOT.war은 774권한으로 변경했습니다.

- odrGeneral디렉토리를 추가하였습니다.

- odrGeneral 디렉토리들의 권한을 770(6 : 읽기쓰기 권한)으로 바꿨습니다.



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

touch /userContents/mariadb_setting_done



## tomcat 바뀐 점

### tomcat/rootfs/opt/bitnami/scripts/tomcat-env.sh

86라인

export JAVA_OPTS="${JAVA_OPTS:--Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Duser.home=$TOMCAT_HOME}"

### tomcat/rootfs/opt/bitnami/scripts/tomcat/run.sh

10라인

\## Load mariadb

. /opt/bitnami/scripts/mariadb/entrypoint.sh /opt/bitnami/scripts/mariadb/run.sh&

\## dockerize - Delay Time In Seconds

. /userContents/delay.sh

14라인



24라인

\## node 실행
. /userContents/runNode.sh

### userContents/prebuildfs/scripts/libcomponent.sh => opt/bitnami/scripts/libcomponent.sh

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

- 테스트
  - -v /dat/mariadb:/bitnami/mariadb 옵션을 줬을때, 로컬디스크에 /dat/mariadb가 없을 경우
  `RUN mkdir -p /bitnami/mariadb/data`
  `RUN chmod -R 777 /bitnami/mariadb`
  을 빌드단계에서 실행해도 permission denied가 뜹니다.

  -  `RUN mkdir -p /home/odrGeneral/data`
  `RUN mkdir -p /home/odrGeneral/extra`
  `RUN mkdir -p /home/odrGeneral/resources`
  `RUN chmod -R 707 /home/odrGeneral/` 명령을 빌드단계에서 줘도,
  도커루트 권한 없이 `docker exec -it userContentsagent_webui bash`의 명령 등으로 도커 내부에 들어갔을 경우 permission denied가 뜨면서 디렉토리에 못 들어갑니다. 그룹권한에 7으로 줬을 경우엔 들어가집니다.

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

  - uid가 같은 디렉토리를 생성해서 -u <해당 uid> 옵션을 줄 경우 정상작동하나, root그룹의 uname(예를 들어 userContents)이 같은 디렉토리를 생성해서 -u <해당 uname> 옵션을 줄 경우 비트나미 마리아db를 만드는 과정에서 Permission denied가 뜹니다.
  `mkdir: cannot create directory ‘/bitnami/mariadb/data’: Permission denied`
  테스트 해본 명령 `RUN useradd -g root userContents`
  한 편, -u <해당 uid>옵션을 줘서 비트나미 마리아db를 만들면, 나중에 -u root 옵션으로 진입할 경우, 비트나미 마리아db를 도커파일에서 UID 1001로 관리하기 때문에, 같지 않을 경우 접속이 안되는 문제가 발생합니다.

#### **Email**

lkbzbcg15@gmail.com
