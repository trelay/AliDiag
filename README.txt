
脚本功能:
----------

    用于MOC STRESS测试，底层测试实现基于第三方开源软件，有FIO,MEMTEST,IPERF....,本脚本只是用于调第三方软件，并判断测试结果，显示给到用户。

运行：
----------

    python moctest.pyc					默认模式，所有将会测试
	python moctest.pyc -t MEMORY			可选择模式，当前只测试MEMORY
    python moctest.pyc -t MEMORY,SSD ... 多选择模式，每种类型需用","分开。
	
文件结构：
----------
	- 软件目录
	
	    /home/MocDiagTool/
	  
    - mocdiagtool.pyc
	
		主测试脚本，用于测试，判断。
		
	- config.pyc
		
		用于配置测试脚本参数。
	
	- log
	
	    用于存放测试日志，以SN前缀区分。分为SN-log 和 SN-log.raw
	
运行环境与工具：
	
	- 系统 ：
	
		Linux centos 7.3
	
	- 软件工具：
	
		python3
		python3: pexpect

==========================================================================================================================
配置文件信息：

workdir = "/home/MocDiagTool/"

isc_ipmitool = "/home/tool/isc_ipmitool"
ipmitool = "/home/tool/ipmitool"

CPUSTRESS = { "toolpath"      : "/home/tool" ,
              "toolname"      : "stress --cpu 80 --io 4 --vm 2 --vm-bytes 128M --timeout 120s" ,
              "Expectoutput"  : "successful run completed" ,
              "ExpectCpuload" : 66   }


I2CTEST = {   "toolpath"      : "/home/tool/moc_fpga_test_0.5/" ,
              "toolname"      : "./i2c-check.sh" ,
              "Expectoutput"  : "i2c FPGA register write/read test success"}


PCIETEST = {  "toolpath"      : "/home/tool/moc_fpga_25g_test_1.1/" ,
              "toolname"      : "./fpga_pcie_test.sh" ,
              "Expectoutput"  : "PCIE test Passed"}

MEMTEST = {   "toolpath"      : "/home/tool/alimemtester/" ,
              "toolname"      : "/home/tool/alimemtool/runtest.sh",
              "size"          : "1",
              "loop"          : "1",
              "Expectoutput"  : "Run Alimem Test Successed!"
       }


SSDFIOTEST = {  "DeviceFlag"    : "LITEON" , 
                "toolpath"      : "/home/tool/fio-2.6/fio" ,
                "rw"            : "randrw" ,
                "bs"            : "16k" ,
                "size"          : "10G" ,
                "runtime"       : "10" ,
                "limitread"     : 8000 ,
                "limitwrite"    : 4000 }  

USBFIOTEST = {  "DeviceFlag"    : "SanDisk" ,
                "toolpath"      : "/home/tool/fio-2.6/fio" ,
                "rw"            : "randread" ,
                "bs"            : "16k" ,
                "size"          : "10G" ,
                "runtime"       : "10" ,
                "limitread"     : 800 ,
                "limitwrite"    : 800 }

PTUTEST    = { "toolpath"       : "/home/tool/PTU",
               "uServerPtuGen"  : "/home/tool/PTU/uServerPtuGen -T" ,
               "DenvertonPwrMon": "/home/tool/PTU/DenvertonPwrMon" ,
               "Expect"         : 16
              }   


DPDKTEST   = { "toolpath"       : "/home/tool/dpdk-stable-16.11.3" ,
               "sfptestid1"     : "0000:04:00.0",
               "sfptestid2"     : "0000:04:00.1"
             }


HWINFO     = { "CPU"            : { "cmd":"dmidecode -t processor",
                                     "chkQty":2,
                                     "chkItems": { 
                                              "speed": { "arg":"Current Speed","expvalue":"2000 MHz"},
                                              "Version": {"arg":"Version","expvalue":"Intel(R) Atom(TM) CPU C3958 @ 2.00GHz"},
                                      },
                                  },
               "MEMORY"         : { "cmd":"dmidecode -t memory",
                                     "chkQty":5,
                                     "chkItems":{"Capacity": { "arg":"Maximum Capacity","expvalue":"128 GB"},
                                              "Size": { "arg":"Size","expvalue":"16384 MB"},
                                              "Vendor":{"arg":"Manufacturer","expvalue":"Samsung"},
                                     },
                                  },
               "SSD"          : { "cmd":"lsscsi -g | grep ATA | cut -d ' ' -f2- | cut -c 21-36",
                                  "chkQty":1,
                                  "chkItems": { "Type":"LITEON EGT-240N9"}, 
                                 }, 

               "BIOS"         : { "cmd":"dmidecode -t bios",
                                     "chkQty":3,
                                     "chkItems":{"Vendor": { "arg":"Vendor","expvalue":"INSYDE Corp."},
                                              "Version": { "arg":"Version","expvalue":"1.00.20"},
                                              "Release Date":{"arg":"Release Date","expvalue":"08/01/2018"},
                                     },
                                  },
               "CPLD1"       : { "cmd" : "/home/tool/ipmitool -I heci raw 6 0x52 1 0xc0 1 0x0",
                                 "chkQty":1,
                                  "chkItems":{ "expvalue":"97"},
                              },
               "CPLD2"       : { "cmd" : "/home/tool/ipmitool -I heci raw 6 0x52 1 0xc0 1 0x1",
                                 "chkQty":1,
                                  "chkItems":{ "expvalue":"25"},
                              },

              "NETPortSpeed"     : { "cmd":"ethtool enp6s0",
                                   "chkQty":1,
                                    "chkItems":{ "Speed" : {"arg":"Speed","expvalue":"1000Mb/s"},
								     },
                                   },
              "NETPortFW"        :  { "cmd":"ethtool -i enp6s0",
                                   "chkQty":1,
                                    "chkItems": {"FirmWare" : {"arg":"firmware-version","expvalue":"0x80000844"},
                                    },
                                  },
              "MC_INFO"          : { "cmd":"/home/tool/isc_ipmitool -I heci mc info",
                                   "chkQty":2,
                                   "chkItems": {"Device Revision" : {"arg":"Device Revision","expvalue":"1"},
												"Firmware Revision" : {"arg":"Firmware Revision","expvalue":"1.20"},
                                    },						
                                  },
              "SPSImgFw" : { "cmd":"/home/tool/spsInfoLinux64",
                             "chkQty":1,
                             "chkItems": {"SPS Image FW" : {"arg":"SPS Image FW version","expvalue":"4.0.4.139 (Recovery), 4.0.4.139 (Operational)"},}

                    }

            }

POWER_CABLE_DETECT = {
         "25GPowerCable"   : { "cmd" : "/home/tool/ipmitool -I heci raw 0x06 0x52 0x01 0xc0 0x01 0x1c",
                              "chkQty":1,
                              "chkItems":{ "expvalue":"00"},
                        },
          }

DUMPSEL = { "toolpath"       : "/home/tool/ipmitool",
			"cmd"		: " sel list"
	    }

VPDINFO = { "toolpath"       : "/home/tool/ipmitool",
			"cmdarg"		: { "fru0":"fru print 0",
                                "fru1":"fru print 1",
                              }
	    }

MFGDATE = { "chkQty":2,
            "boards":{ "CPU":{ "cmd":"/home/tool/ipmitool fru print 0", 
                            "arg":"Board Mfg Date",
                     },
                    "FPGA": { "cmd":"/home/tool/ipmitool fru print 1",
                           "arg":"Board Mfg Date",
                     },
              }  
       }



MACINFO = { "chkQty":4, 
           "onboardport":{"ports":["enp3s0f0","enp3s0f1", "enp6s0"],
                            "cmdarg": "ether",
                           },
           "IEport": { "cmd":"/home/tool/ipmitool -I heci lan print 1",
                       "cmdarg": "'MAC Address'",
					}, 
        }

FPGA_IMAGE_DUMP = { "chkQty":6,
                    "toolpath": "/home/tool/ipmitool",
                     "ipmiPreRead" : { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x0A",
                                       "expvalue" : "3f",
                                 },
                     "i2cGet"  :  {"Add_11": { "cmdarg" : "0x60 0x11","expvalue":"0x04"},
                                   "Add_12": { "cmdarg" : "0x60 0x12","expvalue":"0x10"},
                                   "Add_13": { "cmdarg" : "0x60 0x13","expvalue":"0x20"},
                                   "Add_14": { "cmdarg" : "0x60 0x14","expvalue":"0x03"},
								},
                     "ipmiRead" : { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x08",
                                       "expvalue" : "02",
                                 },
        }

TEMP_DUMP = { "chkQty":4,
              "toolpath": "/home/tool/ipmitool",
              "Devices" : { "CPU temp":  { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x0d",
                                         "expvalue" : "^[a-f]$|^[1-4][0-9a-f]$|^5[0-9a-c]$",
                                         "range"  : "10 - 92 C",
                                        },
                          "MEM0 temp":  { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x19",
                                         "expvalue" : "^[a-f]$|^[1-4][0-9a-f]$|^50$",
                                         "range"  : "10 - 80 C",  
                                        },
                           "MEM1 temp":  { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x18",
                                          "expvalue" : "^[a-f]$|^[1-4][0-9a-f]$|^50$",
                                           "range"  : "10 - 80 C",  
                                       },
                           "FGPA temp":  { "cmdarg": "-I heci raw 0x06 0x52 0x01 0xc0 0x01 0x0e",
                                          "expvalue" : "^[a-f]$|^[1-4][0-9a-f]$|^5[0-9]$",
                                          "range"  : "10 - 85 C",  
                                      },
                      },
           }




IPERF_TEST = { "chkQty":4,
               "toolpath": "/home/tool/ipmitool",
               "ethPorts": { "eth1":"enp3s0f0", "eth2" :"enp3s0f1"},
               "speed": { "arg":"\[SUM\].*?GBytes\s+(.*?)\s+Gbits\/sec",
                         "limit":"21",
                         "expqty": 7,
                      }  
      }


DMESG_BLACK_LIST = ["Media error","I/O error","FPDMA","Emask","task abort","correctable error",
                   "Ata error","Unrecovered read error","Temperature above threshold","transmit timed out",
                   "out of memory","\[8086\:19a4\]"
             ]

SEL_INFO_LIST = ["Timestamp Clock Sync","Log area reset/cleared","Power off/down","Initiated by warm reset",
                "Initiated by power up","Microcontroller/Coprocessor","Watchdog 2 #0x03"
              ]


PCIINFO= { "pciQty":"23",
          "cmd":"lspci -vv", 
          "devices": { "00:00.0": { "info":"Host bridge: Intel Corporation Device 1980 \(rev 11\)",},
                     "00:04.0": { "info":"Host bridge: Intel Corporation Device 19a1 \(rev 11\)",},
                     "00:05.0": {"info":"Generic system peripheral \[0807\]\: Intel Corporation Device 19a2 \(rev 11\)"},
                     "00:06.0": {"info":"PCI bridge: Intel Corporation Device 19a3 \(rev 11\) \(prog-if 00 \[Normal decode\]\)",
                                "LnkCap":"Port \#17, Speed 2.5GT/s, Width x1",
                                "LnkSta":"Speed 2.5GT/s, Width x1, TrErr",
                                },
                     "00:09.0": { "info":"PCI bridge: Intel Corporation Device 19a4 \(rev 11\) \(prog-if 00 \[Normal decode\]\)",
                                "LnkCap":"Port \#9, Speed 8GT/s, Width x8",
                                "LnkSta":"Speed 8GT/s, Width x8, TrErr",
                                }, 
                     "00:0e.0": { "info":"PCI bridge: Intel Corporation Device 19a8 \(rev 11\) \(prog-if 00 \[Normal decode\]\)",
                                "LnkCap":"Port \#14, Speed 8GT/s, Width x8",
                                "LnkSta":"Speed 8GT/s, Width x8, TrErr",
                               },
                     "00:12.0":{"info":"System peripheral: Intel Corporation Device 19ac \(rev 11\)"},
                     "00:14.0":{"info":"SATA controller: Intel Corporation Device 19c2 \(rev 11\) \(prog-if 01 \[AHCI 1.0\]\)"},
                     "00:15.0":{"info":"USB controller: Intel Corporation Device 19d0 \(rev 11\) \(prog-if 30 \[XHCI\]\)"},
                     "00:16.0":{"info":"PCI bridge: Intel Corporation Device 19d1 \(rev 11\) \(prog-if 00 \[Normal decode\]\)",
                                "LnkCap":"Port \#17, Speed 2.5GT/s, Width x1",
                                "LnkSta":"Speed 2.5GT/s, Width x1, TrErr",
                               },
                     "00:18.0":{"info":"Communication controller: Intel Corporation Device 19d3 \(rev 11\)"},
                     "00:1a.0":{"info":"Serial controller: Intel Corporation Device 19d8 \(rev 11\) \(prog-if 02 \[16550\]\)"},
                     "00:1b.0":{"info":"Communication controller: Intel Corporation Device 19e5 \(rev 11\)"},
                     "00:1b.3":{"info":"Serial controller: Intel Corporation Device 19e8 \(rev 11\) \(prog-if 02 \[16550\]\)"},
                     "00:1f.0":{"info":"ISA bridge: Intel Corporation Device 19dc \(rev 11\)"},
                     "00:1f.1":{"info":"Memory controller: Intel Corporation Device 19dd \(rev ff\) \(prog-if ff\)"},
                     "00:1f.2":{"info":"Memory controller: Intel Corporation Device 19de \(rev 11\)"},
                     "00:1f.4":{"info":"SMBus: Intel Corporation DNV SMBus controller \(rev 11\)"},
                     "00:1f.5":{"info":"Serial bus controller \[0c80\]: Intel Corporation Device 19e0 \(rev 11\)"},
                     "01:00.0":{"info":"Co-processor: Intel Corporation Device 19e2 \(rev 11\)",
                                "LnkCap":"Port \#0, Speed 5GT/s, Width x16",
                                "LnkSta":"Speed 5GT/s, Width x16, TrErr",
                               },
                     "03:00.0":{"info":"Ethernet controller: Mellanox Technologies MT27710 Family \[ConnectX-4 Lx\]",
                                "LnkCap":"Port \#0, Speed 8GT/s, Width x8",
                                "LnkSta":"Speed 8GT/s, Width x8, TrErr-",
                               },
                     "03:00.1":{"info":"Ethernet controller: Mellanox Technologies MT27710 Family \[ConnectX-4 Lx\]",
                                "LnkCap":"Port \#0, Speed 8GT/s, Width x8",
                                "LnkSta":"Speed 8GT/s, Width x8, TrErr-",
                               },
                     "06:00.0":{"info":"Ethernet controller: Intel Corporation Device 15c2 \(rev 11\)",
                                "LnkCap":"Port \#0, Speed 2.5GT/s, Width x1",
                                "LnkSta":"Speed 2.5GT/s, Width x1, TrErr",
                               },

                  }

     }

==========================================================================================================================
LOG日志信息样本:

2018-11-26 17:29:25 |  INFO | - 
2018-11-26 17:29:25 |  INFO | - **********************************************************************
2018-11-26 17:29:25 |  INFO | - *                                                            *
2018-11-26 17:29:25 |  INFO | -  	******		AliMoc Self Test Tool     ******	
2018-11-26 17:29:25 |  INFO | - 
2018-11-26 17:29:25 |  INFO | - 	 	Version : R01
2018-11-26 17:29:25 |  INFO | - 	 	Author : tobyzhou@celestica.com
2018-11-26 17:29:25 |  INFO | - 	 	Contact : +86 15112531159
2018-11-26 17:29:25 |  INFO | - *                                                            *
2018-11-26 17:29:25 |  INFO | - **********************************************************************
2018-11-26 17:29:25 |  INFO | - 
2018-11-26 17:29:25 |  INFO | - Test Items : SDR_CHECK,LED
2018-11-26 17:29:25 |  INFO | - 
2018-11-26 17:29:25 |  INFO | - Run command -> '/home/tool/isc_ipmitool -I heci fru print 0'
2018-11-26 17:29:26 |  INFO | - Run command -> 'date'
2018-11-26 17:29:26 |  INFO | - 
2018-11-26 17:29:26 |  INFO | - Product PN : R1130-F0010-01
2018-11-26 17:29:26 |  INFO | - Product SN : F0010CLS118AL87E009
2018-11-26 17:29:26 |  INFO | - 
2018-11-26 17:29:26 |  INFO | - System RTC : Mon Nov 26 17:29:26 CST 2018
2018-11-26 17:29:26 |  INFO | - 
2018-11-26 17:29:26 |  INFO | - Run command -> 'killall mcelog'
2018-11-26 17:29:26 |  INFO | - Run command -> 'mcelog --daemon'
2018-11-26 17:29:26 |  INFO | - ======================================================================
2018-11-26 17:29:26 |  INFO | -  	******		START SDR CHECK TEST 	******	
2018-11-26 17:29:26 |  INFO | - ======================================================================
2018-11-26 17:29:26 |  INFO | - Run command -> '/home/tool/ipmitool sdr list'
2018-11-26 17:29:27 |  INFO | - CPU0 DIMM0 Temp  | 60 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - CPU0 DIMM1 Temp  | 64 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - CPU0 Temp        | 62 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - CPU0 Margin      | 32 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - FPGA Temp        | 78 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - MELX Temp        | 83 degrees C      | ok
2018-11-26 17:29:27 |  INFO | - IPMI Watchdog    | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - System Event Log | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - CPU0 CATERR      | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - CPU0 THERMTRIP   | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - CPU0 PROCHOT     | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - CPU0 MCERR       | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - IRQ DIMM EVENT   | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - Button           | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - Pwr Unit Status  | 0x00              | ok
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - Check Results ('ok' qty) :
2018-11-26 17:29:27 |  INFO | - 	Expect : 15
2018-11-26 17:29:27 |  INFO | - 	Get : 15
2018-11-26 17:29:27 |  INFO | - 	 --> OK
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - 	 ==> PASS
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - 	******************************
2018-11-26 17:29:27 |  INFO | - 	* Test Result : pass
2018-11-26 17:29:27 |  INFO | - 	******************************
2018-11-26 17:29:27 |  INFO | - ======================================================================
2018-11-26 17:29:27 |  INFO | -  	******		START LED Status TEST 	******	
2018-11-26 17:29:27 |  INFO | - ======================================================================
2018-11-26 17:29:27 |  INFO | - Run command -> '/home/tool/ipmitool raw 6 0x52 1 0xc0 1 0x09'
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - 	Expect : 0c
2018-11-26 17:29:27 |  INFO | - 	Get : 04
2018-11-26 17:29:27 | ERROR | - 	 --> NOK
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 | ERROR | - 	 ==> FAIL
2018-11-26 17:29:27 | ERROR | - 	 TEST FAIL
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - 	******************************
2018-11-26 17:29:27 |  INFO | - 	* Test Result : fail
2018-11-26 17:29:27 |  INFO | - 	******************************
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
2018-11-26 17:29:27 |  INFO | - <> Test Results Summary:
2018-11-26 17:29:27 |  INFO | - <>	Total Test Items : 2
2018-11-26 17:29:27 |  INFO | - <>	Test Failed  Items : 1
2018-11-26 17:29:27 |  INFO | - <>	----------------------------------------
2018-11-26 17:29:27 |  INFO | - <>	Failed Items List :
2018-11-26 17:29:27 |  INFO | - <>		LED fail
2018-11-26 17:29:27 |  INFO | - <>	----------------------------------------
2018-11-26 17:29:27 |  INFO | - <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
2018-11-26 17:29:27 |  INFO | - 
2018-11-26 17:29:27 |  INFO | - ==============================================================================
2018-11-26 17:29:27 |  INFO | - Total execution time: 0 days, 0 hours, 0 minutes, 1 seconds
2018-11-26 17:29:27 |  INFO | - ==============================================================================
