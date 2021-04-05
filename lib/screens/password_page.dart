import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:password_manager/screens/add_password.dart';
import 'package:password_manager/controller/encrypter.dart';
import 'package:password_manager/controller/passwords_hive.dart';

class Passwords extends StatelessWidget {
  late PasswordHive passwordHive;

  Passwords({Key? key}) : super(key: key);

  EncryptService _encryptService = new EncryptService();

  Future<bool?> showDeleteConfirmation(context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
              "Are you sure you wish to delete this item?\nThis cannot be undone"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("DELETE"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  listTile(int index, BuildContext context) {
    var item = passwordHive.box.getAt(index);
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDeleteConfirmation(context),
      onDismissed: (direction) {
        passwordHive.delete(index);
        print("deleted");
      },
      child: ListTile(
        leading: Icon(
          Icons.vpn_key_rounded,
          size: 36,
        ),
        title: Text(
          item?['type'] ?? '',
          style: TextStyle(fontSize: 22.0),
        ),
        subtitle: Text(
          "Click on the icon to copy your password",
          style: TextStyle(fontSize: 16),
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy_rounded),
          onPressed: () {
            _encryptService.copyToClipboard(
              item['password'],
              context,
            );
          },
        ),
      ),
    );
  }

  buildPasswordList() {
    return passwordHive.passwordCount > 0
        ? ListView.builder(
            itemCount: passwordHive.passwordCount,
            itemBuilder: (context, index) {
              return listTile(index, context);
            },
          )
        : Center(
            child: Text("No data"),
          );
  }

  void addNewPassword(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddNewPassword(),
    );
  }

  @override
  Widget build(BuildContext context) {
    passwordHive = Provider.of<PasswordHive>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Passwords"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewPassword(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        // backgroundColor: Color(0xff892cdc),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: buildPasswordList(),
    );
  }
}
