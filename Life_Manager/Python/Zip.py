import os

def SecureFile() :
    allfile = os.listdir("../Safe_Chest/")

    for filename in allfile :
        content, size = ReadFileAndReturnContent(filename)
        listofbyte = SplitByte(content, size)
    
    return listofbyte
        

def ReadFileAndReturnContent(extractedFilePath):
    file = open("../Safe_Chest/" + extractedFilePath, mode="rb")
    content = file.read()
    file.close()
    file_stats = os.stat("../Safe_Chest/" + extractedFilePath)

    return content, file_stats.st_size

def SplitByte(tosplit, size):
    result = list[bytes]
    n = len(tosplit) / ( size / 2000 )

    for i in range (size/2000) :
        min = i * n
        max = (i + 1) * n
        result = result.append(tosplit[min:max]) 
    
    return result

print(SecureFile())