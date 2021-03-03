import 'package:cinema_mobile_flutter/roomPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class cinemaPage extends StatefulWidget {
  dynamic city;

  cinemaPage(this.city);

  @override
  _cinemaPageState createState() => _cinemaPageState();
}

class _cinemaPageState extends State<cinemaPage> {
  List<dynamic> cinemaList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinemas of ${widget.city['name']}"),
      ),
      body: Center(
        child: (this.cinemaList == null)
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount:
                    (this.cinemaList == null) ? 0 : this.cinemaList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.redAccent[400],
                    child: RaisedButton(
                      color: Colors.redAccent,
                      child: Text(this.cinemaList[index]['name'],
                        style: TextStyle(color: Colors.white70,
                            fontSize: 20),),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>new roomPage(this.cinemaList[index])
                        ));
                      },
                    ),
                  );
                }),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCinemas();
  }

  void loadCinemas() {
    String url = this.widget.city['_links']['cinemas']['href'];
    http.get(url).then((resp) {
      setState(() {
        this.cinemaList = json.decode(resp.body)['_embedded']['cinemas'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
