# Параметр для получения информации о сетевых адаптерах
param(
    [switch]$info
)

# Функция для получения информации о сетевых адаптерах
function Get-NetworkAdapterInfo {
    # Получаем все сетевые адаптеры
    $networkAdapters = Get-NetAdapter
    
    # Проходим по каждому адаптеру
    foreach ($adapter in $networkAdapters) {
        # Получаем имя адаптера
        $adapterName = $adapter.Name
        # Получаем состояние адаптера
        $adapterStatus = $adapter.Status
        # Получаем скорость соединения
        $linkSpeed = $adapter.LinkSpeed
        # Получаем тип подключения
        $mediaType = $adapter.MediaType

        # Выводим информацию о сетевом адаптере
        Write-Output "Модель сетевой карты: $adapterName"
        Write-Output "Состояние подключения: $adapterStatus"
        Write-Output "Скорость подключения: $linkSpeed"
        Write-Output "Тип подключения: $mediaType"
        Write-Output "-----------------------------------"
    }
}

# Функция для настройки сетевого адаптера на получение IP через DHCP
function Set-DHCP {
    param (
        [string]$interface
    )

    # Сбрасываем настройки DNS сервера
    Set-DnsClientServerAddress -InterfaceAlias $interface -ResetServerAddresses
    # Включаем DHCP на интерфейсе
    Set-NetIPInterface -InterfaceAlias $interface -Dhcp Enabled
    # Выводим сообщение о завершении настройки
    Write-Output "Настройки сетевого интерфейса $interface изменены на DHCP."
}

# Функция для настройки сетевого адаптера на статический IP
function Set-Static {
    param (
        [string]$interface,
        [string]$ip,
        [string]$mask,
        [string]$gateway,
        [string]$dns
    )

    # Устанавливаем статический IP адрес
    New-NetIPAddress -InterfaceAlias $interface -IPAddress $ip -PrefixLength $mask -DefaultGateway $gateway
    # Устанавливаем DNS сервер
    Set-DnsClientServerAddress -InterfaceAlias $interface -ServerAddresses $dns
    # Выводим сообщение о завершении настройки
    Write-Output "Настройки сетевого интерфейса $interface изменены на статический IP."
}

# Если указан параметр -info, вызываем функцию
if ($info) {
    Get-NetworkAdapterInfo
}
