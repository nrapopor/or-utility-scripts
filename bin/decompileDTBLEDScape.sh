#!/bin/bash
TM=`date +%Y%m%d-%H%M%S-%3N`
DTB_NAME=${1%%.dtbo}
DTB_OUT_NAME=${2%%.dts}
BKUP_FOLDER_BASE=~/dtb_backups/LEDScape
KERNEL=$(uname -r)
BKUP_FOLDER=${BKUP_FOLDER_BASE}/${KERNEL}
BKUP_BASE=${BKUP_FOLDER}/${DTB_NAME}.${TM}

FNAME_BASE=./${DTB_NAME}
FNAME_OUT_BASE=./${DTB_OUT_NAME}.${TM}

if [ ! -d ${BKUP_FOLDER} ]; then
    mkdir -p  ${BKUP_FOLDER}
fi
cp ${FNAME_BASE}.dtbo ${BKUP_BASE}.dtbo

dtc -@ -I dtb -O dts ${FNAME_BASE}.dtbo > ${FNAME_OUT_BASE}.dts

echo ${FNAME_OUT_BASE}.dts ready to edit
