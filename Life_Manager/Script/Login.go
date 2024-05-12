package LifeManager

import (
	"database/sql"
)

type Login struct {
	NomApp      string `json:"NomApp,omitempty"`
	Identifiant string `json:"Identifiant,omitempty"`
	MotDePasse  string `json:"MotDePasse,omitempty"`
}

func NewLogin(NomApp string, Identifiant string, MotDePasse string) Login {
	return Login{NomApp: NomApp, Identifiant: Identifiant, MotDePasse: MotDePasse}
}

func (Login Login) AddLoginToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	rsa := GetRSA()
	rsapub, _ := ParseRsaPublicKeyFromPemStr(rsa.Pubkey)
	_, err = db.Exec("INSERT INTO login (NomApp, identifiant, password) VALUES (?, ?, ?)", Login.NomApp, Login.Identifiant, ChiffrementMDP(Login.MotDePasse, rsapub))
	if err != nil {
		panic(err)
	}
}

func SuppLoginToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM login WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Login Login) ModifLoginToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	rsa := GetRSA()
	rsapub, _ := ParseRsaPublicKeyFromPemStr(rsa.Pubkey)
	_, err = db.Exec("UPDATE login SET NomApp = ?, identifiant = ?, password = ? where id = ?", Login.NomApp, Login.Identifiant, ChiffrementMDP(Login.MotDePasse, rsapub), id)
	if err != nil {
		panic(err)
	}
}

func GetLoginWithID() []LoginForRSA {
	var log []LoginForRSA
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, NomApp, Identifiant, password FROM login")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var login LoginForRSA
		err = rows.Scan(&login.Id, &login.Nomapp, &login.Identifiant, &login.Mdp)
		if err != nil {
			panic(err)
		}
		logtest := &login
		rsa := GetRSA()
		privkey, _ := ParseRsaPrivateKeyFromPemStr(rsa.Prikey)
		logtest.Mdp = DeChiffrementMDP(login.Mdp, privkey)
		log = append(log, *logtest)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return log
}
