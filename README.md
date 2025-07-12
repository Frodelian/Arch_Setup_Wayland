# Arch_Setup_Wayland
<a name="toc"></a>
## Оглавление

- [Загрузка образа на флешку](#загрузка-образа-на-флешку)
- [Дополнительные настройки, поключение к wifi и подключение по ssh](#дополнительные-настройки-поключение-к-wifi-и-подключение-по-ssh)
- [Разметка диска через утилиту gdisk](#разметка-диска-через-утилиту-gdisk)
- [Форматируем разделы](#форматируем-разделы)
- [Добавляем подтома, для btrfs](#добавляем-подтома-для-btrfs)
- [Установка системы](#установка-системы)
- [Время](#время)
- [Язык системы](#язык-системы)
- [Настройка пользователя](#настройка-пользователя)
- [Ускорение обновления системы](#ускорение-обновления-системы)
- [Отредактируем файл mkinitcpio](#отредактируем-файл-mkinitcpio)
- [Ставим загрузчик GRUB](#ставим-загрузчик-grub)
- [Важные настройки перед выходом из arch-chroot](#важные-настройки-перед-выходом-из-arch-chroot)
- [После перезагрузки](#после-перезагрузки)
- [Подключаемся по ssh](#подключаемся-по-ssh)
- [Обновление ключей Arch Linux](#обновление-ключей-arch-linux)
- [Включение 32-битного репозитория](#включение-32-битного-репозитория)
- [Устанавливаем paru](#устанавливаем-paru)
- [ZRAM](#zram)
- [Настроим Bluetooth](#настроим-bluetooth)
- [Установим базовые приложения](#установим-базовые-приложения)
- [Настройка zsh](#настройка-zsh)
- [Установка драйверов для видеокарты](#установка-драйверов-для-видеокарты)
- [Включаем ly](#включаем-ly)
- [Установим dwl](#установим-dwl)
- [Установим timeshift](#установим-timeshift)
- [Firefox](#firefox)
- [Курсор](#курсор)
- [Flameshot](#flameshot)

## Загрузка образа на флешку
[↑ К оглавлению](#toc)

Команда для очистки диска или флешки
```
sudo dd if=/dev/urandom of=/dev/название_флешки bs=1M
```
Задаём формат флешки, для образов лучше F32
```
mkfs.vfat /dev/название_флешки
```
Устанавливаем образ на флешку
```
sudo dd bs=4M if=путь/до/archlinux.iso of=/dev/название_флешки status=progress oflag=sync
```
Быстро чистим диск
```
dd if=/dev/urandom of=/dev/название_диска bs=512 count=1
```

## Дополнительные настройки, поключение к wifi и подключение по ssh
[↑ К оглавлению](#toc)

Увеличим шрифт в терминале(еслин нужно)
```
setfont ter-132b
```
Проверка режима загрузки
```
cat /sys/firmware/efi/fw_platform_size
```
Задаём пароль root перед подключением по ssh(это временный пароль который больше нигде не пригодится)
```
passwd
```
Проверяем, что демон SSH запущен 
```
systemctl status sshd
```
Если демон выключен то вводим следующую команду, затем повторяем предыдущую
```
systemctl start sshd
```
Подключение к Wi-Fi
```
iwctl
```
Список всех Wi-Fi устройств
```
[iwd]# device list
```
Сканирование сетей
```
[iwd]# station wlan0 scan
```
Список обнаруженных сетей
```
[iwd]# station wlan0 get-networks
```
Подключаемся к сети
```
[iwd]# station wlan0 connect название_сети
```
Вывод состояния подключения
```
[iwd]# station wlan0 show
```
Для отключения от сети вводится следующая команда
```
[iwd]# station wlan0 disconnect
```
Выйти
```
[iwd]# exit
```
Вводим команду обнаружения сетевых устройств, а затем проверяем соединение с любым сайтом
```
ip link
```
```
ping linux.org
```
Делаем 5 запросов для проверки соединения
```
ping -c 5 archlinux.org
```
Если мы видим следующее - то всё работает
```
64 bytes from 104.26.15.72: icmp_seq=1 ttl=54 time=67.0 ms
64 bytes from 104.26.15.72: icmp_seq=2 ttl=54 time=67.6 ms
64 bytes from 104.26.15.72: icmp_seq=3 ttl=54 time=68.3 ms
```
Узнаем ip-адрес нашего устройства для подключения по ssh
```
ip addr show 
```
И видим примерно такое 
```
3: wlan0 ....
inet 192.168.1.13
```
На другом компьютере вводим команду, после ввода спросят доверяем ли мы этому устройству и попросят ввести пароль который мы вводили ранее 
```
ssh root@192.168.1.13
```
В случае возникновения ошибок удалить содержимое 
```
vim ~/.ssh/known_hosts
```

## Разметка диска через утилиту gdisk
[↑ К оглавлению](#toc)

Сканируем разделы на устройствах  
```
lsblk
```
Чтобы получить более подробную информацию о конкретном диске 
```
gdisk -l /dev/nvme0n1
```
Запускаем gdisk для выбранного диска
```
gdisk /dev/nvme0n1
```
Для создания новой GPT-разметки (стереть старую разметку)
```
Command (? for help): o
```
Создадим новый раздел
```
Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-976773134, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-976773134, default = 976773119) or {+-}size{KMGTP}: +1G
Hex code or GUID (L to show codes, Enter = 8300): ef00
Changed type of partition to 'EFI system partition'

Command (? for help): n
Partition number (2-128, default 2): 
First sector (34-976773134, default = 2099200) or {+-}size{KMGTP}: 
Last sector (2099200-976773134, default = 976773119) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'
```
Другие команды:

l - поиск из существующих разделов для диска 

p - просмотр текущей разметки 

d - удаление раздела 

t - изменение типа раздела

w - сохранение изменений

## Форматируем разделы
[↑ К оглавлению](#toc)

Для EFI
```
mkfs.fat -F32 /dev/nvme0n1p1 
```
Для root в случае btrfs
```
mkfs.btrfs /dev/nvme0n1p2
```
```
mount /dev/nvme0n1p2 /mnt
```
Для root в случае ext4
```
mkfs.ext4 /dev/nvme0n1p2
```
```
mount /dev/nvme0n1p2 /mnt
```
Для windows
```
mkfs.ntfs /dev/nvme0n1p2
```

## Добавляем подтома, для btrfs
[↑ К оглавлению](#toc)

Создаём подтома
```
btrfs subvolume create /mnt/@
```
```
btrfs subvolume create /mnt/@home
```
Отмонтируем /mnt (Если есть ошибки, то добавим флаг -R рекурсивное размонтирование)
```
umount /mnt
```
Монтируем разделы в наши подтома(для ноутбука zstd, для пк zstd:2) 
```
mount -o rw,noatime,compress=zstd:2,space_cache=v2,discard=async,ssd,subvol=@ /dev/nvme0n1p2 /mnt
```
```
mkdir /mnt/home
```
```
mount -o rw,noatime,compress=zstd:2,space_cache=v2,discard=async,ssd,subvol=@home /dev/nvme0n1p2 /mnt/home
```
Проверяем что смонтировали 
```
df -h
```
или
```
lsblk
```
Монтируем boot
```
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

## Установка системы 
[↑ К оглавлению](#toc)

Для ПК
```
pacstrap -K /mnt base base-devel linux linux-firmware linux-zen linux-zen-headers intel-ucode iucode-tool zsh networkmanager nvim git wget efibootmgr sof-firmware btrfs-progs openssh hiddify
```
Для ноутбука 
```
pacstrap -K /mnt base base-devel linux linux-firmware linux-zen linux-zen-headers amd-ucode zsh networkmanager nvim git wget efibootmgr sof-firmware btrfs-progs openssh hiddify acpi
```
```
pacstrap -K /mnt
base
base-devel
linux
linux-firmware
linux-zen
linux-zen-headers
-------------------------------
ДЛЯ НОУТБУКА
amd-ucode
acpi - информация о батариее ноутбука 
-------------------------------
ДЛЯ ПК
intel-ucode
iucode-tool
-------------------------------
zsh
openssh - для входа по ssh после установки системы
networkmanager - подключение к интернету
nvim - текстовый редактор
git - система контроля версий
wget - утилита для загрузки файлов из сети, поддерживающая HTTP, HTTPS и FTP протоколы
efibootmgr - утилита для управления загрузочными записями UEFI
sof-firmware - прошивки для Sound Open Firmware, используемого для работы со звуковыми устройствами
btrfs-progs - это набор утилит для работы с файловой системой Btrfs
openssh - для подключения по ssh
hiddify (2) - для подключения к моему прокси
```
Сгнерируем файл fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Проверка
```
cat /mnt/etc/fstab
```
Перейдём к корневому катологу
```
arch-chroot /mnt
```

## Время 
[↑ К оглавлению](#toc)

Задаём часовой пояс
```
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
```
Запуститим hwclock, чтобы сгенерировать /etc/adjtime
```
hwclock --systohc --utc
```
Проверка
```
date
```

## Язык системы 
[↑ К оглавлению](#toc)

Отредактируем файл, раскомментировав en_US.UTF-8 UTF-8 и ru_RU.UTF-8 UTF-8
```
vim /etc/locale.gen
```
Раскомментируем те языки, которыми пользуемся
```
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
```
Создадим файл для определения языка, настройки региона и кодировки системы и запишем язык системы
```
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```
Сгенерируем локаль системы
```
locale-gen
```

## Настройка пользователя 
[↑ К оглавлению](#toc)

Пароль пользователю root
```
passwd 
```
Даём имя компьютеру
```
echo "ArchLaptop" >> /etc/hostname
```
Настройка hosts
```
vim /etc/hosts
```
Содержимое файла
```
127.0.0.1        localhost
::1              localhost
127.0.1.1        ArchPC.localdomain ArchPC
```
Добавляем пользователя
```
useradd -m -g users -G wheel -s /bin/zsh frodelian
```
Добавим пользователю пароль
```
passwd frodelian
```
Создаём каталог для дополнительных sudo-правил(возможно он уже есть)
```
mkdir -m 755 /etc/sudoers.d
```
Создаём отдельный файл с правилами для пользователя. Это правило разрешает только пользователю frodelian использовать sudo для любых команд на всех хостах и от имени любого пользователя.
```
echo "frodelian ALL=(ALL) ALL" > /etc/sudoers.d/frodelian
```
Устанавливают правильные права доступа. Это важно! Файлы в /etc/sudoers.d должны быть доступны только для чтения root-ом, иначе sudo будет ругаться на неправильные права.
```
chmod 0440 /etc/sudoers.d/frodelian
```

## Ускорение обновления системы
[↑ К оглавлению](#toc)

Утилита Reflector отсортирует доступные репозитории по скорости
```
sudo pacman -S reflector rsync
```
Если вы из Европейской части России, то советуем всегда использовать зеркала Германии, так как их больше всего и они имеют оптимальную свежесть/скорость
```
sudo reflector --verbose --country 'Germany' -l 25 --sort rate --save /etc/pacman.d/mirrorlist
```
## Отредактируем файл mkinitcpio для того чтобы он мог работать с btrfs и зашифрованой системой 
```
vim /etc/mkinitcpio.conf
```
В hooks обязательно пишем параметры перед filesystems(порядок важен так как здесь он отвечает за порядок загрузки в системе)
```
MODULES=(btrfs)
...
HOOKS=(... filesystems)
```
```
mkinitcpio -P
```

## Ставим загрузчик GRUB
[↑ К оглавлению](#toc)

Установка GRUB
```
sudo pacman -S grub grub-btrfs
```
```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```
```
grub-mkconfig -o /boot/grub/grub.cfg
```

## Важные настройки перед выходом из arch-chroot
[↑ К оглавлению](#toc)

Включаем интернет при запуске системы
```
systemctl enable NetworkManager
```
Пересоздадим initramfs для всех установленных версий ядра, это поможет убедиться, что все изменения учтены, а система грузится корректно
```
mkinitcpio -P
```
Выходим из arch-chroot
```
exit
```
```
umount -R /mnt
```
```
reboot
```

## После перезагрузки
[↑ К оглавлению](#toc)

Синхранизируем время
```
sudo timedatectl set-ntp true
```
Подключение к интернету
```
nmcli device wifi list
```
```
nmcli device wifi connect NAME_wi-fi password *******
```
Вводим команду обнаружения сетевых устройств, а затем проверяем соединение с любым сайтом
```
ip link
```
```
ping linux.org
```

## Подключаемся по ssh
[↑ К оглавлению](#toc)

Проверяем, что демон SSH запущен 
```
sudo systemctl status sshd
```
Если демон выключен то вводим следующую команду, затем повторяем предыдущую
```
sudo systemctl start sshd
```
Узнаем ip-адрес нашего устройства для подключения по ssh
```
ip addr show 
```
И видим примерно такое 
```
3: wlan0 ....
inet 192.168.1.13
```
На другом компьютере вводим команду, после ввода спросят доверяем ли мы этому устройству и попросят ввести пароль который мы вводили ранее 
```
ssh frodelian@192.168.1.13
```
В случае возникновения ошибок удалить содержимое 
```
vim ~/.ssh/known_hosts
```

## Обновление ключей Arch Linux
[↑ К оглавлению](#toc)

Инициализация
```
sudo pacman-key --init              
```
Получить ключи из репозитория
```
sudo pacman-key --populate archlinux 
```
Проверить текущие ключи на актуальность
```
sudo pacman-key --refresh-keys     
```
Обновить пакет archlinux-keyring
```
sudo pacman -Sy archlinux-keyring   
```
Данная операция может занять продолжительное время. Для дальнейшего их автоматического обновления нужно включить службу-таймер, которая оптимизирует процесс при помощи команды archlinux-keyring-wkd-sync
```
sudo systemctl enable --now archlinux-keyring-wkd-sync.timer
```

## Включение 32-битного репозитория
[↑ К оглавлению](#toc)

```
sudo vim /etc/pacman.conf
```
Добавляем если нужно
```
color — цветная подсветка pacman;
ParallelDownloads — количество параллельных загрузок, рекомендация не ниже 5;
ILoveCandy — можно добавить забавный прогрессбар загрузки пакетов в стиле игры Pacman
```
Раскомментировать
```
[multilib]
Include = /etc/pacman.d/mirrorlist 
```
Обновление репозиториев и всех программ (пакетов)
```
sudo pacman -Suy
```

## Устанавливаем paru
[↑ К оглавлению](#toc)

```
git clone https://aur.archlinux.org/paru.git
```
```
cd paru
```
```
makepkg -si
```

## ZRAM
[↑ К оглавлению](#toc)

```
sudo pacman -S zram-generator 
```
```
sudo mkdir -p /etc/systemd/zram-generator.conf.d/
```
```
sudo vim /etc/systemd/zram-generator.conf.d/zram.conf
```
Добавим в файл 
```
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
```
Перезапустим после наших изменений 
```
sudo systemctl daemon-reexec
```
```
sudo systemctl start /dev/zram0
```
Проверим работает ли zram
```
sudo lsblk
```

## Настроим Bluetooth
[↑ К оглавлению](#toc)

```
sudo pacman -S bluez bluez-utils
```
```
lsmod | grep btusb
```
```
sudo systemctl enable bluetooth.service 
```
```
sudo systemctl status bluetooth.service
```
```
journalctl -u bluetooth.service
```
```
sudo systemctl start bluetooth.service
```
```
journalctl -u bluetooth.service
```
```
bluetoothctl
```
```
[bluetooth]# power on
[bluetooth]# default-agent
[bluetooth]# scan on 
[bluetooth]# devices
[bluetooth]# trust 34:88:5D:3E::2B:D1
[bluetooth]# pair 34:88:5D:3E::2B:D1
[bluetooth]# exit 
```
```
sudo vim /etc/bluetooth/main.conf
```
```
AutoEnable=true
```

## Установим базовые приложения 
[↑ К оглавлению](#toc)

```
sudo pacman -S ly alacritty telegram-desktop keepassxc thunar bash-language-server ttf-jetbrains-mono-nerd ttf-jetbrains-mono flameshot mpv
```

## Настройка zsh
[↑ К оглавлению](#toc)

Цветной cat, улучшение df, цветной la, улучшение поиска fzf
```
sudo pacman -S bat duf exa fzf
```
Цвета
```
paru -S --noconfirm zsh-theme-powerlevel10k-git
```
Моя конфигурация 
```
git clone https://github.com/Frodelian/zsh
```
Укажем основные пути для запуска zsh
```
~/.zshenv
```
Основные настройки 
```
~/.config/zsh
```
Для того чтобы nvim всегда запускался через команду vim
```
sudo ln -s /usr/bin/nvim /usr/local/bin/vim
```
```
sudo mkdir -p /root/.config
```
```
sudo cp -r ~/.config/nvim /root/.config/
```

## Установка драйверов для видеокарты 
[↑ К оглавлению](#toc)

Установим драйвера AMD
```
sudo pacman -S mesa-utils mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-mesa-layers lib32-opencl-mesa opencl-mesa
```
Установим драйвера NVIDIA, перед установкой рекомендуется отключить "Secure Boot" в UEFI, ибо из-за этого модули драйвера могут не загрузиться
```
opencl-nvidia libxnvctrl nvidia-settings - с wayland не ставить
```
```
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia vulkan-icd-loader lib32-vulkan-icd-loader libva-nvidia-driver
```
Для btrfs отредактируем файлик mkinitcpio.conf
```
vim /etc/mkinitcpio.conf
```
Для проприетарных драйверов NVIDIA обычно НЕ рекомендуется включать kms в HOOKS, поскольку модуль nvidia не поддерживает KMS так же, как open-source драйверы.
```
MODULES=(btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS=(base udev autodetect microcode modconf block keyboard keymap consolefont filesystems fsck)
```
```
sudo mkinitcpio -P
```

## Включаем ly
[↑ К оглавлению](#toc)

```
sudo systemctl enable ly.service
```
```
sudo vim /etc/ly/config.ini
```
```
sudo vim /lib/systemd/system/ly.service
```
Содержимое файла
```
[Unit]
Description=TUI display manager
After=systemd-user-sessions.service plymouth-quit-wait.service
After=getty@tty2.service
Conflicts=getty@tty2.service

[Service]
Type=idle
ExecStartPre=/usr/bin/printf '%%b' '\e]P011121D\e]P7A9B1D6\ec'
ExecStart=/usr/bin/ly-dm
StandardInput=tty
TTYPath=/dev/tty2
TTYReset=yes
TTYVHangup=yes

[Install]
Alias=display-manager.service
```
```
reboot
```
Ly не рендерит шрифты сам, а использует тот, что уже задан для виртуальной консоли (tty), на которой он запускается. Консоль (tty) использует специальные bitmap-шрифты (psf.gz), а не ttf/otf.
```
echo "FONT=LatArCyrHeb-16" | sudo tee /etc/vconsole.conf
```
Здесь можно посмотреть установленные шрифты
```
cd /usr/share/kbd/consolefonts/
```

## Установим dwl
[↑ К оглавлению](#toc)

Сначала установим зависимости 
```
sudo pacman -S libinput wayland wayland-protocols pkg-config libxkbcommon
```
Для поддержки X11
```
sudo pacman -S xcb-util-wm libxcb xorg-xwayland
```
```
paru -S wlroots-nvidia
```
```
sudo pacman -S wlroots0.18
```
Скачиваем последний стабильный релиз
```
wget https://codeberg.org/dwl/dwl/archive/v0.7.tar.gz
```
```
tar xf v0.7.tar.gz
```
Бар для dwl
```
sudo pacman -S fcft tllist
```
Создайте desktop-файл для дисплей-менеджера
```
/usr/share/wayland-sessions/dwl.desktop
```
```
[Desktop Entry]
Name=dwl
Comment=Wayland compositor dwl
Exec=/usr/local/bin/startdwl.sh
Type=Application
```
```
nvim /usr/local/bin/startdwl.sh
```
```
exec slstatus | dwl
```
```
sudo chmod +x /usr/local/bin/startdwl.sh
```
Яркость
```
sudo pacman -S brightnessctl
```
Звук
```
sudo pacman -S wireplumber
```
Скриншоты 
```
sudo pacman -S grim swappy slurp
```
```
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr
```
Патчи и их описание 

1) Для настройки мониторов https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/monitorconfig

2) Индивидуальная настройка для каждого тега https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/pertag

3) Возможность кликать по бару https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/ipc

4) Добавляет промежутки между клиентами https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/gaps

5) Границы окна не отображаются, если это единственное окно в мозаике. в его теге ИЛИ если окно находится в моноклевой раскладке https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/smartborders

6) Добавляет переключаемую функцию, которая делает клиент видимым для всех тегов https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/sticky

7) Добавляет функции pushup и pushdownдля перемещения окон в порядк https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/push

8) Сфокусировать окно слева, справа, выше или ниже текущего сфокусированного окна https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/focusdir

9) Переместить курсор в центр недавно сфокусированных клиентов https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/warpcursor

10) Переместить курсор в центр недавно сфокусированных клиентов https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/alwayscenter

11) Добавляет возможность изменять тему и размер курсораДобавляет возможность изменять тему и размер курсора https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/cursortheme

12) Возмоность автозапука для приложений https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/autostart

13) Новый клиент подключается вверху стека, а не встаёт на место мастер окна https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/attachtop

14) Бар https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/bar

15) Запретить панели отображать бару при отсутствии клиентов https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/hide_vacant_tags

16) Добавьте поддержку цветного текста статуса в панель https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/barcolors

17) Для игр https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/xwayland-handle-minimize

18) Для игр https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/rlimit_max

19) Для игр https://github.com/wochap/dwl/blob/v0.6-b/dwl-sloppyfocus/dwl-sloppyfocus-diff.patch


## Установим timeshift 
[↑ К оглавлению](#toc)

```
paru -S timeshift timeshift-autosnap
```
```
sudo timeshift --list-devices
```
Создадим снимок с комментарием и с тэгом ежедневный(D) 
```
sudo timeshift --create --comments "[8 June 2025]" Start of Time" --tags D
```
Перейдём в root
```
sudo su
```
Перейдём в домашний католог 
```
cd ~
```
Укажим редактор по умолчанию
```
echo "export EDITOR=nvim" > .bashrc
```
```
source .bashrc
```
```
sudo systemctl edit --full grub-btrfsd
```
Изменяем строчку в файле
```
ExecStart=/usr/bin/grub-btrfsd --syslog -t 
```
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Firefox
[↑ К оглавлению](#toc)

Ссылка на тему 
```
https://github.com/oviung/DownToneUI-Firefox/tree/main
```
Установить тему Firefox на Darkв: Настройки Firefox > Расширения и темы > Темы.
Перейти к
```
about:config
```
(в строке URL) и установите:
```
toolkit.legacyUserProfileCustomizations.stylesheets = true
```
```
widget.windows.mica.popups = 0
```
Перейти к about:support> Найдите «Каталог профилей»
```
~/.mozilla/firefox/b2ozife7.default-release/chrome/DownToneUI
```
Откройте > Скопируйте папку «chrome» в это место.
Перезапустите Firefox.

Дополнительные настройки
```
browser.compactmode.show = true
```
```
browser.uidensity = 1
```

## Курсор
[↑ К оглавлению](#toc)

```
paru -S phinger-cursors
```
```
sudo vim /usr/share/icons/default/index.theme
```
Содержимое index.theme
```
[Icon Theme]
Inherits=phinger-cursors-dark
```
```
sudo vim ~/.gtkrc-2.0
```
Содержимое .gtkrc-2.0
```
gtk-cursor-theme-name="phinger-cursors-dark"
gtk-cursor-theme-size=24
```
```
sudo vim ~/.config/gtk-3.0/settings.ini
```
Содержимое settings.ini
```
[Settings]
gtk-cursor-theme-name=phinger-cursors-dark
gtk-cursor-theme-size=24
```

## Flameshot 
[↑ К оглавлению](#toc)

```
flameshot config   
```
