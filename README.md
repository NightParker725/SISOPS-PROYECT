# SISOPS-PROYECT

Grupo: David Henao - Santiago Castillo

El proyecto consiste en la elaboración de dos herramientas, una en Powershell y otra en BASH, que 
faciliten las labores del administrador de un data center.

Tips de ejecucion:

para ejecutar el script .ps1 se debe de abrir por consola powershell y ejecutar .\syswatch.ps1 dentro de la carpeta del repositorio

para ejecutar el script .sh, se debe de ejecutar por bash a partir del comando ./syswatch.sh, si no se puede ejecutar, se puede corregir mediante el comando sed -i 's/\r$//' syswatch.sh, y luego si ejecutar el comando inicial.

Opciones y explicacion, de la 1 a la 6:

1. Mostrar los 5 procesos que más CPU consumen, al ejecutarlo, se mostrará algo como esto:

--- Procesos que más usan la CPU ---

  Id ProcessName            CPU
  -- -----------            ---
 980 chrome              123.45
1012 explorer             78.90
 874 powershell           65.43
 456 svchost              54.32
 123 Code                 43.21


2. Mostrar filesystems o discos conectados (tamaño y espacio libre), al ejecutarlo, se mostrará algo como esto:

--- Discos y Filesystems Conectados ---

C: - Tamaño total: 238.47 GB, Espacio libre: 112.34 GB
D: - Tamaño total: 465.76 GB, Espacio libre: 300.12 GB

3. Buscar el archivo más grande en una unidad específica, al ejecutarse, el usuario tendría que escribir una unidad de almacenamiento para la busqueda, por ejemplo c:\

Buscando el archivo más grande en C:\ ...

Archivo más grande:
Ruta: C:\Users\reyda\Desktop\bigfile.iso
Tamaño: 456.78 MB

4. Mostrar memoria libre y uso de swap (en bytes y porcentaje), se mostrará algo como esto:

--- Memoria y Swap (Paging File) ---

Memoria libre: 3.45 GB (3707719680 bytes)
Swap usado: 1.23 GB (1321234432 bytes)
Swap usado (%): 23.45%

5. Mostrar Número de conexiones de red activas, se mostrará algo como esto:

--- Conexiones de red activas (ESTABLISHED) ---

Número total de conexiones establecidas: 123

6. la ultima opcion es para salir del programa, y finalizar la sesion del script
