#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#					function label2dev
#------------------------------------------------------
# Obtiene el dispositivo correspondiente a una etiueta
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	label2dev [-v] [label | --all]
#
#	-v verbose
#
#######################################################

function label2dev(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -eq 0 ]; then return 1; fi

    if [ $1 == "--all" ]; then
        all="True"
        IFS=$'\n' local -a result=($(ls -l /dev/disk/by-label/ | \
                                    grep -ve "total" | \
                                    cut -d " " -f 9,11 | \
                                    sed 's/\.\.\///g'))
    else
        if [ ! -e "/dev/disk/by-label/$1" ]; then return 2; fi

        IFS=$'\n' local -a result=($(ls -l /dev/disk/by-label/ | \
                                    grep -e $1 | \
                                    cut -d " " -f 9,11 | \
                                    sed 's/\.\.\///g'))
    fi

    if [ "$verbose" ]; then
        printf "%-20s\t%s\n" "LABEL" "DEVICE"
        printf "%-20s\t/dev/%s\n" ${result[*]}
    elif [ "$all" ]; then
        printf "%s\t/dev/%s\n" ${result[*]}
    else
        echo ${result[1]}
    fi

    return 0
}
