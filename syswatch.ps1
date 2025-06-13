function MostrarMenu {
    Clear-Host
    Write-Host "============ Bienvenido al menu de DataCenter para Admins flojillos ============"
    Write-Host "1. Ver los cinco procesos que mas CPU consumen"
    Write-Host "2. Mostrar filesystems o discos/unidades conectados (size y espacio libre en bytes)"
    Write-Host "3. Buscar el archivo mas grande en un disco (unidad de almacenamiento, ej: c:\"
    Write-Host "4. Ver la memoria libre y el uso de swap (en bytes y porcentaje)"
    Write-Host "5. Buscar el Nuero de conexiones de red activas (Estado: ESTABLISHED)"
    Write-Host "6. Salir de este script :D"
    Write-Host "================================================================================"
}

function Opcion1 {
    Write-Host "`n===== Procesos que mas usan la CPU ;P =====`n"
    $procesos = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
    $procesos | Format-Table Id, ProcessName, CPU
}

function Opcion2 {
    Write-Host "`n----- Discos y Filesystems Conectados -----`n"
    $discos = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disco in $discos) {
        $sizeGB = [math]::Round($disco.Size / 1GB, 2)
        $freeGB = [math]::Round($disco.FreeSpace / 1GB, 2)
        Write-Host "$($disco.DeviceID) - Size total: $sizeGB GB, Espacio libre: $freeGB GB"
    }
}

function Opcion3 {
    $unidad = Read-Host "Ingrese la unidad (por ejemplo D:\ )"
    if (Test-Path $unidad) {
        Write-Host "`nBuscando el archivo mas grande en $unidad ... espera tantito...`n"
        $archivos = Get-ChildItem -Path $unidad -Recurse -File -ErrorAction SilentlyContinue
        if ($archivos) {
            $archivoMasGrande = $archivos | Sort-Object Length -Descending | Select-Object -First 1
            $tamanoMB = [math]::Round($archivoMasGrande.Length / 1MB, 2)
            Write-Host "Archivo mas grande:"
            Write-Host "Ruta: $($archivoMasGrande.FullName)"
            Write-Host "Size: $tamanoMB MB"
        } else {
            Write-Host "No se encontraron archivos en la ruta especificada, estas seguro de que pusiste una ruta valida?"
        }
    } else {
        Write-Host "La unidad especificada no existe o no es accesible, intenta de nuevo"
    }
}

function Opcion4 {
    Write-Host "`n***** Memoria y Swappping *****`n"
    $memoria = Get-WmiObject -Class Win32_OperatingSystem
    $memoriaLibre = $memoria.FreePhysicalMemory * 1KB
    $swapUsado = $memoria.TotalVirtualMemorySize * 1KB - $memoria.FreeVirtualMemory * 1KB
    $swapPorcentaje = ($swapUsado / ($memoria.TotalVirtualMemorySize * 1KB)) * 100

    Write-Host "Memoria libre: $([math]::Round($memoriaLibre / 1GB, 2)) GB ($([math]::Round($memoriaLibre)) bytes)"
    Write-Host "Swap usado: $([math]::Round($swapUsado / 1GB, 2)) GB ($([math]::Round($swapUsado)) bytes)"
    Write-Host "Swap usado (%): $([math]::Round($swapPorcentaje, 2))%"
}

function Opcion5 {
    Write-Host "`n::::: Conexiones de red activas (ESTABLISHED) :::::`n"
    $conexiones = Get-NetTCPConnection | Where-Object State -eq "Established"
    $total = $conexiones.Count
    Write-Host "Numero total de conexiones establecidas: $total"
}

do {
    MostrarMenu
    $opcion = Read-Host "Seleccione una opcion Mr. admin (1-6)"

    switch ($opcion) {
        '1' { Opcion1 }
        '2' { Opcion2 }
        '3' { Opcion3 }
        '4' { Opcion4 }
        '5' { Opcion5 }
        '6' { Write-Host "Saliendo del programa... espero verlo por aqui pronto!" }
        default { Write-Host "Opción Inexistente, Escribe bien!" }
    }

    if ($opcion -ne '6') {
        Read-Host "Presione la tecla enter para continuar dentro de este menu"
    }

} while ($opcion -ne '6')