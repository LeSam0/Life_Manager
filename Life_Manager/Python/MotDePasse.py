import random
import os
import hashlib

chiffre = "0123456789"
majuscule = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
minuscule = "abcdefghijklmnopqrstuvwxyz"
caractèrespé = ['!', '"', '#', '$', '%', '&', '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '=', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~', "'"]

def GenerateMdp():
    mdp = []
    for _ in range(1,23):
        rdmnumber = random.randint(0,3)	
        if rdmnumber == 1 :
            rdmc = random.choice(chiffre)
            mdp.append(rdmc) 
        elif rdmnumber == 2 :
            rdmM = random.choice(majuscule)
            mdp.append(rdmM)
        elif rdmnumber == 3 :
            rdmm = random.choice(minuscule)
            mdp.append(rdmm)
        elif rdmnumber == 0 :
            rdmc = random.choice(caractèrespé)
            mdp.append(rdmc)
    return mdp


def Checkifmdpok(mdp):
    checkchif = False
    checkmaj = False
    checkmin = False
    checkcarspé = False
    for i in range(1,len(mdp)):
        if mdp[i] in chiffre: 
            checkchif = True
        if mdp[i] in majuscule :
            checkmaj = True
        if mdp[i] in minuscule:
            checkmin = True
        if mdp[i] in caractèrespé:
            checkcarspé = True

    if checkchif & checkcarspé & checkmaj & checkmin :
        return "".join(mdp)
    else :
        if not checkcarspé:
            rdmc = random.choice(caractèrespé)
            rdmp = random.randint(0,15)
            mdp[rdmp] = rdmc
        elif not checkmin:
            rdmm = random.choice(minuscule)
            rdmp = random.randint(0,15)
            mdp[rdmp] = rdmm
        elif not checkmaj :
            rdmM = random.choice(majuscule)
            rdmp = random.randint(0,15)
            mdp[rdmp] = rdmM
        elif not checkchif :
            rdmch = random.choice(chiffre)
            rdmp = random.randint(0,15)
            mdp[rdmp] = rdmch
        return "".join(mdp)
   


def Checkifdouble(mdp) :
    test = False
    read = True
    if os.path.exists('liste_mdp.txt') :
        f = open("liste_mdp.txt", "r")
        af = open("liste_mdp.txt", "a")
        word = f.read().splitlines()
        if hash(mdp) in word :
                read = False
        if read :
            af.write("\n")
            af.write(Hashmdp(mdp))
            test = True
        af.close()
        f.close()
    else :
        op = open("liste_mdp.txt", "w")
        op.write("LISTE HASH")
        op.close()
        return Checkifdouble(mdp)
    return test   

def Hashmdp(mdp) :
    mdp = hashlib.sha3_384(mdp.encode('utf-8')).hexdigest()
    return mdp

def Newmdp():
    PremierMDP = GenerateMdp()
    if not Checkifdouble(Checkifmdpok(PremierMDP)) :
        Newmdp()
    return "".join(PremierMDP)

print(Newmdp())