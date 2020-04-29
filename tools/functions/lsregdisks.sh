#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#					function lsregdisks
#------------------------------------------------------
# Lista los discos registrados
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	lsregdisks [-v] [uuid | nombre | --all]
#
#	-v verbose
#
#   requiere jq (json query) y uui2dev
#
#######################################################

# dependencias
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/uuid2dev.sh"

: ${REGISTRO_DISCOS:="/etc/fs-tools/disks.json"}

function lsregdisks(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [[ $# -eq 0 || $1 == "--all" ]]; then
        local -a result=($(jq -rc 'keys'  $REGISTRO_DISCOS | \
                    sed -e 's/\[//g' -e 's/\]//g' -e 's/,/ /g' -e 's/\"//g'))
        local -i retcode=$?
    else
        local -a result[0]=$1
    fi

    if [ "$verbose" ]; then
        printf "%-15s %-36s %s\n" "NOMBRE" "UUID" "DEVICE"
        for name in ${result[*]}; do
            uuid=$(jq -r "."\"$name\"".uuid" $REGISTRO_DISCOS)
            device=$(uuid2dev $uuid | cut -f 2)
            printf "%-15s %-36s %s\n" $name $uuid $device
        done
    else
        for name in ${result[*]}; do
            uuid=$(jq -r "."\"$name\"".uuid" $REGISTRO_DISCOS)
            device=$(uuid2dev $uuid | cut -f 2)
            printf "%s\t%s\t%s\n" $name $uuid $device
        done
    fi
    return $retcode
}
