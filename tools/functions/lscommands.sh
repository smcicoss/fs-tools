#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			      function lscommands
#------------------------------------------------------
#	Lista los comandos disponibles
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lscommands(){
    printf '%-12s - %-50s\n' "COMANDO" "DESCRIPCIÓN"
    for filelib in $LIB_DIR/*.sh; do
        description="$(awk 'NR==7' $filelib)"
        description=${description#\#*}
        description="$(echo "$description"  | sed 's/ *$//g')"
        filename=$(basename $filelib)
        cmd="${filename%.*}"
        printf '%-12s - %-50s\n' "$cmd" "$description"
    done
 }