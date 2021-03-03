import 'package:cinema_mobile_flutter/aboutPage.dart';
import 'package:cinema_mobile_flutter/citiesPage.dart';
import 'package:cinema_mobile_flutter/menuItem.dart';
import 'package:cinema_mobile_flutter/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.blue[900])),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final menus = [
    {'title': 'Home', 'icon': Icon(Icons.home), 'page': citiesPage()},
    {'title': 'Settings', 'icon': Icon(Icons.settings), 'page': settingsPage()},
    {'title': 'About', 'icon': Icon(Icons.info), 'page': aboutPage()},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema Page"),
      ),
      body: Center(
        child: Text("Home Cinema ..."),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("./images/cinema.png"),
                  backgroundColor: Colors.transparent,
                  minRadius: 180,
                ),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue[900], Colors.blue[100]])),
            ),
            ...this.menus.map((item) {
              return new Column(
                children: <Widget>[
                  Divider(
                    color: Colors.blue[900],
                  ),
                  menuItem(item['title'], item['icon'], (context) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => item['page']));
                  })
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
