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
#* @file  sync-script.sh
#* @brief This script will monitor the  content written to SATA HDD and will upload the 
#* content with Azure
#  
#*
#* @author Sujoy Ray
#* @date April 20, 2023
#* @version 1.0
#* CREDIT: Header credit: University of Colorado coding standard
#* CREDIT: Consulted https://techcommunity.microsoft.com/t5/azure-paas-blog/performing-simple-blob-storage-rest-api-operations-using-curl/ba-p/3302552 
#*
#*/

#Azure blob storage related details

account_name="aesdfinalproject001"
container_name="mylinuxhdd"
sas_token="sp=racwd&st=2023-04-28T20:14:20Z&se=2023-05-06T04:14:20Z&spr=https&sv=2022-11-02&sr=c&sig=nUNuOGjTavk7it5ikiYa8tzTiNHl7Z2kF%2BLAnLd2Wig%3D"
endpoint="https://$account_name.blob.core.windows.net/$container_name"


# Specify the SATA drive to monitor and the Azure Blob Storage container to sync with
WATCH_DIR="/mnt/mydrive"


handle_azure_file_sync_operation() {
    #echo "File Operation, $1 $2 $3 $4"
    action=$1
    remote_path=$4
    file_name=$3
    local_path=$2
    case $1 in
    "CREATE")
        echo "***File create operation***" "$remote_path/$file_name"
        curl -k -X PUT -T $local_path$file_name -H "x-ms-date: $(date -u)" -H "x-ms-blob-type:BlockBlob" "$endpoint/$remote_path/$file_name?$sas_token"
        ;;
    "DELETE")
        echo "**** File delete operation***"
        curl -k -X DELETE -H "x-ms-date: $(date -u)" -H "x-ms-blob-type:BlockBlob" "$endpoint/$remote_path/$file_name?$sas_token"
        ;;
    "MODIFY")
        echo "**** File modify operation***"
        curl -k -X PUT -T $local_path$file_name -H "x-ms-date: $(date -u)" -H "x-ms-blob-type:BlockBlob" "$endpoint/$remote_path/$file_name?$sas_token"
        ;;
 
    *)
        echo "**** default operation*"
        ;;
    esac
}

# Loop indefinitely and monitor the drive for new files and changes to existing files
while true; do
  # Use the 'inotifywait' command to monitor the drive for new and modified files
  inotifywait -m -r -e create,delete,move,modify,attrib "$WATCH_DIR" | while read path action file; do
    action_type=$(echo $action | awk -F"," '{print $1}')
    is_dir=$(echo $action | awk -F"," '{print $2}')

    dir_name=$(dirname "$path")
    base_name=$(basename "$path")
    
    #echo dir_name_fl=$dir_name
    #echo base_name_fl=$base_name
    
    if [ "$is_dir" = "ISDIR" ]; then
        echo This is a directory operation, not supported
    else
        extension="${file##*.}"
        if [ "$extension" = "swp" ] || [ "$extension" = "swx" ]; then
            echo "Ignoring $file"
            continue
        fi
        handle_azure_file_sync_operation $action_type $path $file $base_name
    fi
    
  done
done

