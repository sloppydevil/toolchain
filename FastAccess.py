#!python
import os, sys, time

# 1, path fast access
paths = [
r"D:\ZZ\IDS_Model_ES8\FCT\LON\ACC",
r"D:\05_file\Integration\CarPC_Code\CarPC",
r"D:\05_file\Integration\DBC",
r"D:\05_file\VirtualBox",
r"D:\05_file\Projects\ES8",
r"D:\ETASData\INCA7.2\Measure",
]

def fastAccess():
    print("="*16,"fast access","="*16)
    for index,path in enumerate(paths):
        print(index,path)
    print("-"*32)
    targetIndexString = input("insert target path index:")
    
    if targetIndexString == "" or targetIndexString == None:
        print("Default path will be accessed!")
        targetIndex = 0
    else:
        targetIndex = int(targetIndexString)
        if targetIndex >= 0 and targetIndex < len(paths):
            print("%d will be accessed!" % targetIndex)
        else:
            print("No path will be accessed!")
            targetIndex = 0
    targetPath = paths[targetIndex]
    os.system("start " + targetPath)
