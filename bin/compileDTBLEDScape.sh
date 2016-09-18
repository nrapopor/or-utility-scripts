#!/bin/bash
TM=`date +%Y%m%d-%H%M%S-%3N`
DTB_NAME=${1%%.dts}
DTB_OUT_NAME=${2%%.dtbo}
BKUP_FOLDER_BASE=~/dtb_backups/LEDScape
KERNEL=$(uname -r)
BKUP_FOLDER=${BKUP_FOLDER_BASE}/${KERNEL}
BKUP_BASE=${BKUP_FOLDER}/${DTB_NAME}.${TM}

FNAME_BASE=./${DTB_NAME}
FNAME_OUT_BASE=./${DTB_OUT_NAME}.${TM}

if [ ! -d ${BKUP_FOLDER} ]; then
    mkdir -p  ${BKUP_FOLDER}
fi
cp ${FNAME_BASE}.dts ${BKUP_BASE}.dts

dtc -@ -I dts -O dtb ${FNAME_BASE}.dts > ${FNAME_OUT_BASE}.dtbo

echo ${FNAME_OUT_BASE}.dtbo is ready
