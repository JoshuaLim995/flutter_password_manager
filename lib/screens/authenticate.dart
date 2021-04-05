import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/screens/password_page.dart';

class FingerPrintAuth extends StatefulWidget {
  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
  bool authenticated = false;

  authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      if (await localAuth.canCheckBiometrics) {
        authenticated = await localAuth.authenticate(
            localizedReason: 'Please authenticate');
        if (authenticated) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Passwords()));
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Unlock App",
              style: TextStyle(fontSize: 30),
            ),
            Divider(),
            ElevatedButton(
              onPressed: authenticate,
              child: Text(
                "Scan again",
                style: TextStyle(fontSize: 20),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 50.0,
                  ),
                ),
                // backgroundColor: MaterialStateProperty.all(
                //   Color(0xff892cdc),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
