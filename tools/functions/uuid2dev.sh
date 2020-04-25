#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#					function uuid2dev
#------------------------------------------------------
# Obtiene el dispositivo correspondiente a un uuid
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	label2dev [-v] [uuid | --all]
#
#	-v verbose
#
#######################################################

function uuid2dev(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -eq 0 ]; then return 1; fi

    if [ $1 == "--all" ]; then
        local all="True"
        IFS=$'\n' local -a result=($(ls -l /dev/disk/by-uuid/ | \
                                    grep -ve "total" | \
                                    cut -d " " -f 9,11 | \
                                    sed 's/\.\.\///g'))
    else
        if [ ! -e "/dev/disk/by-uuid/$1" ]; then return 2; fi

        IFS=$'\n' local -a result=($(ls -l /dev/disk/by-uuid/ | \
                                    grep -e $1 | \
                                    cut -d " " -f 9,11 | \
                                    sed 's/\.\.\///g'))
    fi
    
    if [ ${#result[@]} -eq 0 ]; then return 1; fi
    
    if [ "$verbose" ]; then
        printf "%-36s\t%s\n" "UUID" "DEVICE"
        printf "%-36s\t/dev/%s\n" ${result[*]}
    elif [ "$all" ]; then
        printf "%s\t/dev/%s\n" ${result[*]}
    else
        echo ${result[1]}
    fi

    return 0
}
