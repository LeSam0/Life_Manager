package LifeManager

import (
	"database/sql"
)

func (Liste Articles) AddFavToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO courses_favori (categorie_id, article, prix, quantite) VALUES (?, ?, ?, ?)", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite)
	if err != nil {
		panic(err)
	}
}

func SuppFavToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM courses_favori WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Liste Articles) ModifFavToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE courses_favori SET categorie_id = ?, article = ?, prix = ?, quantite = ? where id = ?", Liste.Categorie_id, Liste.Article, Liste.Prix, Liste.Quantite, id)
	if err != nil {
		panic(err)
	}
}

func GetAllCourseFav() []Articles {
	var articles []Articles
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, categorie_id, article, prix, quantite FROM courses_favori")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var article Articles
		err = rows.Scan(&article.Id, &article.Categorie_id, &article.Article, &article.Prix, &article.Quantite)
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

func GetListeFavByCategorie() []Articles {
	liste_course := GetAllCourseFav()
	for i := range liste_course {
		liste_course[i].Categorie = GetCategoriebyId(liste_course[i].Categorie_id)
	}
	return liste_course
}
