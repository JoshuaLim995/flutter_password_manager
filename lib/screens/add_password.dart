import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:password_manager/controller/passwords_hive.dart';

class AddNewPassword extends StatefulWidget {
  @override
  _AddNewPasswordState createState() => _AddNewPasswordState();
}

class _AddNewPasswordState extends State<AddNewPassword> {
  late PasswordHive _passwordHive;
  String? _type;
  String? _email;
  String? _password;
  final _formKey = GlobalKey<FormState>();

  inputText(String labelText, String? hintText, Function onChanged,
      [bool end = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        style: TextStyle(
          fontSize: 18.0,
        ),
        onChanged: (val) => onChanged(val),
        validator: (val) {
          if (val!.trim().isEmpty) {
            return "Enter A Value !";
          } else {
            return null;
          }
        },
        autofocus: true,
        textInputAction: end ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: end ? (_) => insertDB() : null,
      ),
    );
  }

  insertDB() {
    if (_formKey.currentState!.validate()) {
      _passwordHive.addPassword(_type!, _email!, _password!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _passwordHive = Provider.of<PasswordHive>(context);
    return Padding(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            inputText("Service", "Google", (val) => _type = val),
            inputText("Username/Email/Phone", null, (val) => _email = val),
            inputText("Password", null, (val) => _password = val, true),
            ElevatedButton(
              onPressed: insertDB,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "customFont",
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 50.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
