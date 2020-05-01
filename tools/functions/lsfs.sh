#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			        filesystem
#------------------------------------------------------
# Lista la estructura del sistema de ficheros
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
# fecha:	mié ene 22 03:14:03 CET 2020
#------------------------------------------------------
#######################################################

function lsfs(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ $verbose ]]; then
        lsblk -o NAME,TYPE,FSTYPE,SIZE,MODEL,MOUNTPOINT | \
            grep -v -e "squashfs" 
    else
        lsblk -lno NAME,TYPE,FSTYPE,SIZE,MODEL,MOUNTPOINT | \
            grep -v -e "squashfs" 
    fi
}
