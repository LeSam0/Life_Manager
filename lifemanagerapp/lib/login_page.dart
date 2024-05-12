import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'error_item.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  void initState() {
    super.initState();
  }

  String newidentifiant = "";
  String newmotdepase = "";
  List<ErrorItem> error = [];

  Future<void> login(String identifant, String motdepasse) async {
    final url = Uri.parse('http://localhost:8000/login').replace(
      queryParameters: {
        'identifiant': identifant,
        'password': motdepasse,
      },
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        error = [ ErrorItem(
                  error: data['Error'].toString(),
                )];
        });
      if ('${error.isNotEmpty ? error[0].error.toString() : "error"}' == 'badident') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Erreur'
              ),
              content: Text(
                'Identifiant incorrect.'
              ),
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
      } else if ('${error.isNotEmpty ? error[0].error.toString() : "error"}' == 'badmdp'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Erreur'
              ),
              content: Text(
                'Mot de passe incorrect.'
              ),
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
      } else if ('${error.isNotEmpty ? error[0].error.toString() : "error"}' == 'ok'){
        Navigator.pushNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Erreur'
              ),
              content: Text(
                'Une erreur est survenu, veuillez rééssayer.'
              ),
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
      throw Exception('Failed to update item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [ 
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              Text(
                'Bienvenue sur votre life manager',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Veuillez vous connecter',
                style: TextStyle(
                fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60,),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
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
                    TextField(
                      decoration: InputDecoration(labelText: 'Identifiant'),
                      onChanged: (value) {
                        newidentifiant = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      onChanged: (value) {
                        newmotdepase = value;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (newidentifiant.isNotEmpty && newidentifiant != null) {
                          if (newmotdepase.isNotEmpty && newmotdepase != null) {
                            login(newidentifiant, newmotdepase);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Erreur'
                                  ),
                                  content: Text(
                                    'Veuillez entrer un identifiant.'
                                  ),
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
                                title: Text(
                                  'Erreur'
                                ),
                                content: Text(
                                  'Veuillez entrer un identifiant.'
                                ),
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
                      child: Text('Connexion'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()), 
                        );
                      },
                      child: Text('Vous n\'avez pas de compte ? Inscrivez-vous !'), 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
