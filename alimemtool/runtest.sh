#!/bin/bash 

testmem=$1;
testloop=$2;

dir=`pwd`;
dir_memreg="$dir/alimemreg";
dir_memtester="$dir/alimemtester";

#build/insmod reg mod 
cd $dir_memreg;
##make clean;
##make;
rmmod alimemreg;
insmod alimemreg.ko wanna_mem=$testmem;
gotmem=`cat /sys/module/alimemreg/parameters/got_mem`;

if [ "$gotmem" -ne "$testmem" ];then
    echo "request $testmem G , only get $gotmem G,exit!";
    rmmod alimemreg;
    exit -1;
fi

gotmem="$gotmem""G";

echo $gotmem
#mk cdev
dev_num=`cat /proc/devices |grep -i alimemreg |cut -d " " -f 1`;
rm -rf /dev/alimemtest;
mknod /dev/alimemtest c $dev_num 0;

#build/run memtester
cd $dir_memtester
#make clean;
#make;
export MEMTESTER_TEST_MASK=0x1FE1FFFF;
./memtester -p 0 -d /dev/alimemtest $gotmem $testloop

if [ $? -ne 0 ];then 
   echo "Run Alimem Test Failed!";
   rmmod alimemreg;
   exit -1;
else
   echo "Run Alimem Test Successed!";
   rmmod alimemreg;
   exit 0;
fi
