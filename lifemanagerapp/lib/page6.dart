import 'package:flutter/material.dart';
import 'login_item.dart';
import 'motdepasse_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_item.dart';

class Page6 extends StatefulWidget {
  const Page6({Key? key}) : super(key: key);

  @override
  _Page6State createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  List<UserItem> userItems = [];
  List<MotDePasseItem> randomMdp = [];

  @override
  void initState() {
    super.initState();
    fetchLogins();
  }


   Future<void> regenRSA() async {
    final url = Uri.parse('http://localhost:8000/rsa');
      final response = await http.post(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to change rsa: ${response.statusCode}');
      }
  }

  Future<void> fetchLogins() async {
  final response = await http.get(Uri.parse('http://localhost:8000/login'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      userItems = data
          .map<UserItem>((item) => UserItem(
                id: item['Id'].toString(),
                identifiant: item['Identifiant'].toString(),
                password: item['Password'].toString(),
              ))
          .toList();
    });
  } else {
    throw Exception('Failed to load logins');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
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
                  'Profil',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
										),
							SizedBox(width: 865),
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
								SizedBox(width: 150),
                   Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Identifiant'),
                                controller: TextEditingController(text: userItems.isNotEmpty ? userItems[0].identifiant : ""),
                                enabled: false, 
                              ),
                              SizedBox(height: 20),

                              SizedBox(height: 20),
                               TextField(
                                                    decoration: InputDecoration(labelText: 'Code coffre fort'),
                                                    onChanged: (value) {
                                                      value = value;
                                                    },
                                                     controller: TextEditingController(text: ""),
                                                  ),
                              TextButton(
                                onPressed: () {
                                  if (1 == 1) {
                                    // _updateItem(
                                    //   calendardayItems[index].id, 
                                    //   eventName,
                                    //   date!,
                                    // );
                                    Navigator.of(context).pop();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Erreur'),
                                          content: Text('Veuillez sélectionner une date.'),
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
                                child: Text('Modifier'),
                              ),
                            ],
                          )
                                      
      )
                   )])]),


			SizedBox(width: 191),
			Container(
			child: Column(
      children: [
			Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 216, 216),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
			child : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
                        onPressed: () {
                          regenRSA();
                        },
            style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                            horizontal: MediaQuery.of(context).size.width * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
            icon: Icon(Icons.key),
            label: const Text('Regénérer clé RSA'),
          ),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/page3');
                        },
            style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                            horizontal: MediaQuery.of(context).size.width * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
            icon: Icon(Icons.key),
            label: const Text('Courses'),
          ),
          ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
            style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                            horizontal: MediaQuery.of(context).size.width * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
            icon: Icon(Icons.logout),
            label: const Text('Déconnection'),
          ),
        ],
      )
			)
			]
			)
		),
],
    ),
  ],
),
			))]));
  }
}
