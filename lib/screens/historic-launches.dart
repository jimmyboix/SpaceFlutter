import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/launch.dart';
import 'package:intl/intl.dart';

class HistoricLaunches extends StatefulWidget {
  @override
  _HistoricLaunchesState createState() => _HistoricLaunchesState();
}

class _HistoricLaunchesState extends State {
  Future<List<Launch>> _launches;
  final String url = 'https://api.spacexdata.com/v3/launches/past?order=desc';
  final String nextURL = 'https://api.spacexdata.com/v3/launches/next';

  @override
  void initState() {
    super.initState();
    _launches = _fetchLaunches(url);
  }

  Future<List<Launch>> _fetchLaunches(theURL) async {
    var response = await http.get(theURL);

    if (response.statusCode == 200) {
      List<Launch> launches = new List<Launch>();
      var jsonParsed = json.decode(response.body.toString());

      if (jsonParsed is Map) {
        launches.add(new Launch.fromJSON(jsonParsed));
      } else {
        for (int i = 0; i < jsonParsed.length; i++) {
          launches.add(new Launch.fromJSON(jsonParsed[i]));
        }
      }
      return launches;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SpaceX History'),
          centerTitle: true,
        ),
        backgroundColor: Colors.blueGrey,
        body: new Container(
            child: FutureBuilder<List<Launch>>(
                builder: (BuildContext context,
                    AsyncSnapshot<List<Launch>> snapshot) {
                  return snapshot.hasData
                      ? buildBody(snapshot.data)
                      : buildSpinner();
                },
                future: _launches)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 585.0),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                elevation: 8.0,
                onPressed: () {
                  setState(() {
                    _launches = _fetchLaunches(nextURL);
                  });
                },
                child: Icon(Icons.navigate_next),
              ),
              FloatingActionButton(
                  mini: true,
                elevation: 8.0,
                onPressed: () {
                  setState(() {
                    _launches = _fetchLaunches(url);
                  });
                },
                child: Icon(Icons.navigate_before),
              )
            ],
          ),
        ));
  }

  Widget buildBody(List<Launch> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => buildCard(index, data),
    );
  }

  Widget buildSpinner() {
    return Center(
        child: Container(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
              strokeWidth: 6.0,
            )));
  }

  String getDate(int launchUnix) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(launchUnix * 1000);
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
    return formattedDate;
  }

  Color getColor(bool success) {
    switch (success) {
      case true:
        return Colors.green;
        break;
      case false:
        return Colors.red;
        break;
    }
  }

  Widget buildCard(index, List<Launch> data) {
    if (data.length > 0) {
      TextStyle text =
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
      TextStyle textBody =
          TextStyle(color: Colors.white, fontWeight: FontWeight.w300);
      return Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.all(10.0),
          elevation: 10.0,
          child: Container(
            color: getColor(data[index].launchSuccess),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: FloatingActionButton(
                  onPressed: () {
                    AlertDialog ad = AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Text('Mission Patch'),
                            padding: EdgeInsets.only(bottom: 20.0),
                          ),
                          Image.network(data[index].links.missionPatch),
                        ],
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ad;
                        });
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  child: new Image.network(data[index].links.missionPatchSmall,
                      fit: BoxFit.contain)),
              title: Text(
                  data[index].flightName.toString() +
                      ' (' +
                      data[index].flightNumber.toString() +
                      ')',
                  style: text),
              subtitle: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Text(getDate(data[index].launchDateInUNIX),
                        style: text),
                    padding: EdgeInsets.only(top: 5.0),
                  )),
                ]),
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                    child:
                        Text(data[index].details.toString(), style: textBody),
                    padding: EdgeInsets.only(top: 5.0),
                  )),
                ])
              ]),
            ),
          ));
    }
  }
}
