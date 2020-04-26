#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#				function mountpoint
#------------------------------------------------------
# Obtiene el punto de montaje del dispositivo
#		en el que descansa el fichereo
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	mountpoint [directorio | file | dispositivo | uuid | label]
#
#	Si no se especifica será el directorio actual
#	-v verbose
#
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/uuid2dev.sh"
source "$LIB_DIR/label2dev.sh"
source "$LIB_DIR/lslabel.sh"

function mountpoint(){
   if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -eq 0 ]; then
        local origen=$(lsdev "$(realpath ".")")
    elif [[ "$1" =~ ^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$ ]]; then
        local origen=$(uuid2dev $1)
    elif [ ! -e $1 ]; then
        IFS=$'\n' local -a labels=($(lslabel --all))
        for label in ${labels[*]}; do
            if [[ $label =~ $1 ]] ; then
                local origen=$(label2dev $1)
                break
            else
                continue
            fi
            return 2
        done
    else
        local origen=$(lsdev "$(realpath "$1")")
    fi

    if [ "$verbose" ]; then
        df | head -1 | \
            tr -s '[[:blank:]]' ' ' | \
            cut -d " " -f 1,8 --output-delimiter=$'\t'
        df "$origen" | \
            grep -e "/" | \
            tr -s '[[:blank:]]' ' ' | \
            cut -d " " -f 1,6 --output-delimiter=$'\t'
        local retcode=$?
    else
        df "$origen" | grep -e "/" | tr -s '[[:blank:]]' ' ' | cut -d " " -f 6
        local retcode=$?
    fi
    return $retcode
}
