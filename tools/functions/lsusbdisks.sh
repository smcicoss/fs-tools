#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			      function lsusbdisks
#------------------------------------------------------
# Lista los discos usb
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsusbdisks(){
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi

    grep -Ff <(sudo hwinfo --disk --short) <(sudo hwinfo --usb --short) | grep -v "disk:"
    return $?
 }