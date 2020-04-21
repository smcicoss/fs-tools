#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·
#######################################################
#			function lsmounts
#------------------------------------------------------
# Muestra particiones montadas
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsmounts(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    local devices=$(df -hT | \
                    grep -E "^/dev/|@" | \
                    grep -v -e "squashfs" | \
                    cut -d " " -f 1 | sort -k1)

    local -a devmontados=()

	#creamos fichero temporal
	dirtemp=$(mktemp -d)
	tmpfile1=$(mktemp -p $dirtemp DevMounted.XXXXXX)
    # tmpfile2=$(mktemp /tmp/DevMountedSort.XXXXXX)

	trap "rm -rf -- "$dirtemp"" INT TERM HUP EXIT

    for d in $devices; do
        findmnt -cl -o SOURCE,TARGET $d | grep -E "^/dev/|@" >> $tmpfile1
    done

    if [ "$verbose" ]; then
        printf "%-30s    %s\n" "NAME" "MOUNTPOINT"
        while read linea; do
            printf "%-30s -> %s\n" $linea
        done < $tmpfile1
    else
        while read linea; do
            printf "%s\t%s\n" $linea
        done < $tmpfile1
    fi
    return 0
}
