import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giphy/ui/colors.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=Ge2kX5DlqIhl7W6aTaphN8JKHrSNHIlu&limit=25&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=Ge2kX5DlqIhl7W6aTaphN8JKHrSNHIlu&q=$_search&limit=25&offset=$_offset&rating=g&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cols.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Cols.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search here",
                  labelStyle: TextStyle(color: Cols.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Cols.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
