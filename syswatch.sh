

function mostrar_menu() {
    clear
    echo "===== Herramienta de Administración de Data Center (Bash) ====="
    echo "1. Mostrar los 5 procesos que más CPU consumen"
    echo "2. Mostrar discos conectados (tamaño y espacio libre)"
    echo "3. Mostrar archivo más grande en un directorio especificado"
    echo "4. Mostrar memoria libre y espacio de swap en uso"
    echo "5. Mostrar número de conexiones de red activas (ESTABLISHED)"
    echo "6. Salir"
}

function procesos_top_cpu() {
    echo -e "\nProcesos que más CPU consumen:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

function mostrar_discos() {
    echo -e "\nInformación de discos:"
    df -h --output=source,size,avail,pcent | grep -v tmpfs
}

function archivo_mas_grande() {
    read -rp "Introduce la ruta del directorio: " ruta
    if [ -z "$ruta" ] || [ ! -d "$ruta" ]; then
        echo "La ruta especificada no existe." >&2
        return
    fi

    archivo=$(find "$ruta" -type f -printf "%s %p\n" 2>/dev/null | sort -nr | head -n 1)

    if [ -z "$archivo" ]; then
        echo "No se encontraron archivos en la ruta especificada."
    else
        tamano=$(echo "$archivo" | awk '{print $1}')
        ruta_archivo=$(echo "$archivo" | cut -d' ' -f2-)
        echo "Archivo más grande encontrado:"
        echo "  Ruta completa: $ruta_archivo"
        echo "  Tamaño (Bytes): $tamano"
    fi
}

function memoria_swap() {
    echo -e "\nInformación de memoria:"
    free -h

    swap_total=$(free | awk '/Swap:/ {print $2}')
    swap_usado=$(free | awk '/Swap:/ {print $3}')
    if [ "$swap_total" -gt 0 ]; then
        porcentaje=$(awk "BEGIN {printf \"%.2f\", ($swap_usado/$swap_total)*100}")
    else
        porcentaje=0
    fi
    echo "Swap usado: $swap_usado kB (${porcentaje}%)"
}

function conexiones_red() {
    echo -e "\nConexiones de red activas (ESTABLISHED):"
    conexiones=$(ss -tan state established | tail -n +2)
    total=$(echo "$conexiones" | wc -l)
    echo "Número de conexiones activas: $total"
    if [ "$total" -gt 0 ]; then
        echo "$conexiones"
    else
        echo "No hay conexiones en estado ESTABLISHED."
    fi
}

# Bucle principal
while true; do
    mostrar_menu
    read -rp "Seleccione una opción (1-6): " opcion
    echo ""

    case $opcion in
        1) procesos_top_cpu ;;
        2) mostrar_discos ;;
        3) archivo_mas_grande ;;
        4) memoria_swap ;;
        5) conexiones_red ;;
        6) echo "Saliendo..."; break ;;
        *) echo "Opción no válida." ;;
    esac

    echo ""
    read -rp "Presione Enter para continuar..."
done
