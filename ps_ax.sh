#!/bin/bash

# Заголовок как в ps ax
echo -e "  PID TTY      STAT COMMAND"

# Перебор каталогов в /proc
for pid in $(ls /proc | grep '^[0-9]*$'); do
    # Проверяем, существует ли файл статуса процесса
    if [ -f "/proc/$pid/stat" ]; then
        # Читаем содержимое stat для получения информации
        stat_info=$(cat /proc/$pid/stat)
        
        # Извлекаем нужные поля
        pid=$(echo "$stat_info" | awk '{print $1}')
        stat=$(echo "$stat_info" | awk '{print $3}')
        
        # Определяем команду
        cmd=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
        if [ -z "$cmd" ]; then
            cmd="[$(cat /proc/$pid/comm 2>/dev/null)]"
        fi
        
        # Определяем терминал (TTY)
        tty=$(ls -l /proc/$pid/fd 2>/dev/null | grep '/dev/tty' | awk '{print $NF}' | head -n 1)
        if [ -z "$tty" ]; then
            tty="?   "
        fi
        
        # Вывод результата
        printf "%5s %-8s %-4s %s\n" "$pid" "$tty" "$stat" "$cmd"
    fi
done