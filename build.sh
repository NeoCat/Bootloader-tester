#!/bin/sh
OUTPUT_DISK_IMG=output.img

gcc -m32 -c src.s || exit 1
if [ `uname` = Linux ]; then
	TEXT=`readelf -S src.o | grep -A1 .text`
	len=`echo $TEXT | awk '{print strtonum("0x" $7)}'`
	off=`echo $TEXT | awk '{print strtonum("0x" $6)}'`
elif [ `uname` = Darwin ]; then
	TEXT=`otool -l src.o | grep __TEXT -A3 | tail -2 | awk '{print strtonum($2)}'`
	len=`echo $TEXT | awk '{print $1}'`
	off=`echo $TEXT | awk '{print $2}'`
else
	echo unknown environment
	exit 2
fi

echo offset: $off
echo length: $len

dd conv=notrunc if=src.o of=$OUTPUT_DISK_IMG bs=1 count=$len skip=$off
dd conv=notrunc if=/dev/zero of=$OUTPUT_DISK_IMG bs=1 count=$((510-$len)) seek=$len
printf '\x55\xaa' > sign
dd conv=notrunc if=sign of=$OUTPUT_DISK_IMG bs=1 count=2 seek=510
rm -f sign
