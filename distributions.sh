#!/bin/bash
#
# Copyright (c) 2015 Igor Pecovnik, igor.pecovnik@gma**.com
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of tool chain https://github.com/igorpecovnik/lib
#


install_system_specific (){
#--------------------------------------------------------------------------------------------------------------------------------
# Install board common applications
#--------------------------------------------------------------------------------------------------------------------------------
echo -e "[\e[0;32m ok \x1B[0m] Fixing release custom applications"
case $RELEASE in

wheezy)
		# specifics packets
		LC_ALL=C LANGUAGE=C LANG=C chroot $DEST/output/sdcard /bin/bash -c "apt-get -y -qq install libnl-dev >/dev/null 2>&1"
		# add serial console
		echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> $DEST/output/sdcard/etc/inittab
		# don't clear screen on boot console
		sed -e 's/1:2345:respawn:\/sbin\/getty 38400 tty1/1:2345:respawn:\/sbin\/getty --noclear 38400 tty1/g' -i $DEST/output/sdcard/etc/inittab
		# disable some getties
		sed -e 's/3:23:respawn/#3:23:respawn/g' -i $DEST/output/sdcard/etc/inittab
		sed -e 's/4:23:respawn/#4:23:respawn/g' -i $DEST/output/sdcard/etc/inittab
		sed -e 's/5:23:respawn/#5:23:respawn/g' -i $DEST/output/sdcard/etc/inittab
		sed -e 's/6:23:respawn/#6:23:respawn/g' -i $DEST/output/sdcard/etc/inittab
		# auto upgrading
		sed -e "s/ORIGIN/Debian/g" -i $DEST/output/sdcard/etc/apt/apt.conf.d/50unattended-upgrades
		# install ramlog
		cp $SRC/lib/bin/ramlog_2.0.0_all.deb $DEST/output/sdcard/tmp
		chroot $DEST/output/sdcard /bin/bash -c "dpkg -i /tmp/ramlog_2.0.0_all.deb >/dev/null 2>&1" 
		# enabled back at first run. To remove errors
		chroot $DEST/output/sdcard /bin/bash -c "service ramlog disable >/dev/null 2>&1"
		rm $DEST/output/sdcard/tmp/ramlog_2.0.0_all.deb
		sed -e 's/TMPFS_RAMFS_SIZE=/TMPFS_RAMFS_SIZE=512m/g' -i $DEST/output/sdcard/etc/default/ramlog
		sed -e 's/# Required-Start:    $remote_fs $time/# Required-Start:    $remote_fs $time ramlog/g' -i $DEST/output/sdcard/etc/init.d/rsyslog 
		sed -e 's/# Required-Stop:     umountnfs $time/# Required-Stop:     umountnfs $time ramlog/g' -i $DEST/output/sdcard/etc/init.d/rsyslog  
		;;

jessie)
		# add serial console
		cp $SRC/lib/config/ttyS0.conf $DEST/output/sdcard/etc/init/ttyS0.conf
		cp $DEST/output/sdcard/lib/systemd/system/serial-getty@.service $DEST/output/sdcard/etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
		sed -e s/"--keep-baud 115200,38400,9600"/"-L 115200"/g  -i $DEST/output/sdcard/etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
		# specifics packets add and remove
		LC_ALL=C LANGUAGE=C LANG=C chroot $DEST/output/sdcard /bin/bash -c "apt-get -y -qq install thin-provisioning-tools libnl-3-dev libnl-genl-3-dev software-properties-common python-software-properties >/dev/null 2>&1"
		LC_ALL=C LANGUAGE=C LANG=C chroot $DEST/output/sdcard /bin/bash -c "apt-get autoremove >/dev/null 2>&1"
		# don't clear screen tty1
		sed -e s,"TTYVTDisallocate=yes","TTYVTDisallocate=no",g 	-i $DEST/output/sdcard/lib/systemd/system/getty@.service
		# enable root login for latest ssh on jessie
		sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' $DEST/output/sdcard/etc/ssh/sshd_config 
		# auto upgrading
		sed -e "s/ORIGIN/Debian/g" -i $DEST/output/sdcard/etc/apt/apt.conf.d/50unattended-upgrades
		;;

trusty)
		# add serial console
		cp $SRC/lib/config/ttyS0.conf $DEST/output/sdcard/etc/init/ttyS0.conf
		#cp $DEST/output/sdcard/lib/systemd/system/serial-getty@.service $DEST/output/sdcard/etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
		#sed -e s/"--keep-baud 115200,38400,9600"/"-L 115200"/g  -i $DEST/output/sdcard/etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
		# specifics packets add and remove
		LC_ALL=C LANGUAGE=C LANG=C chroot $DEST/output/sdcard /bin/bash -c "apt-get -y -qq install libnl-3-dev libnl-genl-3-dev software-properties-common python-software-properties >/dev/null 2>&1"
		LC_ALL=C LANGUAGE=C LANG=C chroot $DEST/output/sdcard /bin/bash -c "apt-get autoremove >/dev/null 2>&1"
		# don't clear screen tty1
		sed -e s,"exec /sbin/getty","exec /sbin/getty --noclear",g 	-i $DEST/output/sdcard/etc/init/tty1.conf
		# disable some getties
		chroot $DEST/output/sdcard /bin/bash -c "rm /etc/init/tty3.conf"
		chroot $DEST/output/sdcard /bin/bash -c "rm /etc/init/tty4.conf"
		chroot $DEST/output/sdcard /bin/bash -c "rm /etc/init/tty5.conf"
		chroot $DEST/output/sdcard /bin/bash -c "rm /etc/init/tty6.conf"
		# enable root login for latest ssh on trusty
		sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' $DEST/output/sdcard/etc/ssh/sshd_config 		
		# fix selinux error 
		chroot $DEST/output/sdcard /bin/bash -c "mkdir /selinux"
		# that my custom motd works well
		if [ -d "$DEST/output/sdcard/etc/update-motd.d" ]; then
			chroot $DEST/output/sdcard /bin/bash -c "mv /etc/update-motd.d /etc/update-motd.d-backup"
		fi
		# auto upgrading
		sed -e "s/ORIGIN/Ubuntu/g" -i $DEST/output/sdcard/etc/apt/apt.conf.d/50unattended-upgrades
		# remove what's anyway not working 
		rm $DEST/output/sdcard/etc/init/ureadahead*
		rm $DEST/output/sdcard/etc/init/plymouth*
		;;

*) echo "Relese hasn't been choosen"
exit
;;
esac

# change time zone data
echo $TZDATA > $DEST/output/sdcard/etc/timezone
chroot $DEST/output/sdcard /bin/bash -c "dpkg-reconfigure -f noninteractive tzdata >/dev/null 2>&1"

# set root password and force password change upon first login
chroot $DEST/output/sdcard /bin/bash -c "(echo $ROOTPWD;echo $ROOTPWD;) | passwd root >/dev/null 2>&1"  
chroot $DEST/output/sdcard /bin/bash -c "chage -d 0 root" 

# add noatime to root FS
echo "/dev/mmcblk0p2  /           f2fs    defaults,noatime,nodiratime                          0       0" >> $DEST/output/sdcard/etc/fstab
echo "/dev/mmcblk0p1  /boot       ext2    defaults,noatime,nodiratime,errors=remount-ro        0       0" >> $DEST/output/sdcard/etc/fstab

# flash media tunning
if [ -f "$DEST/output/sdcard/etc/default/tmpfs" ]; then
	sed -e 's/#RAMTMP=no/RAMTMP=yes/g' -i $DEST/output/sdcard/etc/default/tmpfs
	sed -e 's/#RUN_SIZE=10%/RUN_SIZE=128M/g' -i $DEST/output/sdcard/etc/default/tmpfs 
	sed -e 's/#LOCK_SIZE=/LOCK_SIZE=/g' -i $DEST/output/sdcard/etc/default/tmpfs 
	sed -e 's/#SHM_SIZE=/SHM_SIZE=128M/g' -i $DEST/output/sdcard/etc/default/tmpfs 
	sed -e 's/#TMP_SIZE=/TMP_SIZE=1G/g' -i $DEST/output/sdcard/etc/default/tmpfs
fi

# create .deb package for the rest
#
CHOOSEN_ROOTFS=linux-"$RELEASE"-root-"$BOARD"_"$REVISION"_armhf
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN
cat <<END > $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN/control
Package: linux-$RELEASE-root-$BOARD
Version: $REVISION
Architecture: all
Maintainer: $MAINTAINER <$MAINTAINERMAIL>
Installed-Size: 1
Section: kernel
Priority: optional
Description: Various root file system tweaks for ARM boards
END
#
# set up post install script
echo "#!/bin/bash" > $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN/postinst
chmod 755 $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN/postinst

# scripts for autoresize at first boot
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/init.d
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/default
install -m 755 $SRC/lib/scripts/resize2fs $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/init.d
install -m 755 $SRC/lib/scripts/firstrun  $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/init.d

# install custom bashrc and hardware dependent motd
cat <<END >> $DEST/output/sdcard/etc/bash.bashrc
if [ -f /etc/bash.bashrc.custom ]; then
    . /etc/bash.bashrc.custom
fi
END
install $SRC/lib/scripts/bashrc $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/bash.bashrc.custom
install -m 755 $SRC/lib/scripts/armhwinfo $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/init.d 
echo "update-rc.d armhwinfo defaults >/dev/null 2>&1" >> $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN/postinst
echo "update-rc.d -f motd remove >/dev/null 2>&1" >> $DEST/output/rootfs/$CHOOSEN_ROOTFS/DEBIAN/postinst

# temper binary for USB temp meter
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/usr/local/bin
tar xfz $SRC/lib/bin/temper.tgz -C $DEST/output/rootfs/$CHOOSEN_ROOTFS/usr/local/bin

# replace hostapd from latest self compiled & patched
chroot $DEST/output/sdcard /bin/bash -c "apt-get -y -qq remove hostapd >/dev/null 2>&1"
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/usr/sbin/
tar xfz $SRC/lib/bin/hostapd25-rt.tgz -C $DEST/output/rootfs/$CHOOSEN_ROOTFS/usr/sbin/
install -m 755 $SRC/lib/config/hostapd.realtek.conf $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/hostapd.conf-rt

tar xfz $SRC/lib/bin/hostapd25.tgz -C $DEST/output/rootfs/$CHOOSEN_ROOTFS/usr/sbin/
install -m 755 $SRC/lib/config/hostapd.conf $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/hostapd.conf 

# alter hostap configuration
sed -i "s/BOARD/$BOARD/" $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/hostapd.conf
sed -i "s/BOARD/$BOARD/" $DEST/output/rootfs/$CHOOSEN_ROOTFS/etc/hostapd.conf-rt

# script to install to SATA
mkdir -p $DEST/output/rootfs/$CHOOSEN_ROOTFS/root
install -m 755 $SRC/lib/scripts/nand-sata-install $DEST/output/rootfs/$CHOOSEN_ROOTFS/root/nand-sata-install
}