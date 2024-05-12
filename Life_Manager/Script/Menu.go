package LifeManager

import (
	"database/sql"
	"time"
)

type Menu struct {
	Id        string    `json:"Id,omitempty"`
	Menu_Name string    `json:"Menu_Name,omitempty"`
	Link      string    `json:"Link,omitempty"`
	Date      time.Time `json:"Date,omitempty"`
}

func NewMenu(Menu_Name string, Link string, Date time.Time) Menu {
	return Menu{Menu_Name: Menu_Name, Link: Link, Date: Date}
}

func (Menu Menu) AddMenuToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO menu (menu_name, link, date) VALUES (?, ?, ?)", Menu.Menu_Name, Menu.Link, Menu.Date)
	if err != nil {
		panic(err)
	}
}

func SuppMenuToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM menu WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Menu Menu) ModifMenuToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE menu SET menu_name = ?, link = ?, date = ? where id = ?", Menu.Menu_Name, Menu.Link, Menu.Date, id)
	if err != nil {
		panic(err)
	}
}

func GetMenu() []Menu {
	var menus []Menu
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM menu")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var menu Menu
		err = rows.Scan(&menu.Id, &menu.Menu_Name, &menu.Link, &menu.Date)
		if err != nil {
			panic(err)
		}
		menus = append(menus, menu)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return menus
}

func GetMenuofadate(date string) []Menu {
	depenses := GetMenu()
	var finaldepenses []Menu
	for _, depense := range depenses {
		if depense.Date.Format("2006-02-01") == date {
			finaldepenses = append(finaldepenses, depense)
		}
	}
	return finaldepenses
}