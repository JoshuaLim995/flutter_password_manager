import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/controller/encrypter.dart';

class PasswordHive with ChangeNotifier, DiagnosticableTreeMixin {
  Box _box = Hive.box('passwords');
  EncryptService _encryptService = new EncryptService();

  //Getter
  Box get box => _box;
  int get passwordCount => _box.toMap().length;

  //Setter
  addPassword(String type, String email, String password) {
    _box.add({
      'type': type,
      'email': email,
      'password': _encryptService.encrypt(password),
    });
    notifyListeners();
  }

  delete(int index) async {
    _box.deleteAt(index);
    notifyListeners();

    Fluttertoast.showToast(
      msg: "Password deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
