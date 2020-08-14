import 'dart:io';

import 'package:agenda/helpers/colors.dart';
import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = new ContactHelper();
  List<Contact> _contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        this._contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Sort A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Sort Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
        title: Text("Contacts"),
        backgroundColor: Cols.red,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: this._contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
        padding: EdgeInsets.all(10.0),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Cols.red,
      ),
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        this._contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        this._contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: this._contacts[index].img != null
                          ? FileImage(File(this._contacts[index].img))
                          : AssetImage("images/user.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this._contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      _contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              launch("tel:${this._contacts[index].phone}");
                            },
                            child: Text(
                              "Call",
                              style:
                                  TextStyle(color: Cols.green, fontSize: 20.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: this._contacts[index]);
                            },
                            child: Text(
                              "Edit",
                              style:
                                  TextStyle(color: Cols.green, fontSize: 20.0),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                helper.deleteContact(this._contacts[index].id);
                                this._contacts.removeAt(index);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              "Exclude",
                              style:
                                  TextStyle(color: Cols.green, fontSize: 20.0),
                            )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      this._getAllContacts();
    }
  }
}
