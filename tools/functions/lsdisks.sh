#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function lsdisks
#------------------------------------------------------
# Lista los discos en el sistema
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsdisks(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ "$verbose" ]; then
        lsblk -ildo KNAME,TYPE,SIZE,MODEL | grep -e "KNAME" -e "disk" -e "rom"
        return $?
    else
        lsblk -ilndo KNAME,TYPE | grep -e "disk" -e "rom" | cut -d ' ' -f 1
        return $?
    fi
}
