package LifeManager

import (
	LifeManager "LifeManager/Script"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"time"
)

func API() {

	// RSA

	http.HandleFunc("/rsa", RSA)

	// Login / Register 

	http.HandleFunc("/login", Login)
	http.HandleFunc("/register", Register)

	// Depense future

	http.HandleFunc("/depense/futur/create", CreateFuturDepense)
	http.HandleFunc("/depense/futur/get/all", GetFuturAllDepense)
	http.HandleFunc("/depense/futur/update", UpdateFuturDepense)
	http.HandleFunc("/depense/futur/delete", DeleteFuturDepense)

	// Depense

	http.HandleFunc("/depense/create", CreateDepense)
	http.HandleFunc("/depense/get/all", GetAllDepense)
	http.HandleFunc("/depense/get/jour", GetDepensebyDay)
	http.HandleFunc("/depense/get/mois", GetDepensebyMonth)
	http.HandleFunc("/depense/get/annee", GetDepensebyYear)
	http.HandleFunc("/depense/update", UpdateDepense)
	http.HandleFunc("/depense/delete", DeleteDepense)

	// Categorie / Sous-Categorie Depense

	http.HandleFunc("/depense/categorie", GetAllCategorieDepense)
	http.HandleFunc("/depense/souscategorie", GetAllSousCategorieDepense)

	// Total depense

	http.HandleFunc("/depense/total", GetTotal)

	// Total course 

	http.HandleFunc("/course/total", GetTotalCourse)

	// Login

	http.HandleFunc("/login/create", CreateLogin)
	http.HandleFunc("/login/get", GetAllLogin)
	http.HandleFunc("/login/update", UpdateLogin)
	http.HandleFunc("/login/delete", DeleteLogin)

	// Menu

	http.HandleFunc("/menu/create", CreateMenu)
	http.HandleFunc("/menu/get", GetAllMenu)
	http.HandleFunc("/menu/get/jour", GetMenubyDay)
	http.HandleFunc("/menu/update", UpdateMenu)
	http.HandleFunc("/menu/delete", DeleteMenu)

	// Mdp

	http.HandleFunc("/login/motdepasse", GetMotdePasse)

	// Categorie Course

	http.HandleFunc("/courses/categorie", GetAllCategorie)

	// Course

	http.HandleFunc("/courses/create", CreateCourse)
	http.HandleFunc("/courses/get", GetAllCourse)
	http.HandleFunc("/courses/update", UpdateCourse)
	http.HandleFunc("/courses/delete", DeleteCourse)
	http.HandleFunc("/courses/vide", VideAllCourse)

	// Course Favorie

	http.HandleFunc("/courses/favorie/create", CreateCourseFavorie)
	http.HandleFunc("/courses/favorie/get", GetAllCourseFavorie)
	http.HandleFunc("/courses/favorie/update", UpdateCourseFavorie)
	http.HandleFunc("/courses/favorie/delete", DeleteCourseFavorie)

	// Calendar

	http.HandleFunc("/calendar/create", CreateEvent)
	http.HandleFunc("/calendar/get", GetAllEvent)
	http.HandleFunc("/calendar/get/jour", GetAllEventbyday)
	http.HandleFunc("/calendar/update", UpdateEvent)
	http.HandleFunc("/calendar/delete", DeleteEvent)

	log.Fatal(http.ListenAndServe(":8000", nil))
}

func DeleteFuturDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppFuturDepensesToDB(id)
	}
}

func UpdateFuturDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "PUT" {
		Id := r.URL.Query().Get("id")
		Nom := r.URL.Query().Get("nomdepense")
		Montant, _ := strconv.ParseFloat(r.URL.Query().Get("montant"), 64)
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get(""))
		Description := r.URL.Query().Get("description")
		Id_Sous_Categorie, _ := strconv.Atoi(r.URL.Query().Get("description"))
		newLogin := LifeManager.NewDepenses(Nom, Montant, Date, Description, Id_Sous_Categorie)
		newLogin.ModifFuturToDB(Id)
	}
}


func GetFuturAllDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		AllDepense := LifeManager.GetFuturAllDepense()
		json.NewEncoder(w).Encode(AllDepense)
	}
}

func CreateFuturDepense(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		Nom := r.URL.Query().Get("nomdepense")
		Montant, _ := strconv.ParseFloat(r.URL.Query().Get("montant"), 64)
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		Description := r.URL.Query().Get("description")
		Id_Sous_Categorie, _ := strconv.Atoi(r.URL.Query().Get("idsouscategorie"))
		newDepenses := LifeManager.NewDepenses(Nom, Montant, Date, Description, Id_Sous_Categorie)
		newDepenses.AddFuturToDB()
	}
}

func DeleteDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppDepensesToDB(id)
	}
}

func UpdateDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "PUT" {
		Id := r.URL.Query().Get("id")
		Nom := r.URL.Query().Get("nomdepense")
		Montant, _ := strconv.ParseFloat(r.URL.Query().Get("montant"), 64)
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get(""))
		Description := r.URL.Query().Get("description")
		Id_Sous_Categorie, _ := strconv.Atoi(r.URL.Query().Get("description"))
		newLogin := LifeManager.NewDepenses(Nom, Montant, Date, Description, Id_Sous_Categorie)
		newLogin.ModifToDB(Id)
	}
}

func GetDepensebyMonth(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Mois := r.URL.Query().Get("mois")
		AllDepense := LifeManager.GetDepenseMois(Mois)
		json.NewEncoder(w).Encode(AllDepense)
	}
}

func GetDepensebyYear(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Annee := r.URL.Query().Get("annee")
		AllDepense := LifeManager.GetDepenseAnnee(Annee)
		json.NewEncoder(w).Encode(AllDepense)
	}
}

func GetDepensebyDay(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Jour := r.URL.Query().Get("jour")
		AllDepense := LifeManager.GetDepenseJour(Jour)
		json.NewEncoder(w).Encode(AllDepense)
	}
}

func GetAllDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		AllDepense := LifeManager.GetAllDepense()
		json.NewEncoder(w).Encode(AllDepense)
	}
}

func CreateDepense(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		Nom := r.URL.Query().Get("nomdepense")
		Montant, _ := strconv.ParseFloat(r.URL.Query().Get("montant"), 64)
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		Description := r.URL.Query().Get("description")
		Id_Sous_Categorie, _ := strconv.Atoi(r.URL.Query().Get("idsouscategorie"))
		newLogin := LifeManager.NewDepenses(Nom, Montant, Date, Description, Id_Sous_Categorie)
		newLogin.AddToDB()
	}
}

func GetAllCategorieDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		AllCategorieDepense := LifeManager.GetCategorieDepense()
		json.NewEncoder(w).Encode(AllCategorieDepense)
	}
}

func GetAllSousCategorieDepense(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		id_categorie := r.URL.Query().Get("id_categorie")
		AllSousCategorie := LifeManager.GetSousCategorieDepense(id_categorie)
		json.NewEncoder(w).Encode(AllSousCategorie)
	}
}

func CreateLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		NomApp := r.URL.Query().Get("nomapp")
		Identifiant := r.URL.Query().Get("identifiant")
		MotDePasse := r.URL.Query().Get("motdepasse")
		newLogin := LifeManager.NewLogin(NomApp, Identifiant, MotDePasse)
		newLogin.AddLoginToDB()
	}
}

func UpdateLogin(w http.ResponseWriter, r *http.Request) {
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		NomApp := r.URL.Query().Get("nomapp")
		Identifiant := r.URL.Query().Get("identifiant")
		MotDePasse := r.URL.Query().Get("motdepasse")
		newLogin := LifeManager.NewLogin(NomApp, Identifiant, MotDePasse)
		newLogin.ModifLoginToDB(id)
	}
}

func DeleteLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppLoginToDB(id)
	}
}

func GetAllLogin(w http.ResponseWriter, r *http.Request) {

	if r.Method == "GET" {
		liste_Login := LifeManager.GetLoginWithID()
		json.NewEncoder(w).Encode(liste_Login)
	}
}

func GetMotdePasse(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Mdp := LifeManager.Newmdp()
		json.NewEncoder(w).Encode(Mdp)
	}
}

func CreateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/create?categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Post
	if r.Method == "POST" {
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite, false)
		newArticle.AddToDB()
	}
}

func UpdateCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/update?id=1&categorie_id=1&article=eau&prix=1.50&quantite=20
	// Methode := Put
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		is_check := false
		if r.URL.Query().Get("is_check") == "true"{
			is_check = true
		}
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite, is_check)
		newArticle.ModifToDB(id)
	}
}

func DeleteCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/delete?id=1
	// Methode := Delete
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppToDB(id)
	}
}

func GetAllCourse(w http.ResponseWriter, r *http.Request) {

	// test
	// http://localhost:8000/courses/get
	// Methode := Get
	if r.Method == "GET" {
		Liste_course := LifeManager.GetListeByCategorie()
		json.NewEncoder(w).Encode(Liste_course)
	}
}

func GetAllCourseFavorie(w http.ResponseWriter, r *http.Request) {

	if r.Method == "GET" {
		Liste_course := LifeManager.GetListeFavByCategorie()
		json.NewEncoder(w).Encode(Liste_course)
	}
}

func CreateCourseFavorie(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite, false)
		newArticle.AddFavToDB()
	}
}

func UpdateCourseFavorie(w http.ResponseWriter, r *http.Request) {

	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		categorie_id, _ := strconv.Atoi(r.URL.Query().Get("categorie_id"))
		article := r.URL.Query().Get("article")
		prix, _ := strconv.ParseFloat(r.URL.Query().Get("prix"), 64)
		quantite, _ := strconv.Atoi(r.URL.Query().Get("quantite"))
		newArticle := LifeManager.NewArticle(categorie_id, article, prix, quantite, false)
		newArticle.ModifFavToDB(id)
	}
}

func DeleteCourseFavorie(w http.ResponseWriter, r *http.Request) {
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppFavToDB(id)
	}
}

func GetAllCategorie(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		AllCategorie := LifeManager.GetCategorie()
		json.NewEncoder(w).Encode(AllCategorie)
	}
}

func CreateEvent(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		eventname := r.URL.Query().Get("name")
		eventdate, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		newEvent := LifeManager.NewCalendar(eventname, eventdate)
		newEvent.AddCalendarToDB()
	}

}

func UpdateEvent(w http.ResponseWriter, r *http.Request) {

	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		eventname := r.URL.Query().Get("name")
		eventdate, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		newEvent := LifeManager.NewCalendar(eventname, eventdate)
		newEvent.ModifCalendarToDB(id)
	}
}

func DeleteEvent(w http.ResponseWriter, r *http.Request) {
	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppCalendarToDB(id)
	}
}

func GetAllEvent(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		liste_event := LifeManager.GetCalendar()
		json.NewEncoder(w).Encode(liste_event)
	}
}

func GetAllEventbyday(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		day := r.URL.Query().Get("jour")
		liste_event := LifeManager.GetCalendarbyDay(day)
		json.NewEncoder(w).Encode(liste_event)
	}
}

func VideAllCourse(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		LifeManager.DeleteAllListe()
	}
}

func GetTotal(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		total := LifeManager.GetTotal()
		json.NewEncoder(w).Encode(total)
	}
}

func CreateMenu(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {
		Menu_Name := r.URL.Query().Get("menu_Name")
		Link := r.URL.Query().Get("link")
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		newMenu := LifeManager.NewMenu(Menu_Name, Link, Date)
		newMenu.AddMenuToDB()
	}
}

func UpdateMenu(w http.ResponseWriter, r *http.Request) {
	if r.Method == "PUT" {
		id := r.URL.Query().Get("id")
		Menu_Name := r.URL.Query().Get("menu_Name")
		Link := r.URL.Query().Get("link")
		Date, _ := time.Parse("2006-01-02 15:04:05", r.URL.Query().Get("date"))
		newMenu := LifeManager.NewMenu(Menu_Name, Link, Date)
		newMenu.ModifMenuToDB(id)
	}
}

func DeleteMenu(w http.ResponseWriter, r *http.Request) {

	if r.Method == "DELETE" {
		id := r.URL.Query().Get("id")
		LifeManager.SuppMenuToDB(id)
	}
}

func GetAllMenu(w http.ResponseWriter, r *http.Request) {

	if r.Method == "GET" {
		liste_Menu := LifeManager.GetMenu()
		json.NewEncoder(w).Encode(liste_Menu)
	}
}

func GetMenubyDay(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		Jour := r.URL.Query().Get("jour")
		menuday := LifeManager.GetDepenseJour(Jour)
		json.NewEncoder(w).Encode(menuday)
	}
}

func GetTotalCourse(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		total := LifeManager.GetTotalListe()
		json.NewEncoder(w).Encode(total)
	}
}

func Login(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		identifiant := r.URL.Query().Get("identifiant")
		password := r.URL.Query().Get("password")
		login := LifeManager.Login_(identifiant, password)
		json.NewEncoder(w).Encode(login)
	}
}

func Register(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		identifiant := r.URL.Query().Get("identifiant")
		password := r.URL.Query().Get("password")
		LifeManager.Register(identifiant, password)
	}
}

func RSA(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		LifeManager.ChangeNewKey()
	}
}