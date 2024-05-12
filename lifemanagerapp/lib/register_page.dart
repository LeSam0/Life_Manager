import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lifemanagerapp/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  @override
  void initState() {
    super.initState();
  }

  String newidentifiant = "";
  String newmotdepase = "";
  String checkmotdepasse = "";

  Future<void> Register(String identifant, String motdepasse) async {
    final url = Uri.parse('http://localhost:8000/register').replace(
      queryParameters: {
        'identifiant': identifant,
        'password': motdepasse,
      },
    );
    final response = await http.post(url);
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/');
    } else {
      throw Exception('Failed to update item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(
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
                'Veuillez vous enregistrer',
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
                    TextField(
                      decoration: InputDecoration(labelText: 'Vérification mot de passe'),
                      onChanged: (value) {
                        checkmotdepasse = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        if (newidentifiant.isNotEmpty && newidentifiant != null) {
                          if (newmotdepase.isNotEmpty && newmotdepase != null && checkmotdepasse.isNotEmpty && checkmotdepasse != null && newmotdepase == checkmotdepasse) {
                            Register(newidentifiant, newmotdepase);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Erreur'
                                  ),
                                  content: Text(
                                    'Les deux mot de passe ne sont pas identique.'
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
                      child: Text('S\'enregistrer'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), 
                        );
                      },
                      child: Text('Vous avez un compte ? Connectez-vous !'), 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}