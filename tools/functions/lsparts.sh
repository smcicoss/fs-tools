#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			        lspart
#------------------------------------------------------
# Lista los particiones disponibles
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

# dependencia
source "$LIB_DIR/lsdev.sh"

function lsparts(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ $# -ne 0 && $1 == "--all" ]]; then
        source=""
    else
        if [ -z "$1" ]; then
            source=$(realpath ".")
        else
            source=$(realpath "$1")
        fi

        info=$(file -b "$source")

        if [[ ! "$info" =~ "block special" ]]; then
            source=$(lsdev "$source")
        fi
    fi
    
    if [ "$verbose" ]; then
        lsblk -alpio KNAME,NAME,TYPE,SIZE,MOUNTPOINT $source | grep -v -e "loop" -e "disk"
        return $?
    else
        lsblk -alpino KNAME,NAME,TYPE $source | grep -v -e "loop" -e "disk" | \
            tr -s ' ' | cut -d " " -f 1,2 --output-delimiter=$'\t'
        return $?
    fi
}