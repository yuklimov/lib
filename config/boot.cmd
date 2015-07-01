setenv bootargs console=tty1 root=/dev/mmcblk0p2 rootwait rootfstype=ext4 sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_no_mali_mem_reserve sunxi_fb_mem_reserve=16 hdmi.audio=EDID:0 disp.screen0_output_mode=1920x1080p60 panic=10 consoleblank=0 enforcing=0 loglevel=1
#--------------------------------------------------------------------------------------------------------------------------------
# Boot loader script to boot with different boot methods for old and new kernel
#--------------------------------------------------------------------------------------------------------------------------------
if ext2load mmc 0 0x00000000 /.next
then
# sunxi mainline kernel
#--------------------------------------------------------------------------------------------------------------------------------
ext2load mmc 0 0x49000000 /dtb/${fdtfile} 
ext2load mmc 0 0x46000000 /zImage
env set fdt_high ffffffff
bootz 0x46000000 - 0x49000000
#--------------------------------------------------------------------------------------------------------------------------------
else
# sunxi android kernel
#--------------------------------------------------------------------------------------------------------------------------------
ext2load mmc 0 0x43000000 /script.bin
ext2load mmc 0 0x48000000 /zImage
bootz 0x48000000
#--------------------------------------------------------------------------------------------------------------------------------
fi