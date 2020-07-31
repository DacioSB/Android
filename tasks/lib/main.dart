import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(new MaterialApp(
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color _darkBlue = new Color(0xff0a97b0);
  final Color _lightBlue = new Color(0xff4cd3c2);
  final Color _pink = new Color(0xfff54291);
  final Color _lightPink = new Color(0xfffaeee7);

  final _toDoController = TextEditingController();

  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._readData().then((value) {
      setState(() {
        _toDoList = json.decode(value);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = new Map();
      newToDo["title"] = _toDoController.text;
      this._toDoController.text = "";
      newToDo["ok"] = false;
      this._toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/jason.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget buildItem(context, index) {
    return Dismissible(
      background: Container(
        color: this._lightBlue,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: this._lightPink,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        onChanged: (check) {
          setState(() {
            this._toDoList[index]["ok"] = check;
            _saveData();
          });
        },
        activeColor: this._darkBlue,
        title: Text(this._toDoList[index]["title"]),
        value: this._toDoList[index]["ok"],
        secondary: CircleAvatar(
          backgroundColor: _toDoList[index]["ok"] ? this._darkBlue : this._pink,
          child: Icon(
            _toDoList[index]["ok"] ? Icons.check : Icons.error,
            color: this._lightPink,
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          this._lastRemoved = Map.from(this._toDoList[index]);
          _lastRemovedPos = index;
          this._toDoList.removeAt(index);
          _saveData();
          final snack = SnackBar(
            content: Text("Tarefa \"${this._lastRemoved["title"]}\" removida"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    this._toDoList.insert(_lastRemovedPos, _lastRemoved);
                    this._saveData();
                  });
                }),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<void> _refresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {
      this._toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) {
          return 1;
        } else if (!a["ok"] && b["ok"]) {
          return -1;
        } else {
          return 0;
        }
      });
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: this._lightPink,
      appBar: AppBar(
        title: Text("Task List"),
        backgroundColor: this._darkBlue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: this._toDoController,
                    decoration: InputDecoration(
                      labelText: "New Task",
                      labelStyle: TextStyle(color: this._darkBlue),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: this._addToDo,
                  color: this._darkBlue,
                  child: Text("ADD"),
                  textColor: this._lightPink,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: this._toDoList.length,
                    itemBuilder: buildItem,
                  ),
                  onRefresh: _refresh))
        ],
      ),
    );
  }
}
