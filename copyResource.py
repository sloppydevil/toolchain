### purpose: copy built binary to CarPC solution;
### steps you need make:
### step 1, double click;
### step 2, drag source folder, e.g. ***IDS/Archive
### step 3, drag target folder, e.g. ***CarPC
### all steps are done! configuration are kept as "conf" in the same folder;
### when need to change source and target path, delete the "conf" and double click again!
### ========================================================================================
import sys, os, shutil, pickle, time

# parse sys argv
commands = sys.argv

options = commands[1:]
optNum = len(options)
print(optNum, " options received!")

# define paths for matlab && carPC && asimov;
sourcePathMatlab = r"D:\ZZ\IDS_Model_ES8\work\archive"
codeSourcePath = os.path.join(sourcePathMatlab,"code")
a2lSourcePath = os.path.join(sourcePathMatlab,"release")

targetPathCarPC = r"D:\05_file\Integration\CarPC_Code\CarPC"
targetPathAsimov = r"D:\05_file\VirtualBox\archive"

def updateManifest(codeSourcePath,codeTargetPath,a2lSourcePath,a2lTargetPath):
    # delete code;
    os.chdir(codeTargetPath)
    for item in os.listdir("."):
        os.remove(item)
    print("="*16,"remove code-done","="*16)
    time.sleep(0.5)
    
    #copy code;
    os.chdir(codeSourcePath)
    for item in os.listdir("."):
            if not os.path.isdir(item):
                shutil.copy(item, codeTargetPath)
    print("="*16,"copy code-done","="*16)
    time.sleep(0.5)

    # delete a2l;
    os.chdir(a2lTargetPath)
    oldA2L = "ids_mil.a2l"
    if os.path.exists(oldA2L):
        os.remove(oldA2L)
    print("="*16,"remove a2l-done","="*16)
    time.sleep(0.5)
    
    # copy a2l;
    os.chdir(a2lSourcePath)
    for item in os.listdir("."):
            if not os.path.isdir(item):
                    shutil.copy(item, a2lTargetPath)
    print("="*16,"copy a2l-done","="*16)

if optNum == 1:
    if options[0] == "es8":
        print("try to update es8")
        codeTargetPath = os.path.join(targetPathCarPC,"qt_test","IDS")
        a2lTargetPath = os.path.join(targetPathCarPC,"x64","Debug")
        updateManifest(codeSourcePath,codeTargetPath,a2lSourcePath,a2lTargetPath)	
    elif options[0] == "adc":
        print("try to update adc")
        codeSourcePath = os.path.join(targetPathCarPC,"qt_test","IDS")
        codeTargetPath = os.path.join(targetPathAsimov,"code")
        a2lTargetPath = os.path.join(targetPathAsimov,"release")
        updateManifest(codeSourcePath,codeTargetPath,a2lSourcePath,a2lTargetPath)
    else:
        print("do nothing!")

def copyFromSourceToTarget(source, target):
        codeSourcePath = os.path.join(source,"code")
        codeTargetPath = os.path.join(target,"qt_test","IDS")
        a2lSourcePath = os.path.join(source,"release")
        a2lTargetPath = os.path.join(target,"x64","Debug")
			
        # delete code;
        os.chdir(codeTargetPath)
        for item in os.listdir("."):
            os.remove(item)
        print("="*16,"remove code-done","="*16)
        time.sleep(0.5)
        
        #copy code;
        os.chdir(codeSourcePath)
        for item in os.listdir("."):
                if not os.path.isdir(item):
                    shutil.copy(item, codeTargetPath)
        print("="*16,"copy code-done","="*16)
        time.sleep(0.5)

        # delete a2l;
        os.chdir(a2lTargetPath)
        oldA2L = "ids_mil.a2l"
        if os.path.exists(oldA2L):
            os.remove(oldA2L)
        print("="*16,"remove a2l-done","="*16)
        time.sleep(0.5)
        
        # copy a2l;
        os.chdir(a2lSourcePath)
        for item in os.listdir("."):
                if not os.path.isdir(item):
                        shutil.copy(item, a2lTargetPath)
        print("="*16,"copy a2l-done","="*16)
        time.sleep(0.5)
        
# configFileString = "conf"
# sourceFolderString = "source"
# targetFolderString = "target"

# source = None
# target = None

# configFile = os.path.join(os.path.abspath(os.curdir), configFileString)

# if os.path.exists(configFile):
    # data = open(configFile, "rb")
    # conf = pickle.load(data)
    # data.close()
    # if sourceFolderString in conf and targetFolderString in conf:
        # source = conf[sourceFolderString]
        # target = conf[targetFolderString]
    # copyFromSourceToTarget(source,target)
# else:
	# newSource = raw_input("Please enter source folder:")
	# print("=" * 32)
	# newTarget = raw_input("Please enter target folder:")
	# confDic = {}
	# confDic[sourceFolderString] = newSource
	# confDic[targetFolderString] = newTarget
	# data = open(configFile, "wb")
	# pickle.dump(confDic, data)
	# data.close()
	# copyFromSourceToTarget(newSource, newTarget)