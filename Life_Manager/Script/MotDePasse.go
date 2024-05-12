package LifeManager

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"os/exec"
)

type MDP struct {
	MotDePasse string `json:"MotDePasse,omitempty"`
}

func Newmdp() MDP {
	cmd := exec.Command("python","./Python/MotDePasse.py")
	out, err := cmd.Output()
	if err != nil {
		panic(err.Error())
	}
	return MDP{MotDePasse: string(out)}
}

func ChiffrementMDP(mdp string, PubKey *rsa.PublicKey) string {
	Mdpchiffre, _ := rsa.EncryptOAEP(sha256.New(), rand.Reader, PubKey, []byte(mdp), []byte{})
	return string(Mdpchiffre)
}

func DeChiffrementMDP(mdp string, PrivKey *rsa.PrivateKey) string {
	Mdpdechiffre, _ := rsa.DecryptOAEP(sha256.New(), rand.Reader, PrivKey, []byte(mdp), []byte{})
	return string(Mdpdechiffre)
}
