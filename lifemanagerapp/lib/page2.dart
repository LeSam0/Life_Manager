
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:lifemanagerapp/total_item.dart';
import 'depense_item.dart';
import 'total_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

enum TypeDepence {
  futur('Futur', 'Futur'),
  anterieur('Antérieur', 'Antérieur');

  const TypeDepence(this.label, this.type);
  final String label;
  final String type;
}

class _Page2State extends State<Page2> {
  List<DepenseItem> depensesItems = [];

  List<DepenseItem> depensesFuturItems = [];
  List<TotalItem> total = [];
  List<Map<String, dynamic>> depensesCategories = [];
  List<Map<String, dynamic>> sousDepensesCategories = [];
  String? selectedCategoryId;
  String? selectedCategoryIdToAdd;
  String? selectedSousCategoryId;
  String? selectedSousCategoryIdToAdd;
  DateTime? dateDepence;
  String? type;
  List<DepenseItem> filtered_depensesItems = [];



  @override
  void initState() {
    super.initState();
    fetchDepensesCategories();
    fetchDepensesItems();
    fetchFuturDepensesItems();
    fetchTotal();
  }

  Future<void> fetchDepensesCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/depense/categorie'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        depensesCategories = data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['Id'].toString(),
                  'type': item['Categorie_Name'],
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> fetchDepensesSousCategories(int id_categorie) async {
    final url = Uri.parse('http://localhost:8000/depense/souscategorie').replace(
      queryParameters: {
        'id_categorie': depensesCategories[id_categorie-1]['id'],
      },
    );
    final response = await http.get(url);
        
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        sousDepensesCategories = data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['Id'].toString(),
                  'type': item['Categorie_Name'],
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> fetchTotal() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8000/depense/total'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        total = [
          TotalItem(
            total_with_futur: data['Total_With_Futur'] != null && data['Total_With_Futur'].toString().isNotEmpty
                ? double.parse(data['Total_With_Futur'].toString())
                : 0.0,
            total_without_futur: data['Total_Without_Futur'] != null && data['Total_Without_Futur'].toString().isNotEmpty
                ? double.parse(data['Total_Without_Futur'].toString())
                : 0.0,
          )
        ];
      });
    } else {
      throw Exception('Failed to load total');
    }
  } catch (error) {
    print('Error fetching total: $error');
  }
}



  Future<void> fetchDepensesItems() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/depense/get/all'));
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        depensesItems = data
            .map<DepenseItem>((item) => DepenseItem(
                  id : item['Id'].toString(),
                  name: item['Nom'].toString(),
                  montant: item['Montant'] != null &&
                            item['Montant'].toString().isNotEmpty
                        ? double.parse(item['Montant'].toString())
                        : 0.0,
                  date: DateTime.parse(item['Date'].toString()),
                  description: item['Description'].toString(),
                  sousCategorieId: item['Id_Sous_Categorie'].toString(),
                  sousCategorieName : item['Sous_Categorie_Name'].toString(),
                  categorieId : item['Id_Categorie'].toString(),
                  categorieName: item['Categorie_Name'].toString(),
                ))
            .toList();
      });
    } else {
        depensesItems = [];
    }
    } else {
      throw Exception('Failed to load articles');
    }
  }

    Future<void> fetchFuturDepensesItems() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/depense/futur/get/all'));
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        depensesFuturItems = data
            .map<DepenseItem>((item) => DepenseItem(
                  id : item['Id'].toString(),
                  name: item['Nom'].toString(),
                  montant: item['Montant'] != null &&
                            item['Montant'].toString().isNotEmpty
                        ? double.parse(item['Montant'].toString())
                        : 0.0,
                  date: DateTime.parse(item['Date'].toString()),
                  description: item['Description'].toString(),
                  sousCategorieId: item['Id_Sous_Categorie'].toString(),
                  sousCategorieName : item['Sous_Categorie_Name'].toString(),
                  categorieId : item['Id_Categorie'].toString(),
                  categorieName: item['Categorie_Name'].toString(),
                ))
            .toList();
      });
    } else {
        depensesItems = [];
    }
    } else {
      throw Exception('Failed to load articles');
    }
  }

    Future<void> addDepenseItem(String type, String name, double montant, DateTime date,
      String description, String sousCategorieId) async {
    if (type == "Antérieur") {
      final url = Uri.parse('http://localhost:8000/depense/create').replace(
        queryParameters: {
          'nomdepense': name,
          'montant': montant.toString(),
          'date': date.toString(),
          'description': description,
          'idsouscategorie': sousCategorieId,
        },
      );

      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchDepensesItems();
        fetchFuturDepensesItems();
      } else {
        throw Exception('Failed to add item');
      }
    } else if (type == "Futur") {
      final url = Uri.parse('http://localhost:8000/depense/futur/create').replace(
        queryParameters: {
          'nomdepense': name,
          'montant': montant.toString(),
          'date': date.toString(),
          'description': description,
          'idsouscategorie': sousCategorieId,
        },
      );

      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchDepensesItems();
        fetchFuturDepensesItems();
      } else {
        throw Exception('Failed to add item');
      }
    }
  }

    Future<void> SuppItem(String id) async {
    final urlNormal = Uri.parse('http://localhost:8000/depense/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final responseNormal = await http.delete(urlNormal);

    if (responseNormal.statusCode == 200) {
      fetchDepensesItems();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> _updateItem(String name, double montant, DateTime date,
      String description, String sousCategorieId) async {
    final url = Uri.parse('http://localhost:8000/depense/update').replace(
      queryParameters: {
        'nomdepense': name,
        'montant': montant.toString(),
        'date': date.toString(),
        'description': description,
        'idsouscategorie': sousCategorieId,
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchDepensesItems();
    } else {
      throw Exception('Failed to update item');
    }
  }

    Future<void> SuppFuturItem(String id) async {
    final urlNormal = Uri.parse('http://localhost:8000/depense/futur/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final responseNormal = await http.delete(urlNormal);

    if (responseNormal.statusCode == 200) {
      fetchFuturDepensesItems();
    } else {
      throw Exception('Failed to delete item');
    }
  }

   Future<void> _updateFuturItem(String name, double montant, DateTime date,
      String description, String sousCategorieId) async {
    final url = Uri.parse('http://localhost:8000/depense/futur/update').replace(
      queryParameters: {
        'nomdepense': name,
        'montant': montant.toString(),
        'date': date.toString(),
        'description': description,
        'idsouscategorie': sousCategorieId,
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchDepensesItems();
    } else {
      throw Exception('Failed to update item');
    }
  }

  Future<void> fetchDepensesByDay(String day) async {
  final response = await http.get(Uri.parse('http://localhost:8000/depense/get/jour?jour=$day'));

  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
       depensesItems = data.map<DepenseItem>((item) => DepenseItem(
        id: item['Id'].toString(),
        name: item['Nom'].toString(),
        montant: item['Montant'] != null && item['Montant'].toString().isNotEmpty
            ? double.parse(item['Montant'].toString())
            : 0.0,
        date: DateTime.parse(item['Date'].toString()),
        description: item['Description'].toString(),
        sousCategorieId: item['Id_Sous_Categorie'].toString(),
        sousCategorieName: item['Sous_Categorie_Name'].toString(),
        categorieId: item['Id_Categorie'].toString(),
        categorieName: item['Categorie_Name'].toString(),
      )).toList();
    });
    } else {
        depensesItems = [];
    }
  } else {
    throw Exception('Failed to load articles');
  }
}

Future<void> fetchDepensesByMonth(String month) async {
  final response = await http.get(Uri.parse('http://localhost:8000/depense/get/mois?mois=$month'));

  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      depensesItems = data.map<DepenseItem>((item) => DepenseItem(
        id: item['Id'].toString(),
        name: item['Nom'].toString(),
        montant: item['Montant'] != null && item['Montant'].toString().isNotEmpty
            ? double.parse(item['Montant'].toString())
            : 0.0,
        date: DateTime.parse(item['Date'].toString()),
        description: item['Description'].toString(),
        sousCategorieId: item['Id_Sous_Categorie'].toString(),
        sousCategorieName: item['Sous_Categorie_Name'].toString(),
        categorieId: item['Id_Categorie'].toString(),
        categorieName: item['Categorie_Name'].toString(),
      )).toList();
    });
    } else {
        depensesItems = [];
    }
  } else {
    throw Exception('Failed to load articles');
  }
}


Future<void> fetchDepensesByYear(String year) async {
  final response = await http.get(Uri.parse('http://localhost:8000/depense/get/annee?annee=$year'));

  if (response.statusCode == 200) {
    if (json.decode(response.body) != null) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      depensesItems = data.map<DepenseItem>((item) => DepenseItem(
        id: item['Id'].toString(),
        name: item['Nom'].toString(),
        montant: item['Montant'] != null && item['Montant'].toString().isNotEmpty
            ? double.parse(item['Montant'].toString())
            : 0.0,
        date: DateTime.parse(item['Date'].toString()),
        description: item['Description'].toString(),
        sousCategorieId: item['Id_Sous_Categorie'].toString(),
        sousCategorieName: item['Sous_Categorie_Name'].toString(),
        categorieId: item['Id_Categorie'].toString(),
        categorieName: item['Categorie_Name'].toString(),
      )).toList();
    });
    } else {
      depensesItems	= [];
    }
  } else {
    throw Exception('Failed to load articles');
  }
}


  @override
  Widget build(BuildContext context) {
        List<DepenseItem> filtered_depensesItems = selectedCategoryId != null
        ? depensesItems
            .where((item) => item.categorieId == selectedCategoryId)
            .toList()
        : depensesItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépenses'),
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
                  'Gestion des depenses',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
										),
							SizedBox(width: 580),
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
								Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.1,
          alignment: Alignment.centerLeft,
          child: DropdownButton<String>(
            value: selectedCategoryId,
            onChanged: (String? value) {
              setState(() {
                selectedCategoryId = value;
              });
            },
            items: depensesCategories.map<DropdownMenuItem<String>>((depensesCategories) {
              return DropdownMenuItem<String>(
                value: depensesCategories['id'],
                child: Text(
                  depensesCategories['type'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ), 
        
        Row(
          children: [
            IconButton(
  icon: Icon(Icons.filter_alt),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir le type de filtre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().add(Duration(days: -1830)),
                    lastDate: DateTime.now().add(Duration(days: 1830)),
                  );

                  if (pickedDate != null) {
                    final selectedDate = DateFormat('yyyy-dd-MM').format(pickedDate);
                    Navigator.of(context).pop();
                    fetchDepensesByDay(selectedDate);
                  }
                },
                child: Text('Filtrer par Jour'),
              ),

              ElevatedButton(
                onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().add(Duration(days: -1830)),
                  lastDate: DateTime.now().add(Duration(days: 1830)),
                );

                if (pickedDate != null) {
                  final selectedMonth = DateFormat('yyyy-MM').format(pickedDate);
                  Navigator.of(context).pop();
                  fetchDepensesByMonth(selectedMonth);
                }
              },
                child: Text('Filtrer par Mois'),
              ),
              ElevatedButton(
                onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().add(Duration(days: -1830)),
                  lastDate: DateTime.now().add(Duration(days: 1830)),
                );

                if (pickedDate != null) {
                  final selectedYear = DateFormat('yyyy').format(pickedDate);
                  Navigator.of(context).pop();
                  fetchDepensesByYear(selectedYear);
                }
              },

                child: Text('Filtrer par Année'),
              ),

            ],
          ),
        );
      },
    );
  },
),

            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
									selectedCategoryId = null;
                  fetchDepensesItems();
                  fetchFuturDepensesItems();
                  fetchTotal();
                });
              },
            ),
          ],
        ),
      ],
    ),
    Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: filtered_depensesItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                SuppItem(filtered_depensesItems[index].id);
              });
            },
            
            child: ListTile(
              title: Text(
                filtered_depensesItems[index].categorieName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sous-Categorie: ${filtered_depensesItems[index].sousCategorieName}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Nom: ${filtered_depensesItems[index].name}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Montant: ${filtered_depensesItems[index].montant.toString()} €',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(filtered_depensesItems[index].date)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Desciption: ${filtered_depensesItems[index].description.toString()}',
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
                        SuppItem(filtered_depensesItems[index].id);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
            context: context,
            builder: (BuildContext context) {
              String newName = filtered_depensesItems[index].name;
              double newMontant = filtered_depensesItems[index].montant;
              String newDescription = filtered_depensesItems[index].description;
              dateDepence = filtered_depensesItems[index].date;
              selectedCategoryIdToAdd = depensesFuturItems[index].categorieId;
              selectedSousCategoryIdToAdd = depensesFuturItems[index].sousCategorieId;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Modifier un élément à vos depenses'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          hint: selectedCategoryIdToAdd == null
                              ? Text('Sélectionner une catégorie')
                              : null,
                          value: selectedCategoryIdToAdd,
                          onChanged: (String? value) {
                            setState(() {
                              fetchDepensesSousCategories(int.parse(value!));
                              selectedCategoryIdToAdd = value;
                            });
                          },
                          items: depensesCategories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(
                                  category['type'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                              },
                          ).toList(),
                        ),
                          DropdownButton<String>(
                          hint: selectedSousCategoryIdToAdd == null
                              ? Text('Sélectionner une sous catégorie')
                              : null,
                          value: selectedSousCategoryIdToAdd,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSousCategoryIdToAdd = value;
                            });
                          },
                          items: sousDepensesCategories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(
                                  category['type'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Montant',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newMontant = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          controller: TextEditingController(text: newMontant.toString()),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'élément',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newName = value;
                          },
                          controller: TextEditingController(text: newName),
                        ),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            labelText: 'Selectionner une Date',
                          ),
                          initialPickerDateTime: dateDepence,
                          dateFormat: DateFormat.yMd(),
                          mode: DateTimeFieldPickerMode.date,
                          onChanged: (DateTime? value) {
                            dateDepence = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newDescription = value;
                          },
                          controller: TextEditingController(text: newDescription),
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
                          if (selectedCategoryIdToAdd != null) {
                              _updateFuturItem(
                                newName,
                                newMontant,
                                dateDepence!,
                                newDescription,
                                selectedSousCategoryIdToAdd!,
                              );
                              Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une catégorie.'),
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
                  ),
                ],
              ),
            ),
          );
        },
			),
		),
		
	],
      ),
			SizedBox(width: 45),
			Container(
			child: Column(
      children: [
							SizedBox(height: 30),
      Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child:ListTile (
      title : Text(
                'Total de dépense sans futur dépence',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
      subtitle: Text(
               '${total.isNotEmpty ? total[0].total_without_futur.toString() : '0.0'} €',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
        )
      ),
      Container(
			child: Column(
      children: [
							SizedBox(height: 40),
      Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child:
      ListTile (
      title : Text(
                'Total de dépense avec futur dépence',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
      subtitle: Text(
               '${total.isNotEmpty ? total[0].total_with_futur.toString() : 'N/A'} €',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
        )
      ),
      SizedBox(height: 15),
			Text(
                    'Futur Depense',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ), 
							SizedBox(height: 20),

			Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: depensesFuturItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                SuppFuturItem(depensesFuturItems[index].id);
              });
            },
            
            child: ListTile(
              title: Text(
                depensesFuturItems[index].categorieName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sous-Categorie: ${depensesFuturItems[index].sousCategorieName}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Nom: ${depensesFuturItems[index].name}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Montant: ${depensesFuturItems[index].montant.toString()} €',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(depensesFuturItems[index].date)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Desciption: ${depensesFuturItems[index].description.toString()}',
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
                        SuppFuturItem(depensesFuturItems[index].id);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
            context: context,
            builder: (BuildContext context) {
              String newName = depensesFuturItems[index].name;
              double newMontant = depensesFuturItems[index].montant;
              String newDescription = depensesFuturItems[index].description;
              dateDepence = depensesFuturItems[index].date;
              selectedCategoryIdToAdd = depensesFuturItems[index].categorieId;
              selectedSousCategoryIdToAdd = depensesFuturItems[index].sousCategorieId;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Modifier un élément à vos depenses'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          hint: selectedCategoryIdToAdd == null
                              ? Text('Sélectionner une catégorie')
                              : null,
                          value: selectedCategoryIdToAdd,
                          onChanged: (String? value) {
                            setState(() {
                              fetchDepensesSousCategories(int.parse(value!));
                              selectedCategoryIdToAdd = value;
                            });
                          },
                          items: depensesCategories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(
                                  category['type'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                              },
                          ).toList(),
                        ),
                          DropdownButton<String>(
                          hint: selectedSousCategoryIdToAdd == null
                              ? Text('Sélectionner une sous catégorie')
                              : null,
                          value: selectedSousCategoryIdToAdd,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSousCategoryIdToAdd = value;
                            });
                          },
                          items: sousDepensesCategories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(
                                  category['type'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Montant',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newMontant = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          controller: TextEditingController(text: newMontant.toString()),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'élément',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newName = value;
                          },
                          controller: TextEditingController(text: newName),
                        ),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            labelText: 'Selectionner une Date',
                          ),
                          initialPickerDateTime: dateDepence,
                          firstDate: DateTime.now(),
                          dateFormat: DateFormat.yMd(),
                          mode: DateTimeFieldPickerMode.date,
                          onChanged: (DateTime? value) {
                            dateDepence = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newDescription = value;
                          },
                          controller: TextEditingController(text: newDescription),
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
                          if (selectedCategoryIdToAdd != null) {
                              _updateFuturItem(
                                newName,
                                newMontant,
                                dateDepence!,
                                newDescription,
                                selectedSousCategoryIdToAdd!,
                              );
                              Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une catégorie.'),
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
                  ),
                ],
              ),
            ),
          );
        },
			),
		),
			]
			)
		),
],
    ),
                   )],
),

			
        ]),
					),
					
      )],
			),
			floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newName = '';
              double newMontant = 0.0;
              String newDescription = '';
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Ajouter un élément à vos depenses'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                              hint: type == null
                                  ? Text('Sélectionner le type de dépense')
                                  : null,
                              value: type,
                              onChanged: (String? value) {
                                setState(() {
                                  type = value;
                                });
                              },
                              items: TypeDepence.values.map<DropdownMenuItem<String>>(
                                (TypeDepence type) {
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
                            DropdownButton<String>(
                              hint: selectedCategoryIdToAdd == null
                                  ? Text('Sélectionner une catégorie')
                                  : null,
                              value: selectedCategoryIdToAdd,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCategoryIdToAdd = value;
                                  selectedSousCategoryIdToAdd = null;
                                  fetchDepensesSousCategories(int.parse(value!)); 
                                });
                              },
                              items: depensesCategories.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> category) {
                                  return DropdownMenuItem<String>(
                                    value: category['id'],
                                    child: Text(
                                      category['type'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            DropdownButton<String>(
                              hint: selectedSousCategoryIdToAdd == null
                                  ? Text('Sélectionner une sous catégorie')
                                  : null,
                              value: selectedSousCategoryIdToAdd,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSousCategoryIdToAdd = value;
                                });
                              },
                              items: sousDepensesCategories.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> category) {
                                  return DropdownMenuItem<String>(
                                    value: category['id'],
                                    child: Text(
                                      category['type'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Montant',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newMontant = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'élément',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            labelText: 'Selectionner une Date',
                          ),
                          initialPickerDateTime: DateTime.now(),
                          dateFormat: DateFormat.yMd(),
                          mode: DateTimeFieldPickerMode.date,
                          onChanged: (DateTime? value) {
                            dateDepence = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newDescription = value;
                          },
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
                          if (type == "Antérieur"){
                            if (selectedCategoryIdToAdd != null) {
                              addDepenseItem(
                                type!,
                                newName,
                                newMontant,
                                dateDepence!,
                                newDescription,
                                selectedSousCategoryIdToAdd!,
                              );
                              Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une catégorie.'),
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
                          if (type == "Futur" && dateDepence!.isAfter(DateTime.now())){
                          if (selectedCategoryIdToAdd != null) {
                              addDepenseItem(
                                type!,
                                newName,
                                newMontant,
                                dateDepence!,
                                newDescription,
                                selectedSousCategoryIdToAdd!,
                              );
                              Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erreur'),
                                  content: Text(
                                      'Veuillez sélectionner une catégorie.'),
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
                                      'Veuillez sélectionner une date après la date du jour pour une depense futur.'),
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

