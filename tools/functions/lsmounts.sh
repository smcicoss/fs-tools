#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			    function lsmounts
#------------------------------------------------------
# Lista particiones montadas
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsmounts(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ -z "$1" || $1 == "--all" ]]; then
        local filter=""
    else
        local filter="$1"
    fi
    
    local devices=$(df -hT | \
                    grep -E "^/dev/|@" | \
                    grep -v -e "squashfs" | \
                    grep -e "$filter" | \
                    tr -s ' ' | \
                    cut -d " " -f 1,7 --output-delimiter=$',' )
    
    if [ "$verbose" ]; then
        printf "%-30s %s\n" "DEVICE" "MOUNTPOINT"
    fi

    IFS=$'\n'
    for d in ${devices[*]}; do
        mp=${d/*,/}
        devname=${d/,*/}
        if [ "$verbose" ]; then
            printf "%-30s %s\n" $devname $mp
        elif [ "$filter" == "" ]; then
            echo -e "$devname\t$mp"
        else
            echo $mp
        fi
    done
    return 0

}
