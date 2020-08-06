import 'package:flutter/material.dart';
import 'package:giphy/ui/colors.dart';
import 'package:share/share.dart';

class Gif extends StatelessWidget {
  //const Gif({Key key}) : super(key: key);

  final Map _gifData;

  Gif(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._gifData["title"],
          style: TextStyle(color: Cols.white),
        ),
        backgroundColor: Cols.black,
        iconTheme: IconThemeData(color: Cols.white),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(this._gifData["images"]["fixed_height"]["url"]);
              })
        ],
      ),
      backgroundColor: Cols.black,
      body: Center(
        child: Image.network(this._gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
