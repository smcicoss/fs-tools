#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#					function ramdisk
#------------------------------------------------------
# Crea y monta un disco RAM
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
# fecha:	vie nov 29 10:19:07 CET 2019
#------------------------------------------------------
# Uso:
#       ramdisk [-v] [size | -d]
#           -v  verbose
#           -d  desmontar y borrar
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

source "$LIB_DIR/lsmounts.sh"
source "$LIB_DIR/dehumanise.sh"

# return codes
: ${RC_OK:=0}
: ${RC_NO_PARAM:=10}
: ${RC_NO_EXISTS:=11}
: ${RC_BAD_PARAM:=12}
: ${RC_ALREDY_USED=13}

function ramdisk(){
    local target="/mnt/RAMDISK"
    local renum='^[0-9]*[KMGT]?i?B?$'

    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi
    if [[ $# -ne 0 && $1 == "-d" ]]; then 
        if findmnt ramdisk >/dev/null; then
            if sudo umount ramdisk; then
                if sudo rmdir $target; then
                    if [ "$verbose" ]; then
                        echo -e $msg_ok"Disco RAM satisfactoriamente desmontado"$msg_end
                    fi
                    return $RC_OK
                fi
            fi
        fi
        if [ "$verbose" ]; then
            echo -e $msg_error"No se ha podido desmontar completamente el disco ram"$msg_end
        fi
        return $?
    fi

    if [ $# -eq 0 ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"Uso:\n\tmountiso [-v] <size_disk>"$msg_end
        fi
        return $RC_NO_PARAM
    elif [[ $1 =~ $return ]]; then  #[ $1 -eq $1 ]; then
            disksize=$(dehumanise $1)
    elif [ "$verbose" ]; then
        echo -e $msg_error"El parametro $1 ha de ser un entero"$msg_end
        return $RC_BAD_PARAM
    else
        return $RC_BAD_PARAM
    fi

    if findmnt ramdisk >/dev/null; then
        if [ "$verbose" ]; then
            echo -e $msg_error"Actualmente ya existe un disco ram"$msg_end
        fi
        return $RC_ALREDY_USED
    fi

    memfree=$(free -b | grep -v -e "available" |tr -s ' '|cut -d ' ' -f 7)
    x=$(echo "scale=0; $memfree * .9" | bc)
    maxmem=${x%.*}

    if [ $maxmem -le $disksize ]; then
        echo -e $msg_error"La memoria disponible es de $memfree B"$msg_end
        return $RC_BAD_PARAM
    fi

    sudo install -d $target
    if [ $? -ne 0 ]; then return $?; fi
    sudo chown simo $target
    if [ $? -ne 0 ]; then return $?; fi
    sudo chmod 700 $target
    if [ $? -ne 0 ]; then return $?; fi
    sudo mount -t tmpfs -o size=$disksize ramdisk $target
    if [ $? -ne 0 ]; then return $?; fi

    if [ "$verbose" ]; then
        df -hT $target
    fi
    return $RC_OK
}
