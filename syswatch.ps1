function MostrarMenu {
    Clear-Host
    Write-Host "==================== Menú del Administrador ===================="
    Write-Host "1. Mostrar los 5 procesos que más CPU consumen"
    Write-Host "2. Mostrar filesystems o discos conectados (tamaño y espacio libre)"
    Write-Host "3. Buscar el archivo más grande en un disco especificado"
    Write-Host "4. Mostrar memoria libre y uso de swap (en bytes y porcentaje)"
    Write-Host "5. Número de conexiones de red activas (ESTABLISHED)"
    Write-Host "6. Salir"
}

function Opcion1 {
    Write-Host "`n--- Procesos que más usan la CPU ---`n"
    $procesos = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
    $procesos | Format-Table Id, ProcessName, CPU
}

function Opcion2 {
    Write-Host "`n--- Discos y Filesystems Conectados ---`n"
    $discos = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disco in $discos) {
        $sizeGB = [math]::Round($disco.Size / 1GB, 2)
        $freeGB = [math]::Round($disco.FreeSpace / 1GB, 2)
        Write-Host "$($disco.DeviceID) - Tamaño total: $sizeGB GB, Espacio libre: $freeGB GB"
    }
}

function Opcion3 {
    $unidad = Read-Host "Ingrese la unidad (por ejemplo C:\ )"
    if (Test-Path $unidad) {
        Write-Host "`nBuscando el archivo más grande en $unidad ...`n"
        $archivos = Get-ChildItem -Path $unidad -Recurse -File -ErrorAction SilentlyContinue
        if ($archivos) {
            $archivoMasGrande = $archivos | Sort-Object Length -Descending | Select-Object -First 1
            $tamanoMB = [math]::Round($archivoMasGrande.Length / 1MB, 2)
            Write-Host "Archivo más grande:"
            Write-Host "Ruta: $($archivoMasGrande.FullName)"
            Write-Host "Tamaño: $tamanoMB MB"
        } else {
            Write-Host "No se encontraron archivos en la ruta especificada."
        }
    } else {
        Write-Host "La unidad especificada no existe o no es accesible."
    }
}

function Opcion4 {
    Write-Host "`n--- Memoria y Swap (Paging File) ---`n"
    $memoria = Get-WmiObject -Class Win32_OperatingSystem
    $memoriaLibre = $memoria.FreePhysicalMemory * 1KB
    $memoriaTotal = $memoria.TotalVisibleMemorySize * 1KB
    $swapUsado = $memoria.TotalVirtualMemorySize * 1KB - $memoria.FreeVirtualMemory * 1KB
    $swapPorcentaje = ($swapUsado / ($memoria.TotalVirtualMemorySize * 1KB)) * 100

    Write-Host "Memoria libre: $([math]::Round($memoriaLibre / 1GB, 2)) GB ($memoriaLibre bytes)"
    Write-Host "Swap usado: $([math]::Round($swapUsado / 1GB, 2)) GB ($swapUsado bytes)"
    Write-Host "Swap usado (%): $([math]::Round($swapPorcentaje, 2))%"
}

function Opcion5 {
    Write-Host "`n--- Conexiones de red activas (ESTABLISHED) ---`n"
    $conexiones = Get-NetTCPConnection | Where-Object State -eq "Established"
    $total = $conexiones.Count
    Write-Host "Número total de conexiones establecidas: $total"
}

# Bucle principal del menú
do {
    MostrarMenu
    $opcion = Read-Host "Seleccione una opción (1-6)"

    switch ($opcion) {
        '1' { Opcion1 }
        '2' { Opcion2 }
        '3' { Opcion3 }
        '4' { Opcion4 }
        '5' { Opcion5 }
        '6' { Write-Host "Saliendo del programa..." }
        default { Write-Host "Opción inválida. Intente nuevamente." }
    }

    if ($opcion -ne '6') {
        Read-Host "Presione Enter para continuar..."
    }

} while ($opcion -ne '6')