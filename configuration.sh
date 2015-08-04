#!/bin/bash
#
# Copyright (c) 2014 Igor Pecovnik, igor.pecovnik@gma**.com
#
# www.igorpecovnik.com / images + support
#
# Board definitions
#



#--------------------------------------------------------------------------------------------------------------------------------
# common for default allwinner kernel-source
#--------------------------------------------------------------------------------------------------------------------------------


#BOOTLOADER="git://github.com/RobertCNelson/u-boot"
BOOTLOADER="git://git.denx.de/u-boot.git"
BOOTSOURCE="u-boot"
LINUXKERNEL="https://github.com/dan-and/linux-sunxi"
LINUXSOURCE="linux-sunxi"
LINUXCONFIG="linux-sunxi"
CPUMIN="480000"
CPUMAX="1010000"
OFFSET="1" # MB (1 x 2048 = default)
BOOTSIZE="0" # Mb size of boot partition
DOCS=""
DOCSDIR=""
FIRMWARE="bin/ap6210.zip"
MISC1="https://github.com/linux-sunxi/sunxi-tools.git"		
MISC1_DIR="sunxi-tools"
MISC2=""	
MISC2_DIR=""						
MISC3="https://github.com/dz0ny/rt8192cu"	
MISC3_DIR="rt8192cu"
MISC5="https://github.com/hglm/a10disp/"
MISC5_DIR="sunxi-display-changer"

#--------------------------------------------------------------------------------------------------------------------------------
# common for default allwinner kernel-source 
#--------------------------------------------------------------------------------------------------------------------------------


if [[ $BRANCH == *next* ]];then
	# All next compilations are using mainline u-boot & kernel
	LINUXKERNEL="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
	LINUXSOURCE="linux-mainline"
	LINUXCONFIG="linux-sunxi-next"
	FIRMWARE=""
	if [[ $BOARD == "udoo" ]];then
	LINUXKERNEL="https://github.com/patrykk/linux-udoo"
	LINUXSOURCE="linux-udoo-next"
	LINUXCONFIG="linux-udoo-next"
	fi
fi

#--------------------------------------------------------------------------------------------------------------------------------
# choose configuration
#--------------------------------------------------------------------------------------------------------------------------------
case $BOARD in


cubieboard4)
#--------------------------------------------------------------------------------------------------------------------------------
# Cubieboards 3.4.x
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="0.0"
BOOTCONFIG="cubietruck"
MODULES=""
MODULES_NEXT=""
CPUMIN="1200000"
CPUMAX="1800000"
LINUXKERNEL="https://github.com/cubieboard/CC-A80-kernel-source"
LINUXSOURCE="linux-sunxi-a80"
LINUXCONFIG="linux-sunxi-a80.config"
FIRMWARE=""
DTBS=""
MISC1=""	
MISC1_DIR=""
;;
#--------------------------------------------------------------------------------------------------------------------------------


aw-som-a20)
#--------------------------------------------------------------------------------------------------------------------------------
# https://aw-som.com/
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.0"
BOOTCONFIG="Awsom_defconfig" 
MODULES="hci_uart gpio_sunxi bt_gpio wifi_gpio rfcomm hidp bonding spi_sun7i"
MODULES_NEXT=""
;;


cubieboard)
#--------------------------------------------------------------------------------------------------------------------------------
# Cubieboard
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="4.1"
BOOTCONFIG="Cubieboard_config" 
MODULES="hci_uart gpio_sunxi bt_gpio wifi_gpio rfcomm hidp sunxi-ir bonding spi_sun7i"
MODULES_NEXT=""
;;


cubieboard2)
#--------------------------------------------------------------------------------------------------------------------------------
# Cubieboard
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="4.1"
BOOTCONFIG="Cubieboard2_config" 
MODULES="hci_uart gpio_sunxi bt_gpio wifi_gpio rfcomm hidp sunxi-ir bonding spi_sun7i"
MODULES_NEXT=""
;;


cubietruck)
#--------------------------------------------------------------------------------------------------------------------------------
# Cubieboard
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="4.1"
BOOTCONFIG="Cubietruck_config" 
MODULES="hci_uart gpio_sunxi bt_gpio wifi_gpio rfcomm hidp sunxi-ir bonding spi_sun7i bcmdhd"
MODULES_NEXT="brcmfmac rfcomm hidp"
;;


lime-a10)
#--------------------------------------------------------------------------------------------------------------------------------
# Olimex Lime
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.0"
BOOTCONFIG="A10-OLinuXino-Lime_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
BOOTSIZE="64"
;;


lime)
#--------------------------------------------------------------------------------------------------------------------------------
# Olimex Lime
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.9"
BOOTCONFIG="A20-OLinuXino-Lime_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
;;


lime2)
#--------------------------------------------------------------------------------------------------------------------------------
# Olimex Lime 2
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.9"
BOOTCONFIG="A20-OLinuXino-Lime2_defconfig" 
MODULES="hci_uart gpio_sunxi rfcomm hidp bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
BOOTSIZE="64"
;;


micro)
#--------------------------------------------------------------------------------------------------------------------------------
# Olimex Lime mainline kernel	/ experimental
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.9"
BOOTCONFIG="A20-OLinuXino_MICRO_config"
MODULES="hci_uart gpio_sunxi rfcomm hidp bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
;;


pcduino3nano)
#--------------------------------------------------------------------------------------------------------------------------------
# pcduino3nano
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.0"
BOOTCONFIG="Linksprite_pcDuino3_Nano_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i"
MODULES_NEXT=""
;;


bananapi)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="3.2"
BOOTCONFIG="Bananapi_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT="brcmfmac"
;;


bananapipro)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="3.2"
BOOTCONFIG="Bananapro_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT="brcmfmac"
;;


lamobo-r1)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="3.2"
BOOTCONFIG="Lamobo_R1_defconfig"
#BOOTCONFIG="Bananapi_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q"
MODULES_NEXT="brcmfmac"
;;


orangepi)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.4"
BOOTCONFIG="Orangepi_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
;;


orangepiplus)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.2"
BOOTCONFIG="Orangepi_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q a20_tp"
MODULES_NEXT=""
OFFSET="20" # MB (1 x 2048 = default)
BOOTSIZE="16" # Mb size of boot partition
;;


hummingbird)
#--------------------------------------------------------------------------------------------------------------------------------
# Bananapi
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="0.0"
BOOTCONFIG="Hummingbird_A31_config"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i"
MODULES_NEXT=""
;;


cubox-i)
#--------------------------------------------------------------------------------------------------------------------------------
# cubox-i & hummingboard 3.14.xx
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="2.9"
BOOTLOADER="https://github.com/SolidRun/u-boot-imx6"
BOOTSOURCE="u-boot-cubox"
BOOTCONFIG="mx6_cubox-i_config"
CPUMIN="792000"
CPUMAX="996000"
MODULES="bonding"
MODULES_NEXT="bonding"
LINUXKERNEL="https://github.com/linux4kix/linux-linaro-stable-mx6"
LINUXCONFIG="linux-cubox"
LINUXSOURCE="linux-cubox"
if [[ $BRANCH == *next* ]];then
	LINUXKERNEL="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
	LINUXSOURCE="linux-mainline"
	LINUXCONFIG="linux-cubox-next"
fi
;;


udoo)
#--------------------------------------------------------------------------------------------------------------------------------
# Udoo quad
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.8"
BOOTCONFIG="udoo_quad_config"
CPUMIN="392000"
CPUMAX="996000"
MODULES="bonding"
MODULES_NEXT=""
#LINUXKERNEL="https://github.com/UDOOboard/linux_kernel"
#LINUXCONFIG="linux-udoo"
#LINUXSOURCE="linux-udoo"
;;


udoo-neo)
#--------------------------------------------------------------------------------------------------------------------------------
# Udoo quad
#--------------------------------------------------------------------------------------------------------------------------------
REVISION="1.1"
BOOTSIZE="16"
BOOTLOADER="https://github.com/UDOOboard/uboot-imx"
BOOTSOURCE="u-boot-neo"
#BOOTCONFIG="mx6sxsabresd_config"
BOOTCONFIG="udoo_neo_config"
CPUMIN="198000"
CPUMAX="996000"
MODULES="bonding"
MODULES_NEXT=""
LINUXKERNEL="https://github.com/UDOOboard/linux_kernel"
LINUXCONFIG="linux-udoo-neo"
LINUXSOURCE="linux-neo"
;;


*) echo "Board configuration not found"
exit
;;
esac


# Common part 2 
# It must be here
if [[ $BRANCH != *next* ]];then
MISC4="https://github.com/notro/fbtft"
MISC4_DIR="$LINUXSOURCE/drivers/video/fbtft"
fi
