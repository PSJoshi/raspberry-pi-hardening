### Raspberry Pi Board ID
Every Raspberry Pi has a unique serial number. It is sometimes useful to extract this number to identify the hardware uniquely.
Actually, it refers to the serial number of (Broadcom) CPU but nobody is likely to remove the CPU from the PCB, it can be considered the serial of the whole device.

```
def getserial():
    # Extract serial from cpuinfo file
    cpuserial = "0000000000000000"
    try:
        f = open('/proc/cpuinfo','r')
        for line in f:
            if line[0:6]=='Serial':
                cpuserial = line[10:26]
        f.close()
    except:
        cpuserial = "ERROR000000000"
 
    return cpuserial
```
