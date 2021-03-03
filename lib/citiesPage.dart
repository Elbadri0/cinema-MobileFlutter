import 'dart:developer';

import 'package:cinema_mobile_flutter/GlobalVariables.dart';
import 'package:cinema_mobile_flutter/cinemaPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class citiesPage extends StatefulWidget {
  @override
  _citiesPageState createState() => _citiesPageState();
}

class _citiesPageState extends State<citiesPage> {
  List<dynamic> cityList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Villes"),
      ),
      body: Center(
        child: this.cityList == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: (this.cityList == null) ? 0 : cityList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue[900],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RaisedButton(
                        color: Colors.blue[900],
                        child: Text(this.cityList[index]['name'] ,
                        style: TextStyle(color: Colors.white,
                        fontSize: 20),
                        ),


                        onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context)=>new cinemaPage(cityList[index])
                          ));
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCities();
  }

  void loadCities() {
    String url = GlobalData.host+"/villes";
    http.get(url).then((resp) {
      setState(() {
        String body = utf8.decode(resp.bodyBytes);
        this.cityList = json.decode(body)['_embedded']['villes'];
      });
    }).catchError((err) {});
  }
}
