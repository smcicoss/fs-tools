#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function lsdev
#------------------------------------------------------
#	Muestra el dispositivo en el que descansa
#		el fichero o directorio
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	lsdev [-v] [directorio | file]
#
#	Si no se especifica será el directorio actual
#	-v verbose=Salida extendida.
#
#######################################################

function lsdev(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -ne 0 ]; then
        origen=$(realpath "$1")
    else
        origen=$(realpath ".")
    fi

    if [ -d "$origen" ]; then
        #Si es un directorio tal cual
        origen="$origen/"
    else
        origen="$origen"
    fi

    if [ "$verbose" ]; then
        df --sync -hT "$origen"
        return $?
    else
        df "$origen" | grep "/" | cut -d " " -f 1
        return $?
    fi
}