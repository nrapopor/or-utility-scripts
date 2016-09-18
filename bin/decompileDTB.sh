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
cp ${FNAME_BASE}.dtb ${BKUP_BASE}.dtb_orig

dtc -I dtb -O dts ${FNAME_BASE}.dtb > ${BKUP_BASE}.dts_orig

cp ${BKUP_BASE}.dts_orig ${BKUP_FOLDER}/${DTB_NAME}.dts_pru

echo ${BKUP_FOLDER}/${DTB_NAME}.dts_pru ready to edit
