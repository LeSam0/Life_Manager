package LifeManager

type Error struct {
	Errorcode string `json:"Error,omitempty"` 
}

func Login_(identifiant string, mdp string) Error {
	user := GetUserWithId()
	var reponse Error
	privkey, _ := ParseRsaPrivateKeyFromPemStr(user.privkey)
	if user.name == identifiant {
		if DeChiffrementMDP(user.password, privkey) == mdp {
			reponse.Errorcode = "ok"
		} else {
			reponse.Errorcode = "badmdp"
		}
	} else {
		reponse.Errorcode = "badident"
	}
	return reponse
}

func Register(identifiant string, mdp string) {
	User := CreateUser(identifiant, mdp)
	User.AddUserToDB()
}

