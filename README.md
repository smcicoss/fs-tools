# fs-tools FILESYSTEM TOOLS

## Herramienta para el manejo del sistema de ficheros

> *Obtiene información, manipula y ofrece funciones sobre discos, directorios y ficheros.*
>
> *Trabaja sobre* **HDs, USBs, RAMDiscs, ISOs, CDROMs**
>
> *Utiliza **scripts Bash** para el trabajo y **scripts Python** para la configuración.*

## Sección Discos y Particiones

- **lstools**  
Lista de utilidades disponibles
- **lsfs**  
Lista la estructura del sistema de ficheros.
- **lsdisks**  
Lista los discos en el sistema
- **lsparts**  
Lista las particiones disponibles
- **lsdev**  
Lista el dispositivo en el que descansa un fichero o directorio
- **lsusbdisks**  
Lista los discos USB
- **lslabels**  
Lista las etiquetas de las particiones
- **lsuuids**  
Lista las UUID de las particiones
- **label2dev**  
Obtiene el dispositivo asignado a la partición con LABEL
- **uuid2dev**  
Obtiene el dispositivo asignado a la particion con UUID
- **lsmounts**  
Lista los dispositivos montados
- **mountpoint**  
Obtiene el punto de montaje de un dispositivo
- **fstype**  
Obtiene el type de sistema de ficheros de una partición
- **sizedisk**  
Obtiene el tamaño de un disco o partición
- **lsregdisks**  
Lista discos registrados
- **isrdconnected**  
Comprueba si está conectado un disco registrado
- **mountreg**  
Abre y monta o desmonta y cierra un disco registrado
- **ramdisk**  
Crea y monta un disco RAM
- **mountiso**  
Monta una imagen ISO
- **umountiso**  
Desmonta una imagen ISO
- **dehumanise** (auxiliar)  
Convierte numeros en formato humano a entero  
    (1K[iB] -> 1024, 1KBS -> 1000)
