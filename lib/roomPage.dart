import 'package:cinema_mobile_flutter/GlobalVariables.dart';
import 'package:cinema_mobile_flutter/roomPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class roomPage extends StatefulWidget {
  dynamic cinema;

  roomPage(this.cinema);

  @override
  _roomPageState createState() => _roomPageState();
}

class _roomPageState extends State<roomPage> {
  List<dynamic> roomList;
  List<int> selectedTickets = new List<int>();
  final clientNameController = TextEditingController();
  final paymentCodeController = TextEditingController();


  @override
  void dispose() {
    clientNameController.dispose();
    paymentCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rooms of ${widget.cinema['name']}"),
      ),
      body: Center(
        child: (this.roomList == null)
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: (this.roomList == null) ? 0 : this.roomList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.purple[100],
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Colors.purple,
                              child: Text(
                                this.roomList[index]['name'],
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 20),
                              ),
                              onPressed: () {
                                loadProjections(this.roomList[index]);
                              },
                            ),
                          ),
                        ),
                        if (this.roomList[index]['projections'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.network(
                                  GlobalData.host +
                                      "/imageFilm/${this.roomList[index]['currentProjection']['film']['id']}",
                                  width: 150,
                                  height: 250,
                                ),
                                Column(
                                  children: <Widget>[
                                    ...(this.roomList[index]['projections']
                                            as List<dynamic>)
                                        .map((projection) {
                                      return RaisedButton(
                                        color: (this.roomList[index]
                                                        ['currentProjection']
                                                    ['id'] ==
                                                projection['id'])
                                            ? Colors.purple[900]
                                            : Colors.purple[200],
                                        child: Text(
                                          "${projection['seance']['heureDebut']}"
                                              .substring(0, "${projection['seance']['heureDebut']}".length - 3) +
                                              " => Price : ${projection['prix']}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          loadTickets(
                                              projection, this.roomList[index]);
                                        },
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                          ),
                        if (this.roomList[index]['currentProjection'] != null &&
                            this.roomList[index]['currentProjection']['listTickets'] != null &&
                            this.roomList[index]['currentProjection']['listTickets'].length > 0)
                          Column(
                            children: <Widget>[
                            /*  Container(
                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                child: Row(

                                  children: <Widget>[
                                    Text("Total Available Seats : ${this.roomList[index]['currentProjection']['totalAvailableSeats']}"),
                                  ],
                                ),
                              ),*/
                              if(selectedTickets.length>0)
                              Container(
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                child: TextField(
                                  decoration: InputDecoration(hintText: 'Your name',hintStyle: TextStyle(color: Colors.black,fontSize: 20)),
                                  controller: clientNameController,

                                ),
                              ),
                              if(selectedTickets.length>0)
                              Container(
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 3),
                                child: TextField(
                                  decoration: InputDecoration(hintText: 'Payment Code',hintStyle: TextStyle(color: Colors.black,fontSize: 20)),
                                  controller: paymentCodeController,
                                ),
                              ),
                              if(selectedTickets.length>0)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 6),
                                child: RaisedButton(
                                  child: Text("Book Seats"),
                                  onPressed: (){
                                    setState(() {
                                      buyTickets(clientNameController.text,paymentCodeController.text,selectedTickets,index);
                                    });


                                  },
                                ),
                              ),
                              Wrap(
                                children: <Widget>[
                                  ...this.roomList[index]['currentProjection']['tickets'].map((ticket) {
                                    if(ticket['reservee']==false) {
                                      return Container(
                                        width: 50,
                                        padding: EdgeInsets.all(2),

                                          child: RaisedButton(

                                            color: (ticket['selected']!=null && ticket['selected']==true)?Colors.purpleAccent:Colors.purpleAccent[100],
                                            child: Text(
                                                "${ticket['seat']['number']}",

                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                                          onPressed: (){
                                              setState(() {
                                                if(ticket["selected"]!=null && ticket["selected"]==true){
                                                    ticket["selected"] = false;
                                                    selectedTickets.remove(ticket['id']);
                                                }
                                                else{
                                                  ticket['selected'] = true;
                                                  selectedTickets.add(ticket['id']);
                                                }
                                              });


                                          },

                                          ),

                                      );
                                    }
                                    else return Container();
                                  })
                                ],
                              ),
                            ],
                          ),
                      ],
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
    loadRooms();
  }

  void loadRooms() {
    String url = this.widget.cinema['_links']['salles']['href'];
    http.get(url).then((resp) {
      setState(() {
        String body = utf8.decode(resp.bodyBytes);
        this.roomList = json.decode(body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(room) {
    String url = room['_links']['projections']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p1");
    http.get(url).then((resp) {
      setState(() {
        room['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        room['currentProjection'] = room['projections'][0];
        room['currentProjection']['tickets'] = [];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTickets(projection, room) {
    String url = projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=ticketProj");
    http.get(url).then((resp) {
      setState(() {
        projection['listTickets'] = json.decode(resp.body)['_embedded']['tickets'].where((ticket)=>ticket["reservee"] == false);
        room['currentProjection'] = projection;
        projection['totalAvailableSeats'] = countAvailableSeats(projection);
        print(countAvailableSeats(projection));
        print("total= "+countAvailableSeats(projection).toString());
      });
    }).catchError((err) {
      print(err);
    });
  }

  int countAvailableSeats(projection) {
    int count = 0;
    for (int i = 0; i < projection['tickets'].length; i++) {
      if (projection['tickets'][i]['reservee'] == false)
        count++;
    }
    return count;
  }

  void buyTickets(clientName , paymentCode , tickets , index) {
      Map data={"nomClient":clientName ,"codePayment":paymentCode, "tickets" : tickets};
      String body=json.encode(data);
      http.post(GlobalData.host+"/payerTickets",headers: {"Content-Type": "application/json"} , body: body)
        .then((value) => loadTickets(this.roomList[index]["currentProjection"],this.roomList[index]))
          .catchError((err) {
        print(err);
      });

      selectedTickets= new List<int>();
      loadProjections(this.roomList[index]);
  }
}
