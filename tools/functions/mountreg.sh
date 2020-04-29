#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#					function mountreg
#------------------------------------------------------
# Monta o desmonta un disco registrado
#	  y abre o cierra el cifrado en caso de estarlo
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
# fecha:	mié nov 20 21:11:37 CET 2019
#------------------------------------------------------
# Uso:
#   mountreg [-v] [--open|--close] [--pass] <nombre>
#   [-v] = Modo verboso
#	[ --open | --close] = acción, open por defecto
#	[pass] = si busca clave en el llavero
#	<nombre> nombre registrado en
#			/etc/fs-tools/disks.json
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre
source "$LIB_DIR/isrdconnected.sh"
source "$LIB_DIR/lsmounts.sh"

# return codes
: ${RC_OK:=0}
: ${RC_NO_PARAM:=10}
: ${RC_NO_EXISTS:=11}
: ${RC_BAD_PARAM:=12}
: ${RC_ALREDY_USED=13}
: ${RC_NO_CONNECTED=14}
: ${RC_NO_OPEN_LLAVERO=20}
: ${RC_NO_CLAVE=21}
: ${RC_NO_OPEN=22}
: ${RC_ALREDY_OPEN=23}
: ${RC_NO_MOUNT=30}
: ${RC_INTERNAL_ERR=255}

: ${REGISTRO_DISCOS:="/etc/fs-tools/disks.json"}

: ${CLAVES:="/root/Claves"}
: ${LLAVERO:="$CLAVES/Llavero"}


function mountreg(){
    # borramos posibles variables globales
    if [ ! -z $verbose ]; then unset verbose; fi
    if [ ! -z $clave ]; then unset clave; fi

    # comprobamos el resto de los conmutadores
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi
    if [[ $# -ne 0 && ( $1 == "--open" || $1 == "--close" )]]; then 
        local action=${1#--*}   # [open|close]
        shift
    else
        local action="open"     # default
    fi

    if [[ $# -ne 0 && $1 == "--pass" ]]; then local clave="True"; shift; fi

    if [ $# -eq 0 ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"Uso:\n\tmountreg [-v] [open|close] [pass] <nombre>"$msg_end
        fi
        return $RC_NO_PARAM
    else
        local name=$1
    fi

    # compruebo si está conectado
    local conn=$(isrdconnected $name)
    if [ $conn == "NC" ]; then
        if [ "verbose" ]; then
            echo -e $msg_error"'$name' no está conectado"$msg_end
        fi
        return $RC_NO_CONNECTED
    elif [ $conn == "NR" ]; then
        if [ "$verbose" ]; then
            echo -e $msg_error"'$name' no está registrado"$msg_end
        fi
        return $RC_NO_EXISTS
    fi
    
    # obtengo es uuid registrado
    local reguuid=$(jq -r "."\"$name\"".uuid" $REGISTRO_DISCOS)

    # Si está codificado
    local encoded=$(jq -r "."\"$name\"".crypt" $REGISTRO_DISCOS)

    local mountpoint="$(jq -r "."\"$name\"".mountPoint" $REGISTRO_DISCOS)"

    if [ $action == "open" ]; then
        # apertura y montado del disco
        if [ $encoded == "true" ]; then
            # apertura cifrado
            opencif $name $reguuid
            local retcode=$?
            case $retcode in
                $RC_OK)
                    if [[ $verbose ]]; then
                        echo -e $msg_ok"'$name' abierto satisfactoriamente"$msg_end
                    fi
                    ;;

                $RC_ALREDY_OPEN)
                    if [[ $verbose ]]; then
                        echo -e $msg_warning"'$name ya estaba abierto"$msg_end
                    fi
                    ;;

                *)
                    if [[ $verbose ]]; then
                        echo -e $msg_panic"Error al abrir '$name'"$msg_end
                    fi
                    return $retcode
                    ;;
            esac
        fi
    
        # creo el directorio si no existe
        install -d $mountpoint
        if [ $? -ne 0 ]; then return $?; fi

        mounted=$(lsmounts $mountpoint)
        if [ "$mounted" ]; then
            if [ "$verbose" ]; then
                echo -e $msg_error"En $mountpoint ya hay un dispositivo montado"$msg_end
            fi
            return $RC_ALREDY_OPEN
        fi

        # busco el nombre del dispositivo
        device=$(sudo lsblk -Pp -o LABEL,NAME | \
                grep $name | \
                awk '{print $2}' | \
                cut -d "=" -f 2 | \
                tr -d '\"')
        if [ ! "$device" ]; then
            if [ "$verbose" ]; then
                echo -e $msg_panic"Error interno: Disco no conectado"$msg_end
            fi
            return $RC_INTERNAL_ERR
        else
            if sudo mount -rw -o exec $device $mountpoint; then
                sudo chown $(logname):$(id -gnr) $mountpoint
                if [ $? -ne 0 ]; then return $?; fi
                sudo chmod 755 $mountpoint
                if [ $? -ne 0 ]; then return $?; fi

                if [[ $verbose ]]; then
                    echo -e $msg_ok"'$name' montado"$msg_end
                fi
                return $RC_OK
            else
                if [[ $verbose ]]; then
                    echo -e $msg_error"No se ha podido montar $name"$msg_end
                fi
                return $RC_NO_MOUNT
            fi
        fi
    fi

    # --close
    # desmontado y cierre del disco
    if mount | grep $mountpoint >/dev/null; then
        sudo umount $mountpoint &>/dev/null
        if [ $? -eq 0 ]; then
            if [[ $verbose ]]; then
                echo -e $msg_ok"'$name' desmontado correctamente"$msg_end
            fi
            local retcode=$RC_OK
        else
            if [[ $verbose ]]; then
                echo -e $msg_error"'$name' no se ha podido desmontar"$msg_end
            fi
            return $RC_INTERNAL_ERR
        fi
    else
        if [[ $verbose ]]; then
            echo -e $msg_warning"'$name' no estaba montado"$msg_end
        fi
        local retcode=$RC_NO_MOUNT
    fi

    if [ $encoded == "true" ]; then
        if sudo cryptsetup status $name >/dev/null; then
			if sudo cryptsetup close $name &>/dev/null; then
                if [[ $verbose ]]; then
                    echo -e $msg_ok"'$name' cerrado satisfactoriamente"$msg_end
                fi
                return $RC_OK
            else
                if [[ $verbose ]]; then
                    echo -e $msg_error"'$name' no se ha podido cerrar"$msg_end
                fi
                return $RC_INTERNAL_ERR
            fi
        else
            if [[ $verbose ]]; then
                echo -e $msg_warning"'$name' ya estaba cerrado"$msg_end
            fi
            return $RC_NO_OPEN
        fi
    else
        return $retcode
    fi
}

function opencif(){     # Abre volumen cifrado Luks
    if [[ $# -ne 0 && $1 == "--pass" ]]; then local clave="True"; shift; fi

    if [ $# -lt 2 ]; then return $RC_NO_PARAM; fi
    
    local name=$1
    local duuid="/dev/disk/by-uuid/$2"

    if sudo cryptsetup status $name >/dev/null; then 
        return $RC_ALREDY_OPEN
    fi

    if [ "$clave" ]; then
        if sudo cryptsetup status Llavero >/dev/null; then
            # El llavero está abierto
            if [ ! -r "$LLAVERO/$name.key"]; then
                # La clave no existe o no se puede leer
                return $RC_NO_CLAVE
            fi
            # Abrimos con clave almacenada en llavero
            if ! sudo cryptsetup --key-file="$LLAVERO/$name.key" \
                    luksOpen $duuid $name; then
                return $RC_NO_OPEN
            else
                return $RC_OK
            fi
        else
            return $RC_NO_OPEN_LLAVERO
        fi
    else
        if ! sudo cryptsetup luksOpen $duuid $name; then
            return $RC_NO_OPEN
        else
            return $RC_OK
        fi
    fi
}
