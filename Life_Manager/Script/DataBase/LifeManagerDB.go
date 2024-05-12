package LifeManager

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

var Database *sql.DB

func Create() {
	//connect to database
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	Database = db
	defer db.Close()
	// Create table User
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, pubkeyrsa TEXT, privkeyrsa TEXT)")
	if err != nil {
		panic(err)
	}
	log.Println("Table User created successfully")
	// Create table Login
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS login (id INTEGER PRIMARY KEY AUTOINCREMENT, NomApp TEXT, Identifiant TEXT, password TEXT)")
	if err != nil {
		panic(err)
	}
	log.Println("Table login created successfully")
	// Create table categorie_depense
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS categorie_depense (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT)")
	if err != nil {
		panic(err)
	}
	log.Println("Table categorie_depense created successfully")
	// Create table sous_categorie_depense
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS sous_categorie_depense (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, id_categorie INTEGER, FOREIGN KEY (id_categorie) REFERENCES categorie_depense(id))")
	if err != nil {
		panic(err)
	}
	log.Println("Table sous_categorie_depense created successfully")
	// Create table dépenses
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS depenses (id INTEGER PRIMARY KEY AUTOINCREMENT, Nom TEXT, Montant FLOAT, Date DATETIME, Description TEXT, id_sous_categorie INTEGER , FOREIGN KEY (id_sous_categorie) REFERENCES sous_categorie_depense(id))")
	if err != nil {
		panic(err)
	}
	log.Println("Table depenses created successfully")
	// Create table categorie_course
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS categorie_course (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT)")
	if err != nil {
		panic(err)
	}
	log.Println("Table categorie_course created successfully")
	// Create table courses
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS courses (id INTEGER PRIMARY KEY AUTOINCREMENT, categorie_id INTEGER, article TEXT, prix FLOAT, quantite INTEGER, is_check BOOLEAN, FOREIGN KEY (categorie_id) REFERENCES categorie_course(id))")
	if err != nil {
		panic(err)
	}
	log.Println("Table course created successfully")
	// Create table courses_favori
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS courses_favori (id INTEGER PRIMARY KEY AUTOINCREMENT, categorie_id INTEGER, article TEXT, prix FLOAT, quantite INTEGER, is_check BOOLEAN, FOREIGN KEY (categorie_id) REFERENCES categorie_course(id))")
	if err != nil {
		panic(err)
	}
	log.Println("Table course_favorie created successfully")
	// Create table depenses futur
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS depenses_futur (id INTEGER PRIMARY KEY AUTOINCREMENT, Nom TEXT, Montant FLOAT, Date DATETIME, Description TEXT, id_sous_categorie INTEGER , FOREIGN KEY (id_sous_categorie) REFERENCES sous_categorie_depense(id))")
	if err != nil {
		panic(err)
	}
	log.Println("Table depenses_futur created successfully")
	// Create table secure_chest
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS secure_chest (id INTEGER PRIMARY KEY AUTOINCREMENT, Filename TEXT)")
	if err != nil {
		panic(err)
	}
	log.Println("Table secure_chest created successfully")
	// Create table calendar
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS calendar (id INTEGER PRIMARY KEY AUTOINCREMENT, event_name TEXT, event_date DATETIME)")
	if err != nil {
		panic(err)
	}
	log.Println("Table calendar created successfully")
	// Create table menu
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS menu (id INTEGER PRIMARY KEY AUTOINCREMENT, menu_name TEXT, link TEXT, date DATETIME)")
	if err != nil {
		panic(err)
	}
	log.Println("Table menu created successfully")
}

func CreateCategorieCourse() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	categorie := []string{"Boissons", "Viandes", "Poissons", "Fruits et Legumes", "Pains et Patisseries", "Produits laitiers", "Charcuterie et Traiteur", "Surgeles", "Epicerie salee", "Epicerie sucree", "Bebe", "Hygiene et Beaute", "Entretien et Nettoyage", "Autres"}
	for _, i := range categorie {
		_, err = db.Exec("INSERT INTO categorie_course (type) VALUES (?)", i)
		if err != nil {
			panic(err)
		}
	}
	log.Println("Categorie course created successfully")
}

func CreateCategorieDepense() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	categorie := []string{"Abonnements et Telephonie", "Auto et Moto", "Autres depenses", "Cadeaux et Solidarité", "Cheques", "Depenses d'epargne", "Education et Famille", "Emprunts", "Frais Professionnel", "Impots et Taxes", "Logement", "Loisirs et Sorties", "Retraits cash", "Sante", "Vie quotidienne", "Virements emis", "Voyages et Transports"}
	for _, i := range categorie {
		_, err = db.Exec("INSERT INTO categorie_depense (type) VALUES (?)", i)
		if err != nil {
			panic(err)
		}
	}
	log.Println("Categorie depense created successfully")
}

func CreateSousCategorieDepense() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	sous_categorie := map[string]int{"Abonnements": 1, "Telephonie": 1, "Tv et Internet": 1, "Abonnements et Telephonie Autre": 1, "Assurances": 2, "Carburant": 2, "Contraventions": 2, "Entretien - Reparation": 2, "Financement": 2, "Parking": 2, "Peages": 2, "Auto et Moto Autre": 2, "Autres depenses": 3, "Dons et Cadeaux": 4, "Solidarité Autre": 4,
		"Cheques": 5, "Epargne financiere": 6, "Epargne bancaire": 6, "Placements Boursiers": 6, "Placements immobiliers": 6, "Depenses d'epargne Autre": 6, "Argent de poche": 7, "Etudes": 7, "Creche, Nounou, babysitter...": 7, "Pension": 7, "Education et Famille Autre": 7, "Pret etudiant": 8, "Credit conso": 8, "Enprunts Autres": 8, "Frais professionnel": 9,
		"Impot sur le revenu": 10, "Impot sur la fortune immobiliere": 10, "Taxe d'habitation": 10, "Taxe fonciere": 10, "Urssaf et charge patronales": 10, "CSG-CRDS": 10, "Impots et Taxes Autres": 10, "Nettoyage et services a domcile": 11, "Assurance habitation": 11, "Eau": 11, "Emprunt immobilier": 11, "Energie": 11, "Frais exceptionnels": 11,
		"Loyers, Charge": 11, "Travaux, entretien ...": 11, "Logement": 11, "Loisirs Autres": 12, "Club / Association": 12, "Divertissement": 12, "Depenses jeux et paris": 12, "Restaurants, Bar, Discotheque ...": 12, "Retraits cash": 13, "Sante Autre": 14, "Complementaires sante": 14, "Medecin et frais medicaux": 14, "Optique, audition ...": 14,
		"Pharmacie et laboratoire": 14, "Vie Quotidienne Autres": 15, "Alimentation": 15, "Animaux domestiques": 15, "Bien-etre et soin": 15, "Bricolage et jardinage": 15, "Electronique et informatique": 15, "Equipements spotifs et artistoques": 15, "Laverie, Pressing ...": 15, "Livre, CD, DVD, bijoux, jouets ...": 15, "Mobilier, electromenager, decoration ...": 15,
		"Tabac": 15, "Vetements et Accessoires": 15, "Virements emis": 16, "Voyages et Transports Autres": 17, "Agences de voyages": 17, "Hebergement": 17, "Location de vehicules": 17, "Taxis": 17, "Transports Longue distance": 17, "Transports Quotidiens": 17}
	for i := range sous_categorie {
		_, err = db.Exec("INSERT INTO sous_categorie_depense (type, id_categorie) VALUES (?,?)", i, sous_categorie[i])
		if err != nil {
			panic(err)
		}
	}
	log.Println("Sous categorie depense created successfully")
}
