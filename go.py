#!python
import os, sys, time, shutil
from FastAccess import *

# parse sys argv
commands = sys.argv

options = commands[1:]
optNum = len(options)

if optNum < 1:
    fastAccess()
elif optNum == 1:
    print("one param:", options[0])
    if options[0] == "es8":
        cmd = "python "+ os.path.join(os.getcwd(), "Javis","copyResource.py")
        cmd = cmd + " es8"
        os.system(cmd)
    elif options[0] == "adc":
        sourceZipFilePath = r"D:\ZZ\IDS_Model_ES8\work"
        targetZipFilePath = r"D:\05_file\VirtualBox"
        zipFileName = r"archive.zip"
        sourceZipFile = os.path.join(sourceZipFilePath, zipFileName)
        targetZipFile = os.path.join(targetZipFilePath, zipFileName)
        
        if os.path.exists(targetZipFile):
            os.remove(targetZipFile)
        shutil.copy(sourceZipFile, targetZipFilePath)
        os.system("start " + targetZipFilePath)
    elif options[0] == "test":
        cmd = "start /i D:\\05_file\\Integration\\CarPC_Code\\CarPC\\x64\\Debug\\Genesis.exe"
        os.system(cmd)
    elif options[0] == "dtc":
        cmd = "start /i D:\\02_tool\\UDS_tool\\XL_U_Server.exe"
        os.system(cmd)    
    elif options[0] == "exit":
        cmd1 = 'taskkill /f /im "Genesis.exe"'
        cmd2 = 'taskkill /f /im "XL_U_Server.exe"'
        os.system(cmd1)
        os.system(cmd2) 
    elif options[0] == "feiq":
        cmd = "start /i D:\\02_tool\\FeiQ.exe"  
        os.system(cmd)
elif optNum == 2:
    print("two params")
else:
    print("more params")

