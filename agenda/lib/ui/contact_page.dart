import 'dart:io';

import 'package:agenda/helpers/colors.dart';
import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  //Entre chaves é opcional
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = new Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      //Inicializando os valores dentro do form se o contato ja existir
      this._nameController.text = this._editedContact.name;
      this._emailController.text = this._editedContact.email;
      this._phoneController.text = this._editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Cols.red,
          title: Text(_editedContact.name ?? "New Contact"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            if (this._editedContact.name.isNotEmpty &&
                this._editedContact != null) {
              Navigator.pop(context, this._editedContact);
            } else {
              FocusScope.of(context).requestFocus(this._nameFocus);
            }
          },
          backgroundColor: Cols.red,
        ),
        backgroundColor: Colors.white,
        //Importante pra o teclado nao cobrir os campos de form
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: this._editedContact.img != null
                            ? FileImage(File(this._editedContact.img))
                            : AssetImage("images/user.png")),
                  ),
                ),
                onTap: () {
                  ImagePicker picker = new ImagePicker();
                  picker.getImage(source: ImageSource.camera).then((file) {
                    if (file == null) {
                      return;
                    } else {
                      setState(() {
                        this._editedContact.img = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                focusNode: this._nameFocus,
                controller: this._nameController,
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (text) {
                  this._userEdited = true;
                  setState(() {
                    this._editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: this._emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  this._userEdited = true;
                  this._editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: this._phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  this._userEdited = true;
                  this._editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => this._requestPop(),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard Changes?"),
              content: Text("Changes Will Be Lost"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Yes"))
              ],
            );
          });
      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }
}
