import 'package:flutter/material.dart';
import 'login_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'motdepasse_item.dart';

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  List<LoginItem> loginItems = [];
  List<MotDePasseItem> randomMdp = [];
  List<MotDePasseItem> AfficheMdp = [];

  @override
  void initState() {
    super.initState();
    fetchLogins();
  }

  Future<void> addItem(
      String nomapp, String identifiant, String motdepasse) async {
    final url = Uri.parse('http://localhost:8000/login/create').replace(
      queryParameters: {
        'nomapp': nomapp,
        'identifiant': identifiant,
        'motdepasse': motdepasse,
      },
    );

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        fetchLogins();
      } else {
        throw Exception('Failed to add item: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding item: $error');
      throw Exception('Failed to add item: $error');
    }
  }

  Future<void> fetchLogins() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/login/get'));
    if (response.statusCode == 200) {
      if (json.decode(response.body) != null) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        loginItems = data
            .map<LoginItem>((item) => LoginItem(
                  id: item['Id'].toString(),
                  nomapp: item['NomApp'].toString(),
                  identifiant: item['Identifiant'].toString(),
                  motdepasse: item['MotDePasse'].toString(),
                ))
            .toList();
      });
      } else {
        loginItems = [];
      }
    } else {
      throw Exception('Failed to load logins');
    }
  }

  Future<void> SuppItem(String id) async {
    final url = Uri.parse('http://localhost:8000/login/delete').replace(
      queryParameters: {
        'id': id,
      },
    );

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      fetchLogins();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  void fetchRandomPassword() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/login/motdepasse'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        randomMdp = [ MotDePasseItem(
                  RandomMdp: data['MotDePasse'].toString(),
                )];
      });
    } else {
      throw Exception('Failed to load random password');
    }
  }

  Future<void> _updateItem(
      String id, String newName, String identifiant, String mdp) async {
    final url = Uri.parse('http://localhost:8000/login/update').replace(
      queryParameters: {
        'id': id,
        'nomapp': newName,
        'identifiant': identifiant.toString(),
        'motdepasse': mdp.toString(),
      },
    );

    final response = await http.put(url);
    if (response.statusCode == 200) {
      fetchLogins();
    } else {
      throw Exception('Failed to update item');
    }
  }


  @override
  Widget build(BuildContext context) {
     List<MotDePasseItem> AfficheMdp = randomMdp != null && randomMdp.isNotEmpty
        ? randomMdp
        : [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sécurité'),
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
                  'Coffre Fort et Gestionnaire de Mot de Passe',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
										),
							SizedBox(width: 164),
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
                        label: const Text('Courses'),
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
      Column( 
        children: [
        Container(
      width: MediaQuery.of(context).size.width * 0.30,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child:
      Text(
                'Coffre fort sécurisé',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
      ),
      SizedBox(height: 20,),
    Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Container()
    )
      ])]), 
  ]),



			SizedBox(width: 40),
      Column(
        children: [
      Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child:
      Text(
                'Liste de vos identifiants',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
            ),
      ),
      SizedBox(height: 20,),
			Container(
			child: Column(
      children: [
			Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
			child : 
        ListView.builder(
        itemCount: loginItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                SuppItem(loginItems[index].id);
              });
            },
            
            child: ListTile(
              title: Text(
                loginItems[index].nomapp,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Identifiant: ${loginItems[index].identifiant}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Mot De Passe: ${loginItems[index].motdepasse.toString()}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                             IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
            context: context,
            builder: (BuildContext context) {
              String newNameapp = loginItems[index].nomapp.toString();
              String newidentifiant = loginItems[index].identifiant.toString();
              String newmdp = loginItems[index].motdepasse.toString();
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Modifier l\'éléments'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'app',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newNameapp = value;
                          },
                          controller: TextEditingController(text: newNameapp.toString()),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Identifiant',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newidentifiant = value;
                          },
                          controller: TextEditingController(text: newidentifiant.toString()),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Mot de Passe',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newmdp =  value;
                          },
                          controller: TextEditingController(text: '${AfficheMdp.isNotEmpty ? AfficheMdp[0].RandomMdp.toString() : newmdp}'),
                        ),
                        ElevatedButton(
                        onPressed: () {
                              fetchRandomPassword();
                          },
                        child: Text('Générer un mot de passe aléatoire'),
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
                          if (newmdp != null) {
                            if (newidentifiant != null) {
                              _updateItem(
                                loginItems[index].id,
                                newNameapp,
                                newidentifiant,
                                newmdp,
                              );
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content:
                                        Text('Veuillez entrer un mot de passe.'),
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
                                      'Veuillez entre un identifiant.'),
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
                        child: Text('Modifer'),
                      ),
                    ],
                  );
                },
              );
            },
          );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      SuppItem(
                                        loginItems[index].id,
                                      );
                                    });
                                  },
                                ),
                ],
              ),
            ),
          );
        },
			),
      )
      ]
			)
		),
],
    ),
  ],
),
			])))]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newNameapp = '';
              String newidentifiant = '';
              String newmdp = '';
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Ajouter un élément'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nom de l\'app',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newNameapp = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Identifiant',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newidentifiant = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Mot de Passe',
                              labelStyle: TextStyle(fontSize: 14)),
                          onChanged: (value) {
                            newmdp =  value;
                          },
                          controller: TextEditingController(text: '${AfficheMdp.isNotEmpty ? AfficheMdp[0].RandomMdp.toString() : ""}'),
                        ),
                        ElevatedButton(
                        onPressed: () {
                              fetchRandomPassword();
                          },
                        child: Text('Générer un mot de passe aléatoire'),
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
                          if (newmdp != null) {
                            if (newidentifiant != null) {
                              addItem(
                                newNameapp,
                                newidentifiant,
                                newmdp,
                              );
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content:
                                        Text('Veuillez entrer un mot de passe.'),
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
                                      'Veuillez entre un identifiant.'),
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
