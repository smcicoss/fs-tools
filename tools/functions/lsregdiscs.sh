#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#					function lsregdiscs
#------------------------------------------------------
# Lista los discos registrados
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	lsregdiscs [-v] [uuid | nombre | --all]
#
#	-v verbose
#
#   requiere jq (json query)
#
#######################################################

function lsregdiscs(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ $# -eq 0 || $1 == "--all" ]]; then
        local -a result=($(jq -rc 'keys' /etc/fs-tools/disks.json  | \
                    sed -e 's/\[//g' -e 's/\]//g' -e 's/,/ /g' -e 's/\"//g'))
        local -i retcode=$?
    fi

    if [ "$verbose" ]; then
        for disk in ${result[*]}; do
            echo $disk
        done
    else
        echo "${result[@]}"
    fi
    return $retcode
}
