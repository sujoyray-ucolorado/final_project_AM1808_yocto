#!/bin/sh
#/*****************************************************************************
#* Copyright (C) 2023 by Sujoy Ray
#*
#* Redistribution, modification or use of this software in source or binary
#* forms is permitted as long as the files maintain this copyright. Users are
#* permitted to modify this and use it to learn about the field of embedded
#* software. Sujoy Ray and the University of Colorado are not liable for
#* any misuse of this material.
#*
#*****************************************************************************/
#/**
#* @file  mount-hdd.sh
#* @brief This script will mount the SATA HDD drive 
#  
#*
#* @author Sujoy Ray
#* @date April 20, 2023
#* @version 1.0
#* CREDIT: Header credit: University of Colorado coding standard
#*
#*/


# check if mount point exists, if not create it
if [ ! -d /mnt/mydrive ]; then
    mkdir /mnt/mydrive
fi

# mount the drive
mount /dev/sda1 /mnt/mydrive

# check if the drive is mounted successfully
if mountpoint -q /mnt/mydrive; then
    echo "Drive mounted successfully."
else
    echo "Failed to mount the drive."
fi
