#!/bin/bash
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
#* @file  build.sh
#* @brief This is a top level build script 
#* content with Azure
#  
#*
#* @author Sujoy Ray
#* @date April 20, 2023
#* @version 1.0
#* CREDIT: Header credit: University of Colorado coding standard
#* CREDIT: Inspired by https://github.com/cu-ecen-aeld/assignment-6-sujoyray-ucolorado/blob/master/build.sh
#*
#*/

git submodule init
git submodule sync
git submodule update
cd poky
export TEMPLATECONF=./../meta-aesd-proj/conf/templates/am1808/
bitbake core-image-minimal
