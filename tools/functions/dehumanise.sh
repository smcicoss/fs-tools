#! /bin/bash
# -*- ENCODING: UTF-8 -*-
#·
#######################################################
#					function dehumanise
#------------------------------------------------------
# Convierte numeros en formato humano a bytes
#------------------------------------------------------
# autor:	Simón Martínez <simon@cicoss.net>
# fecha:	vie nov 29 10:19:07 CET 2019
#------------------------------------------------------
# Uso:
#       dehumanise [-v] [size | -d]
#           -v  verbose
#           -d  desmontar y borrar
#######################################################

# dependencia
: ${LIB_DIR:="/lib/fs-tools"} #Directorio por defecto si no
                                # asignado en script padre

function dehumanise() {
    if [ ! -z $verbose ]; then unset verbose; fi
    if [[ $# -ne 0 && $1 == "-v" ]]; then local verbose=0; shift; fi
    
    for v in "${@:-$(</dev/stdin)}"; do  
        echo $v | awk \
            'BEGIN{IGNORECASE = 1}
            function printpower(n,b,p) {printf "%u\n", n*b^p; next}
            /[0-9]$/{print $1;next};
            /K(iB)?$/{printpower($1,  2, 10)};
            /M(iB)?$/{printpower($1,  2, 20)};
            /G(iB)?$/{printpower($1,  2, 30)};
            /T(iB)?$/{printpower($1,  2, 40)};
            /KB$/{    printpower($1, 10,  3)};
            /MB$/{    printpower($1, 10,  6)};
            /GB$/{    printpower($1, 10,  9)};
            /TB$/{    printpower($1, 10, 12)}'
    done
}
