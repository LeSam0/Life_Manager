import 'package:flutter/material.dart';
import 'package:lifemanagerapp/register_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_item.dart';
import 'package:intl/intl.dart';


class LifeManager extends StatelessWidget {
  const LifeManager({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/page1': (context) => const Page1(),
        '/page2': (context) => const Page2(),
        '/page3': (context) => const Page3(),
        '/page4': (context) => const Page4(),
        '/page5': (context) => const Page5(),
        '/page6': (context) => const Page6(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

 @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<CalendarItem> calendarItems = [];

  @override
  void initState() {
    super.initState();
    fetchEvent();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeManager'),
      ),
      body: Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
                SizedBox(width: 20),
                Text(
                  'Bienvenue sur votre life manager',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                							SizedBox(width: constraints.maxWidth* 0.1),
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(2022, 1, 1),
                      lastDay: DateTime(2025, 12, 31),
                      headerVisible: false,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        selectedDecoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.red),
                        weekendStyle: TextStyle(color: Colors.green),
                      ),
                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(fontSize: 20),
                      ),
                      rowHeight: MediaQuery.of(context).size.height * 0.1,
                      daysOfWeekHeight:
                          MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),
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
                      child: Text(
                        'Prochains événements',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: calendarItems.length > 6 ? 6 : calendarItems.length, 
                        itemBuilder: (context, index) {
                          calendarItems.sort((a, b) => a.eventDate.compareTo(b.eventDate));
                          final limitedList = calendarItems.take(10).toList();          
                          return Center(
                            child: Column(
                              children: [
                                Dismissible(
                                  key: UniqueKey(),
                                  child: ListTile(
                                    title: Text(
                                      limitedList[index].eventName, 
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${DateFormat('dd/MM/yyyy').format(limitedList[index].eventDate)}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          );
                        }
                      )
                    )
                  ]
                ))])]));})));}
  }

  
