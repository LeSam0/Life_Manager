package main

import (
	LifeManager "LifeManager/API"
	// LifeManagersc "LifeManager/Script"
	LifeManagerdb "LifeManager/Script/DataBase"
)

func main() {
	// // LifeManagersc.DeSecureFile()
	// 	LifeManagersc.SecureFile()
	LifeManagerdb.Create()
	// LifeManagerdb.CreateCategorieCourse()
	// LifeManagerdb.CreateCategorieDepense()
	// LifeManagerdb.CreateSousCategorieDepense()
	LifeManager.API()
}
