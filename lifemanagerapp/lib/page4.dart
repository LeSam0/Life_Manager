import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'menu_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

   @override
  _Page4State createState() => _Page4State();
}

enum HeureRepas {
  midi('Midi', '2012-02-27 12:00:00'),
  soir('Soir', '2012-02-27 19:00:00');

  const HeureRepas(this.label, this.type);
  final String label;
  final String type;
}

class _Page4State extends State<Page4> {

    @override
  void initState() {
    super.initState();
    fetchmenuday();
    fetchmenu();
  }
  List<MenuItem> menuItem = [];
  List<MenuItem> menuItemDay = [];
  String? type;

  Future<void> fetchmenu() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/menu/get'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
      });
      } else {
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> fetchmenuday() async {
    DateTime day = DateTime.now();
    final response =
        await http.get(Uri.parse('http://localhost:8000/menu/get/jour?jour=$day'));

    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          menuItemDay = data
              .map<MenuItem>((item) => MenuItem(
                    id: item['Id'].toString(),
                    menu_name: item['Menu_Name'].toString(),
                    link: item['Link'].toString(),
                    date:  DateTime.parse(item['Date'].toString()),
                  ))
              .toList();
        });
      } else {
        menuItemDay = [];
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> SuppItem(String id) async {
    final urlNormal = Uri.parse('http://localhost:8000/menu/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final responseNormal = await http.delete(urlNormal);

    if (responseNormal.statusCode == 200) {
      fetchmenu();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> addItem(
      String name, String link, DateTime date) async {
    final url = Uri.parse('http://localhost:8000/menu/create').replace(
      queryParameters: {
        'menu_Name': name,
        'link': link,
        'date': date.toString(),
      },
    );

    final response = await http.post(url);
    if (response.statusCode == 200) {
      fetchmenu();
    } else {
      throw Exception('Failed to add item');
    }
  }

  Future<void> _updateItem(
      String id, String newName, double newPrice, int newQuantity, String categoryId, bool isChecked) async {
    final url = Uri.parse('http://localhost:8000/menu/update').replace(
      queryParameters: {
        'categorie_id': categoryId,
        'id': id,
        'article': newName,
        'prix': newPrice.toString(),
        'quantite': newQuantity.toString(),
        'is_check': isChecked.toString(),
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchmenu();
    } else {
      throw Exception('Failed to update item');
    }
  }


  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: const Text('Memu'),
      ),
      body: Row(
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
                  'Gestion des Menus de la semaine',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
										),
							SizedBox(width: 365),
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
                          Navigator.pushNamed(context, '/page1');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.calendar_month),
                        label: const Text('Calendrier'),
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
                SizedBox(width: 90,),
                Container(
                   child : Column (
                    children :[
								Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child:
                ListTile (
                title : Text(
                          'Repas prévu aujourd\'hui',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                subtitle: Text(
                          'Midi : ${menuItemDay.isNotEmpty ? menuItemDay[0].menu_name.toString() : 'Rien de prévu'} / Soir : ${menuItemDay.isNotEmpty ? menuItemDay[1].menu_name.toString() : 'Rien de prévu'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                  )
                ),
                SizedBox(height: 30,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 220, 220, 220),
                    borderRadius: BorderRadius.circular(20),
                  ),
                     child : Column (
                    children :[  
                    SizedBox(height: 70,),
                    TimePlanner(
                      startHour: 9,
                      endHour: 19,
                      headers: [
                        TimePlannerTitle(
                          date: "3/10/2021",
                          title: "sunday",
                        ),
                        TimePlannerTitle(
                          date: "3/11/2021",
                          title: "monday",
                        ),
                        TimePlannerTitle(
                          date: "3/12/2021",
                          title: "tuesday",
                        ),
                      ],
                      // tasks: tasks,
                    ),
                    ]))]
                  )
                )
              ]
              )
              ]
              )
              )
              )
              ]
              ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newName = '';
              String newLink = '';
              DateTime? newDate;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Ajouter un repas'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                              hint: type == null
                                  ? Text('Sélectionner l\'heure du repas')
                                  : null,
                              value: type,
                              onChanged: (String? value) {
                                setState(() {
                                  type = value;
                                });
                              },
                              items: HeureRepas.values.map<DropdownMenuItem<String>>(
                                (HeureRepas type) {
                                  return DropdownMenuItem<String>(
                                    value: type.type,
                                    child: Text(
                                      type.label,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            labelText: 'Selectionner une Date',
                          ),
                          initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
                          dateFormat: DateFormat.yMd(),
                          mode: DateTimeFieldPickerMode.date,
                          onChanged: (DateTime? value) {
                            newDate = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de la recette',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Lien de la recette',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newLink = value;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (type != null) {
                            if (newLink != null) {
                              var time = DateTime.parse(type!);
                              addItem(
                                newName,
                                newLink,
                                DateTime(newDate!.year , newDate!.month, newDate!.day, time.hour, time.minute),
                              );
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content:
                                        Text('Veuillez entrer un lien de recette.'),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner l\'heure de repas.'),
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
          );
        },
        child: Icon(Icons.add),
			)
              );
  }
}
