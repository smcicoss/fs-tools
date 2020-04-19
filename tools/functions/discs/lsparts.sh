#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			        lspart
#------------------------------------------------------
#	Lista los particiones disponibles
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsparts(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ $# -ne 0 && $1 == "--all" ]]; then
        origen=""
    else
        if [ -z "$1" ]; then
            origen=$(realpath ".")
        else
            origen=$(realpath "$1")
        fi

        info=$(file -b "$origen")

        if [[ ! "$info" =~ "block special" ]]; then
            origen=$(lsdev "$origen")
        fi
    fi
    
    if [ "$verbose" ]; then
        lsblk -ailpo KNAME,NAME,TYPE,SIZE,MOUNTPOINT $origen | grep -v -e "loop" -e "disk"
        return $?
    else
        lsblk -ailpno KNAME,NAME,TYPE $origen | grep -v -e "loop" -e "disk" | \
            tr -s ' ' | cut -d " " -f 1,2 --output-delimiter=$'\t'
        return $?
    fi
}