#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#				function umountiso
#------------------------------------------------------
# desmonta una imagen ISO
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	umountiso [-v] [nombre_imagen_iso | direcctorio]
#
#	-v verbose
#
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/lsdev.sh"
source "$LIB_DIR/lsmounts.sh"
source "$LIB_DIR/mountpoint.sh"
source "$LIB_DIR/fstype.sh"

# return codes
: ${RC_OK:=0}
: ${RC_NO_PARAM:=10}
: ${RC_NO_EXISTS:=11}

function umountiso(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -eq 0 ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"Uso:\n\tumountiso [-v] [nombre_imagen_iso | direcctorio]"$msg_end
        fi
        return $RC_NO_PARAM
    fi

    if [ -d "$1" ]; then
        local dev=$(lsdev "$1")
    else
        local mounts=$(lsmounts "$1")
        for mnt in $mounts; do
            if [[ $mnt =~ $1 ]]; then local ok="True"; break; fi
        done
        if [ ! "$ok" ]; then 
            if [ "$verbose" ]; then
                echo -e $msg_error"No encuentro '$1'"$msg_end
            fi
            return $RC_NO_EXISTS
        fi
        dev=$(lsdev $mnt)
    fi

    tipo=$(fstype $dev)
    if [ $tipo != "iso9660" ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"El dispositivo encontrado '$dev'\n\tno es de una imagen ISO"$msg_end
        fi
        return $RC_NO_EXISTS
    fi

    local mp=$(mountpoint $dev)

    if [ "$verbose" ]; then
        printf "%-13s %-8s %s\n" "DEVICE" "FSTYPE" "MOUNTPOINT"
        printf "%-13s %-8s %s [*]\n" $dev $tipo "$mp"
    fi

    sudo umount "$dev"
    local retcode=$?
    if [ $retcode -eq 0 ]; then
        sudo rmdir "$mp"
        retcode=$?
    fi

    return $retcode
}
