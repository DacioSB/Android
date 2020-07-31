import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/all/USD-BRL,EUR-BRL";

main(List<String> args) async {
  //Posso fazer um callback

  runApp(new MaterialApp(
    home: new Home(),
    theme: ThemeData(
        hintColor: _HomeState.orange,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _HomeState.orange)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _HomeState.pink)),
          hintStyle: TextStyle(color: _HomeState.pink),
        )),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realController = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController = TextEditingController();

  double _dolar;
  double _euro;
  static Color orange = new Color(0xfff37121);
  static Color purple = new Color(0xff111d5e);
  static Color orangeB = new Color(0xffffbd69);
  static Color pink = new Color(0xffc70039);

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    this._dolarController.text = (real / this._dolar).toStringAsFixed(2);
    this._euroController.text = (real / this._euro).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double doleta = double.parse(text);
    this._realController.text = (doleta * this._dolar).toStringAsFixed(2);
    this._euroController.text =
        ((doleta * this._dolar) / this._euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euroo = double.parse(text);
    this._realController.text = (euroo * this._euro).toStringAsFixed(2);
    this._dolarController.text =
        ((euroo * this._euro) / this._dolar).toStringAsFixed(2);
  }

  void _clearAll() {
    this._realController.text = "";
    this._dolarController.text = "";
    this._euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      appBar: AppBar(
        title: Text("\$Conversor\$"),
        backgroundColor: orange,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: orangeB,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "${snapshot.error}",
                      style: TextStyle(
                        color: orangeB,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  this._dolar = double.parse(snapshot.data["USD"]["bid"]);
                  this._euro = double.parse(snapshot.data["EUR"]["bid"]);
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: orange,
                        ),
                        buildTextField(
                            "Reais", "R\$", this._realController, _realChange),
                        Divider(),
                        buildTextField("Dólares", "\$", this._dolarController,
                            _dolarChange),
                        Divider(),
                        buildTextField(
                            "Euros", "€", this._euroController, _euroChange),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function func) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: _HomeState.pink,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: _HomeState.pink,
      fontSize: 25,
    ),
    onChanged: func,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
