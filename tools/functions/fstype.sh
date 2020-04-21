#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#						fstype
#------------------------------------------------------
# Muestra el sistema de ficheros de una partición 
#       o un directorio
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	fstype [device | directorio]
#
#	si no se especifica será el directorio actual
#
#	Requiere del script lsdev
#   En caso de indicar una partición no necesita estar
#       montada
#######################################################

# dependencias
source "$LIB_DIR/lsdev.sh"

function fstype(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi
    
    if [ -z "$1" ]; then
        source=$(realpath ".")
    else
        source=$(realpath "$1")
    fi

    info=$(file -b "$source")

    if [[ ! "$info" =~ "block special" ]]; then
        source=$(lsdev "$source")
    fi
    
    lsblk -n -o FSTYPE $source
    return $?
}
