package LifeManager

import (
	"database/sql"
	"strconv"
)

type RSA struct {
	Prikey string
	Pubkey string
}

type LoginForRSA struct {
	Id          int    `json:"Id,omitempty"`
	Nomapp      string `json:"NomApp,omitempty"`
	Identifiant string `json:"Identifiant,omitempty"`
	Mdp         string `json:"MotDePasse,omitempty"`
}

type Userfront struct {
	id       string `json:"Id,omitempty"`
	name     string `json:"Identifiant,omitempty"`
	password string `json:"MotDePasse,omitempty"`
}

type User struct {
	id       string
	name     string
	password string
	pubkey   string
	privkey  string
}

func CreateUser(name string, password string) User {
	newprivkey, newpubkey := genKeys()
	newprivkeystr := ExportRsaPrivateKeyAsPemStr(newprivkey)
	newpubkeystr, _ := ExportRsaPublicKeyAsPemStr(newpubkey)
	return User{name: name, password: password, pubkey: newpubkeystr, privkey: newprivkeystr}
}

func forModifUser(name string, password string, newpubkeystr string, newprivkeystr string) User {
	return User{name: name, password: password, pubkey: newpubkeystr, privkey: newprivkeystr}
}

func (User User) AddUserToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	rsapub, _ := ParseRsaPublicKeyFromPemStr(User.pubkey)
	_, err = db.Exec("INSERT INTO user (username, password, pubkeyrsa, privkeyrsa) VALUES (?, ?, ?, ?)", User.name, ChiffrementMDP(User.password, rsapub), User.pubkey, User.privkey)
	if err != nil {
		panic(err)
	}
}

func GetUserWithId() User {
	var user User
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM user")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		err = rows.Scan(&user.id, &user.name, &user.password, &user.pubkey, &user.privkey)
		if err != nil {
			panic(err)
		}
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return user
}

func (User User) ModifUserToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE user SET username = ?, password = ?, pubkeyrsa = ?, privkeyrsa = ? where id = ?", User.name, User.password, User.pubkey, User.privkey ,id)
	if err != nil {
		panic(err)
	}
}

func ChangeNewKey() {
	newprivkey, newpubkey := genKeys()
	rsa := GetRSA()
	lastprivkey, _ := ParseRsaPrivateKeyFromPemStr(rsa.Prikey)
	newpubkeystr, _ := ExportRsaPublicKeyAsPemStr(newpubkey)
	log := GetLoginWithID()
	for _, login := range log {
		mdpdechif := DeChiffrementMDP(login.Mdp, lastprivkey)
		loginmodif := NewLogin(login.Nomapp, login.Identifiant, ChiffrementMDP(mdpdechif, newpubkey))
		id := strconv.Itoa(login.Id)
		loginmodif.ModifLoginToDB(id)
	}
	user := GetUserWithId()
	mdpuserdechif := DeChiffrementMDP(user.password, lastprivkey)
	usermodif := forModifUser(user.name, ChiffrementMDP(mdpuserdechif,newpubkey),newpubkeystr,ExportRsaPrivateKeyAsPemStr(newprivkey))
	usermodif.ModifUserToDB(user.id)
}
