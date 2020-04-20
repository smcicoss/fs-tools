#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#			        filesystem
#------------------------------------------------------
# Devuelve la estructura del systema de ficheros completo
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
# fecha:	mié ene 22 03:14:03 CET 2020
#######################################################

function lsfs(){
    lsblk -o NAME,TYPE,SIZE,MODEL,MOUNTPOINT
    return $?
}