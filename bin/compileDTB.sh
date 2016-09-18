#!/bin/bash
TM=`date +%Y%m%d-%H%M%S-%3N`
DTB_NAME=am335x-boneblack-overlay
BKUP_FOLDER_BASE=~/dtb_backups
KERNEL=$(uname -r)
BKUP_FOLDER=${BKUP_FOLDER_BASE}/${KERNEL}
BKUP_BASE=${BKUP_FOLDER}/${DTB_NAME}.${TM}

FNAME_BASE=/boot/dtbs/${KERNEL}/${DTB_NAME}

if [ ! -d ${BKUP_FOLDER} ]; then
    mkdir -p  ${BKUP_FOLDER}
fi
mv ${BKUP_FOLDER}/${DTB_NAME}.dts_pru ${BKUP_BASE}.dts_pru

dtc -I dts -O dtb ${BKUP_BASE}.dts_pru > ${BKUP_BASE}.dtb_pru

sudo cp ${BKUP_BASE}.dtb_pru ${FNAME_BASE}.dtb

echo ${FNAME_BASE}.dtb is ready
