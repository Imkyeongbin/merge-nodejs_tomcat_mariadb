#!/bin/bash

DELAY_TIME="120"
STATIC_HOST_URI=http://127.0.0.1:8020

exist=0

for var in $@
do
  if [ ${var} = "--pa" ];then
   exist=1
   continue
  elif [ ${var} = "--pw" ];then
   exist=2
   continue
  elif [ ${var} = "--pd" ];then
   exist=3
   continue
  elif [ ${var} = "-t" ];then
   exist=4
  continue
  elif [ ${var} = "--aaocr" ];then
   exist=5
  continue
  elif [ ${var} = "--adocr" ];then
   exist=6
  continue
  elif [ ${var} = "--hana" ];then
   exist=7
  continue
  elif [ ${var} = "--allcore" ];then
   exist=8
  continue
  elif [ ${var} = "--baseurl" ];then
   exist=9
  continue
  elif [ ${var} = "--statichost" ];then
   exist=10
  continue
  fi
  if [ ${exist} == 1 ];then
   PORT_A=${var}
   continue;
  elif [ ${exist} == 2 ];then
   PORT_B=${var}
   continue;
  elif [ ${exist} == 3 ];then
   PORT_C=${var}
   continue;
  elif [ ${exist} == 4 ];then
   DELAY_TIME=${var}
  continue;
  elif [ ${exist} == 5 ];then
   OCR_ADDRESS_AGENT_CHANGED=${var}
  continue;
  elif [ ${exist} == 6 ];then
   OCR_ADDRESS_DIRECT_CHANGED=${var}
  continue;
  elif [ ${exist} == 7 ];then
   HANA_BANK_OPTION=${var}
  continue;
  elif [ ${exist} == 8 ];then
   ALL_CORE_OPTION=${var}
  continue;
  elif [ ${exist} == 9 ];then
   BASE_URL_LOCATION_CHANGED=${var}
  continue;
  elif [ ${exist} == 10 ];then
   STATIC_HOST_URI=${var}
  continue;
  fi
done

echo arg : $@
echo ocr agent port : $PORT_A
echo node.js port : $PORT_B
echo mariadb port : $PORT_C
echo delayTimeInSec : $DELAY_TIME
echo OCR_ADDRESS_AGENT_CHANGED : $OCR_ADDRESS_AGENT_CHANGED
echo OCR_ADDRESS_DIRECT_CHANGED : $OCR_ADDRESS_DIRECT_CHANGED
echo HANA_BANK_OPTION_CHANGED : $HANA_BANK_OPTION_CHANGED
echo ALL_CORE_OPTION : $ALL_CORE_OPTION
echo BASE_URL_LOCATION_CHANGED : $BASE_URL_LOCATION_CHANGED
echo STATIC_HOST_URI : $STATIC_HOST_URI

#change config file
#sed -i "s/3306/$PORT_B/g" config_file.conf

# 톰캣은 libtomcat.Sh 파일에서 적용
AGENT_PORT="${PORT_A:-$AGENT_PORT}"
export TOMCAT_HTTP_PORT_NUMBER="$AGENT_PORT"
# export ODR_PORT_A="$PORT_A"
#sed -i "s/ODR_HTTP_PORT_NUMBER:-8019/ODR_HTTP_PORT_NUMBER:-$PORT_A/g" /opt/bitnami/scripts/libtomcat.sh

# 노드의 package.json파일을 tmp로 보내서 처리하고 다시 복사함
WEBUI_PORT="${PORT_B:-$WEBUI_PORT}"
cp /nodeApp/package.json /tmp
sed -i "s/13002/$WEBUI_PORT/g" /tmp/package.json
\cp -f /tmp/package.json /nodeApp
# export ODR_PORT_B="$PORT_B"

##mariadb
# mariadb 포트 설정
DB_PORT="${PORT_C:-$DB_PORT}"
export MARIADB_PORT_NUMBER="$DB_PORT"

# export ODR_PORT_C="$PORT_C"

#env 파트
cp /nodeApp/.env /tmp
sed -i "s/8036/$DB_PORT/g" /tmp/.env
\cp -f /tmp/.env /nodeApp/
#sed -i "s/23306/$PORT_C/g" /opt/bitnami/scripts/mariadb-env.sh

#cp /userContents/delay.sh /tmp
sed -i "s/timeout 180/timeout $DELAY_TIME/g" /userContents/delay.sh
#\cp -f /tmp/delay.sh /userContents

#ocr address 변경
export OCR_ADDRESS_AGENT=${OCR_ADDRESS_AGENT_CHANGED:-$OCR_ADDRESS_AGENT}

#ocr direct address 변경
export OCR_ADDRESS_DIRECT=${OCR_ADDRESS_DIRECT_CHANGED:-$OCR_ADDRESS_DIRECT}/icr/recognize_document_pos_multi


#HANA_BANK 변경
export HANA_BANK_OPTION=${HANA_BANK_OPTION_CHANGED:-$HANA_BANK_OPTION}

#ALL_CORE 변경
export ALL_CORE=${ALL_CORE_OPTION:-$ALL_CORE}

#BASE_URL_LOCATION 변경
export BASE_URL_LOCATION=${BASE_URL_LOCATION_CHANGED:-$BASE_URL_LOCATION}

#STATIC_HOST_URI로 .env변경
cp /nodeApp/.env /tmp
sed -i "s#http://127.0.0.1:8020#$STATIC_HOST_URI#g" /tmp/.env
\cp -f /tmp/.env /nodeApp/


echo a port : $AGENT_PORT
echo b port : $WEBUI_PORT
echo c port : $DB_PORT
echo delay_time_in_sec : $DELAY_TIME
echo OCR_ADDRESS_AGENT : $OCR_ADDRESS_AGENT
echo OCR_ADDRESS_DIRECT : $OCR_ADDRESS_DIRECT
echo HANA_BANK_OPTION : $HANA_BANK_OPTION
echo ALL_CORE : $ALL_CORE
echo BASE_URL_LOCATION : $BASE_URL_LOCATION
echo STATIC_HOST_URI : $STATIC_HOST_URI