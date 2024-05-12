package LifeManager

import (
	"database/sql"
)

type Total_Value struct {
	Total float64  `json:"Total,omitempty"`
}

type Categorie struct {
	Id             int    `json:"Id,omitempty"`
	Categorie_Name string `json:"Categorie_Name,omitempty"`
}

type Articles struct {
	Categorie    string  `json:"Categorie_Name,omitempty"`
	Id           int     `json:"Id,omitempty"`
	Categorie_id int     `json:"Categorie_Id,omitempty"`
	Article      string  `json:"Article,omitempty"`
	Prix         float64 `json:"Prix,omitempty"`
	Quantite     int     `json:"Quantite,omitempty"`
	Is_Check     bool    `json:"IsCheck,omitempty"`
}

func NewArticle(Categorie_id int, Article string, Prix float64, Quantite int, Is_Check bool) Articles {
	liste := Articles{Categorie_id: Categorie_id, Article: Article, Prix: Prix, Quantite: Quantite, Is_Check: Is_Check}
	return liste
}

func (Liste Articles) AddToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO courses (categorie_id, article, prix, quantite, is_check) VALUES (?, ?, ?, ?, ?)", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite, Liste.Is_Check)
	if err != nil {
		panic(err)
	}
}

func SuppToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM courses WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Liste Articles) ModifToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE courses SET categorie_id = ?, article = ?, prix = ?, quantite = ?, is_check = ? where id = ?", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite, Liste.Is_Check, id)
	if err != nil {
		panic(err)
	}
}

func GetAllCourse() []Articles {
	var articles []Articles
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, categorie_id, article, prix, quantite, is_check FROM courses")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var article Articles
		err = rows.Scan(&article.Id, &article.Categorie_id, &article.Article, &article.Prix, &article.Quantite, &article.Is_Check)
		if err != nil {
			panic(err)
		}
		articles = append(articles, article)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return articles
}

func GetCategorie() []Categorie {
	var categories []Categorie
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM categorie_course")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var categorie Categorie
		err = rows.Scan(&categorie.Id, &categorie.Categorie_Name)
		if err != nil {
			panic(err)
		}
		categories = append(categories, categorie)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return categories
}

func GetCategoriebyId(id int) string {
	name := ""
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT type FROM categorie_course WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		err = rows.Scan(&name)
		if err != nil {
			panic(err)
		}
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return name
}

func GetListeByCategorie() []Articles {
	liste_course := GetAllCourse()
	for i := range liste_course {
		liste_course[i].Categorie = GetCategoriebyId(liste_course[i].Categorie_id)
	}
	return liste_course
}

func DeleteAllListe() {
	var ids []string
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id FROM courses")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var id string
		err = rows.Scan(&id)
		if err != nil {
			panic(err)
		}
		ids = append(ids, id)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	for _, id := range ids {
		db, err := sql.Open("sqlite3", "./LifeManager.db")
		if err != nil {
			panic(err)
		}
		defer db.Close()
		_, err = db.Exec("DELETE FROM courses WHERE id = ?", id)
		if err != nil {
			panic(err)
		}
	}
}

func GetTotalListe() Total_Value{
	allcourse := GetAllCourse()
	var total  Total_Value
	total.Total = 0.0
	for _,course := range allcourse {
		total.Total += course.Prix * float64(course.Quantite)
	} 
	return total
}
