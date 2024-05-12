import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_field/date_field.dart';
import 'calendar_item.dart';
import 'package:intl/intl.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime? _selectedDay;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  List<CalendarItem> calendarItems = [];
  List<CalendarItem> calendardayItems = [];


  @override
  void initState() {
    super.initState();
    fetchEvent();
    final selectedDate = DateFormat('yyyy-dd-MM').format(DateTime.now()!);
    fetchByDay(selectedDate);
  }

  Future<void> fetchEvent() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/calendar/get'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          calendarItems = data
              .map<CalendarItem>((item) => CalendarItem(
                    id: item['EventId'].toString(),
                    eventName: item['EventName'].toString(),
                    eventDate: DateTime.parse(item['EventDate']),
                  ))
              .toList();
        });
      } else {
        calendarItems = [];
      }
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<void> fetchByDay(day) async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/calendar/get/jour?jour=$day'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          calendardayItems = data
              .map<CalendarItem>((item) => CalendarItem(
                    id: item['EventId'].toString(),
                    eventName: item['EventName'].toString(),
                    eventDate: DateTime.parse(item['EventDate']),
                  ))
              .toList();
        });
      } else {
        calendardayItems = [];
      }
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<void> addEvent(String eventName, DateTime eventDate) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(eventDate);
      final url = Uri.parse(
          'http://localhost:8000/calendar/create?name=$eventName&date=$formattedDate');
      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchEvent();
      } else {
        throw Exception('Failed to add event');
      }
    } catch (error) {
      print('Error adding event: $error');
    }
  }

  Future<void> SuppItem(String id) async {
    final urlNormal = Uri.parse('http://localhost:8000/calendar/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final responseNormal = await http.delete(urlNormal);

    if (responseNormal.statusCode == 200) {
      fetchEvent();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> _updateItem(String id, String name, DateTime date) async {
    final url = Uri.parse('http://localhost:8000/calendar/update').replace(
      queryParameters: {
        'id': id,
        'name': name,
        'date': date.toString(),
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchEvent();
    } else {
      throw Exception('Failed to update item');
    }
  }

  bool hasEventsForDay(DateTime day) {
    return calendarItems.any((item) =>
        item.eventDate.year == day.year &&
        item.eventDate.month == day.month &&
        item.eventDate.day == day.day);
  }

  void _changeMonth(int months) {
    setState(() {
      _selectedMonth += months;
      if (_selectedMonth < 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else if (_selectedMonth > 12) {
        _selectedMonth = 1;
        _selectedYear++;
      }
    });
  }



 @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
    body : Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 150,
                      ),
                    SizedBox(width: 20),
                    Text(
                  'Calendrier des événements',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
										),
							SizedBox(width: 483),
new SizedBox(
  width: 200.0,
  height: 100.0,
  child: ElevatedButton(
		child: Image.asset('assets/user.png',),
    onPressed: (
		) {		Navigator.pushNamed(context, '/page6');
},
  ),
),
                    ],
                  ),
                  SizedBox(height: 20),
                   Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 220, 220),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.home),
                        label: const Text('Home'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/page2');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.monetization_on),
                        label: const Text('Dépenses'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/page3');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.shopping_cart),
                        label: const Text('Course'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/page4');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.food_bank),
                        label: const Text('Menu'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/page5');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.key),
                        label: const Text('Securite'),
                      ),
                    ],
                  ),
                ),
								SizedBox(width: 50),
                Expanded(
                  child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _changeMonth(-1);
                                },
                                icon: Icon(Icons.arrow_back),
                              ),
                              Text(
                                DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth, 1)),
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                onPressed: () => _changeMonth(1),
                                icon: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TableCalendar(
                      focusedDay: DateTime(_selectedYear, _selectedMonth, 1),
                            firstDay: DateTime.now().add(Duration(days: -1830)),
                            lastDay: DateTime.now().add(Duration(days: 1830)),
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: Colors.red),
                              weekendStyle: TextStyle(color: Colors.green),
                            ),
                            headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(fontSize: 20),
                            ),
                            rowHeight: constraints.maxHeight * 0.10,
                            daysOfWeekHeight: constraints.maxHeight * 0.1,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                final selectedDate = DateFormat('yyyy-dd-MM').format(_selectedDay!);
                                fetchByDay(selectedDate);
                              });
                            },
                            availableCalendarFormats: {
                              CalendarFormat.month: 'Mois',
                              CalendarFormat.twoWeeks: '2 Semaines',
                              CalendarFormat.week: 'Semaine',
                            },
                            eventLoader: (day) {
                              return day.month == _selectedMonth && day.year == _selectedYear && hasEventsForDay(day) ? [day] : [];
                            },
                        ),
                      )
                  ])
                ),
                SizedBox(width: 70,),
                Container(
                width: constraints.maxWidth * 0.2, 
                height: constraints.maxHeight* 0.7,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 220, 220),
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Center(
                    child : Text(
                      'Évenement du Jour',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: calendardayItems.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child :Column(
                            children: [
                               Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    setState(() {
                                      SuppItem(calendardayItems[index].id);
                                    });
                                  },
                                  
                                  child: ListTile(
                                    title: Text(
                                      calendardayItems[index].eventName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${DateFormat('dd/MM/yyyy').format(calendardayItems[index].eventDate)}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              SuppItem(calendardayItems[index].id);
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                          String eventName = calendardayItems[index].eventName;
                                          DateTime? date = calendardayItems[index].eventDate;
                                              TimeOfDay selectedTime = TimeOfDay.now();
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                return AlertDialog(
                                              title: Text('Ajouter un événement'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                                                    onChanged: (value) {
                                                      eventName = value;
                                                    },
                                                     controller: TextEditingController(text: eventName),
                                                  ),
                                                  SizedBox(height: 20),
                                                  DateTimeFormField(
                                                    decoration: const InputDecoration(
                                                      labelText: 'Selectionner une Date',
                                                    ),
                                                    initialPickerDateTime: date,
                                                    dateFormat: DateFormat.yMd(),
                                                    mode: DateTimeFieldPickerMode.date,
                                                    onChanged: (DateTime? value) {
                                                      date = value;
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Annuler'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    if (eventName.isNotEmpty && _selectedDay != null) {
                                                      _updateItem(
                                                        calendardayItems[index].id, 
                                                        eventName,
                                                        date!,
                                                      );
                                                      Navigator.of(context).pop();
                                                    } else {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text('Erreur'),
                                                                      content: Text(
                                                                          'Veuillez sélectionner une date.'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text('OK'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                    }
                                                  },
                                                  child: Text('Ajouter'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            SizedBox(height: 10,)
                            ]
                          ))
                          ;
                        },
                      ),
                    ),
              ]),
              ),


                ])])))]);})),
			floatingActionButton: FloatingActionButton(
        onPressed: () {
          String eventName = '';
          TimeOfDay selectedTime = TimeOfDay.now();
          showDialog(
            context: context,
            builder: (BuildContext context) {
            return AlertDialog(
          title: Text('Ajouter un événement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                onChanged: (value) {
                  eventName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Text('Sélectionner l\'heure'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (eventName.isNotEmpty && _selectedDay != null) {
                  final eventDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  addEvent(eventName, eventDate);
                  Navigator.of(context).pop();
                } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une date sur le calendrier.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
        },
        child: Icon(Icons.add),
			)
          );
        }
}