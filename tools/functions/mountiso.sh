#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#				function mountiso
#------------------------------------------------------
# Monta una imagen ISO en un direcctorio
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#------------------------------------------------------
# Uso:
# 	mountiso [-v] <imagen_iso> [direcctorio]
#
#	Si no se especifica el directorio se utiliza
#       /mnt/iso/nombre_iso
#	-v verbose
#
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/lsdev.sh"

# return codes
: ${RC_OK:=0}
: ${RC_NO_PARAM:=10}
: ${RC_NO_EXISTS:=11}

function mountiso(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    if [ $# -eq 0 ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"Uso:\n\tmountiso [-v] <imagen_iso> [direcctorio]"$msg_end
        fi
        return $RC_NO_PARAM
    fi

    if [[ -f "$1" && -r "$1" ]]; then
        local fullpathtoiso=$(realpath "$1")
    else
        if [ "$verbose" ]; then
            echo -e $msg_error"'$1' no existe o no se puede leer"$msg_end
        fi
        return $RC_NO_EXISTS
    fi

    local filename=$(basename "$fullpathtoiso")
    local isoname="${filename%.*}"

    if [[ "$2" && -d "$2" ]]; then
        local dirbase=$(realpath "$2")
    else
        local dirbase="/mnt/iso"
    fi

    local mountpoint="$dirbase/$isoname"

    sudo install -d $mountpoint

    sudo mount -r -t iso9660 -o loop "$fullpathtoiso" "$mountpoint" >/dev/null
    retcode=$?

    if [ "$verbose" ]; then
        printf "%-30s %s\n" "DEVICE" "MOUNTPOINT"
        printf "%-30s %s\n" $(lsdev "$mountpoint") $mountpoint
    else
        echo "$(lsdev $mountpoint)"
    fi
    return $retcode

}
