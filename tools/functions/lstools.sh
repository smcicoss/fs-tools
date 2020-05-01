#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			      function lstools
#------------------------------------------------------
# Lista los comandos disponibles
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

function lstools(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    printf '%-15s %-50s\n' "COMANDO" "DESCRIPCIÓN"
    for filelib in $LIB_DIR/*.sh; do
        description="$(awk 'NR==7' $filelib)"
        description=${description#\#*}
        description="$(echo "$description"  | tr -s ' ' | sed 's/ *$//g')"
        filename=$(basename $filelib)
        cmd="${filename%.*}"
        printf '%-15s %-50s\n' "$cmd" "$description"
    done
 }