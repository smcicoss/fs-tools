#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			      function lsusbdiscs
#------------------------------------------------------
# Lista los discos usb
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
#######################################################

function lsusbdiscs(){
    grep -Ff <(sudo hwinfo --disk --short) <(sudo hwinfo --usb --short) | grep -v "disk:"
    return $?
 }