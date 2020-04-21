#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			    function sizedisc
#------------------------------------------------------
# Muestra la capacidad de los discos
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function sizedisc(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi
    
    if [ -z $1 ]; then return 1; fi
    
    if [ $1 == "-f" ]; then local full=0; shift; fi

    if [ -z $1 ]; then
        return 1
    elif [ $1 == "--all" ]; then 
        local source=""
        shift
    else
        local source="$1"
        local info=$(file -b "$source")

        if [[ ! "$info" =~ "block special" ]]; then
            return 2
        fi
    fi

    if [ "$full" ]; then
        if [ "$verbose" ]; then
            lsblk -lapo KNAME,MODEL,SIZE,TYPE $source | grep -v -e "/dev/loop"
            return $?
        else
            lsblk -lapno KNAME,SIZE $source | grep -v -e "/dev/loop"
            return $?
        fi
    else
        if [ "$verbose" ]; then
            lsblk -ladpo KNAME,MODEL,SIZE,TYPE $source | grep -v -e "/dev/loop"
            return $?
        else
            lsblk -ladpno KNAME,SIZE $source | grep -v -e "/dev/loop"
            return $?
        fi
    fi
}