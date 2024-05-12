package LifeManager

import (
	"database/sql"
	"time"
)

type Calendar struct {
	EventId   int       `json:"EventId,omitempty"`
	EventName string    `json:"EventName,omitempty"`
	EventDate time.Time `json:"EventDate,omitempty"`
}

func NewCalendar(EventName string, EventDate time.Time) Calendar {
	return Calendar{EventName: EventName, EventDate: EventDate}
}

func (Calendar Calendar) AddCalendarToDB() {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("INSERT INTO calendar (event_name, event_date) VALUES (?, ?)", Calendar.EventName, Calendar.EventDate)
	if err != nil {
		panic(err)
	}
}

func SuppCalendarToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	_, err = db.Exec("DELETE FROM calendar WHERE id = ?", id)
	if err != nil {
		panic(err)
	}
}

func (Calendar Calendar) ModifCalendarToDB(id string) {
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	_, err = db.Exec("UPDATE calendar SET event_name = ?, event_date = ? where id = ?", Calendar.EventName, Calendar.EventDate, id)
	if err != nil {
		panic(err)
	}
}

func GetCalendar() []Calendar {
	var cal []Calendar
	db, err := sql.Open("sqlite3", "./LifeManager.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT * FROM calendar")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var calendar Calendar
		err = rows.Scan(&calendar.EventId, &calendar.EventName, &calendar.EventDate)
		if err != nil {
			panic(err)
		}
		cal = append(cal, calendar)
	}
	if err = rows.Err(); err != nil {
		panic(err)
	}
	return cal
}

func GetCalendarbyDay(day string) []Calendar {
	calendars := GetCalendar()
	var cal []Calendar
	for _, calendar := range calendars {
		if calendar.EventDate.Format("2006-02-01") == day {
			cal = append(cal, calendar)
		}
	}
	return cal
}
