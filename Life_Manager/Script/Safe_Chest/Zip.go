package LifeManager

import (
	LifeManager "LifeManager/Script"
	"crypto/md5"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"io"
	"io/ioutil"
	"os"

	"github.com/kdungs/zip"
)

func SecureFile() {
	files := GetAllFileName()
	for _, file := range files {
		dataoffile, err := ReadFileAndReturnByteArray(file)
		if err != nil {
			panic(err)
		}
		RSA := LifeManager.GetRSA()
		pubkey, _ := LifeManager.ParseRsaPublicKeyFromPemStr(RSA.Pubkey)
		datasplit := SpliArrayinThree(dataoffile)
		hasher := md5.New()
		hasher.Write([]byte(file))
		filenamecrypt := hex.EncodeToString(hasher.Sum(nil))
		AddFileNameToDB(file)
		index := 0
		for _, data := range datasplit {
			datacrypt := Chiffrement(data, pubkey)
			WriteInFile(datacrypt, filenamecrypt[index*len(filenamecrypt)/6:(index+1)*len(filenamecrypt)/6])
			index++
		}	
		RemouveFile(file)
	}
}

func ReadFileAndReturnByteArray(extractedFilePath string) ([]byte, error) {
	file, err := os.Open("./Safe_Chest/" + extractedFilePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	return io.ReadAll(file)
}

func Chiffrement(Filedata []byte, PubKey *rsa.PublicKey) []byte {
	Filechiffre, _ := rsa.EncryptOAEP(sha256.New(), rand.Reader, PubKey, Filedata, []byte{})
	return Filechiffre
}

func SpliArrayinThree(array []byte) [][]byte {
	var result [][]byte
	n := len(array) / 6

	for i := 0; i < 6; i++ {
		min := i * n
		max := (i + 1) * n
		result = append(result, array[min:max])
	}
	return result
}

func WriteInFile(data []byte, filename string) {
	f, err := os.Create("./Safe_Chest/" + filename)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	_, err2 := f.Write(data)
	if err2 != nil {
		panic(err2)
	}
}

func AddFileNameToDB(filename string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO secure_chest (Filename) VALUES (?)", filename)
	if err != nil {
		panic(err)
	}
}

func RemouveFile(filename string) {
	e := os.Remove("./Safe_Chest/"+filename) 
    if e != nil { 
        panic(e) 
    } 
}





func Zip() {
	println("creating zip archive...")
	archive, err := os.Create("safechest.zip")
	if err != nil {
		panic(err)
	}
	defer archive.Close()
	zipWriter := zip.NewWriter(archive)

	filenames := GetAllFileName()
	for _, filename := range filenames {
		file := OpeningFile(filename)
		WriteFileToArchive(zipWriter, filename, file)
	}

	println("closing zip archive...")
	zipWriter.Close()
}

func GetAllFileName() []string {
	files, err := ioutil.ReadDir("./Safe_Chest")
	filename := []string{}
	if err != nil {
		println("Error:", err)
		return nil
	}
	for _, file := range files {
		filename = append(filename, file.Name())
	}
	return filename
}

func OpeningFile(filename string) *os.File {
	println("opening file")
	f2, err := os.Open("./Safe_Chest/" + filename)
	if err != nil {
		panic(err)
	}
	return f2
}

func WriteFileToArchive(zipfile *zip.Writer, filename string, file *os.File) {
	println("writing file to archive...")
	write, err := zipfile.Encrypt(filename, "golang", zip.AES256Encryption)
	if err != nil {
		panic(err)
	}
	if _, err := io.Copy(write, file); err != nil {
		panic(err)
	}
}
