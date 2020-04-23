#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#				function isrdconnected
#------------------------------------------------------
# Comprueba si está conectado un disco registrado
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	isrdconnected [nombre]
#
#   requiere jq (json query) y uui2dev
#
#######################################################

# dependencias
source "$LIB_DIR/uuid2dev.sh"

declare -r REGISTRO_DISCOS="/etc/fs-tools/disks.json"

function isrdconnected(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ -z $1 ]; then return 100; fi

    name=$1

    uuid=$(jq -r "."\"$name\"".uuid" $REGISTRO_DISCOS)
    if [ "$uuid" == "null" ]; then
        if [ "$verbose" ]; then
            printf "%-15s %-10s\n" $name "No registrado"
            return 2
        else
            echo "NR"
            return 2
        fi
    fi

    device=$(uuid2dev $uuid | cut -f 2)

    if [ "$device" ]; then
        if [ "$verbose" ]; then
            printf "%-15s %-10s\n" $name $device
            return 0
        else
            echo $device
            return 0
        fi
    else
        if [ "$verbose" ]; then
            printf "%-15s %-10s\n" $name "No conectado"
            return 1
        else
            echo "NC"
            return 1
        fi
    fi
}
