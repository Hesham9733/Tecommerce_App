import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class GlobalMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> showMeDialoug(
      BuildContext context, String title, String subTitle, Function fct) async {
    await NDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue),
      ),
      content: Text(
        subTitle,
        style: TextStyle(color: Colors.pink),
      ),
      actions: <Widget>[
        TextButton(
            child: Text("Cancel".toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(
              "Ok".toUpperCase(),
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              fct();
              Navigator.pop(context);
            }),
      ],
    ).show(context);
  }

  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    await NDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        "Error Occurred",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue),
      ),
      content: Text(
        subtitle,
        style: TextStyle(color: Colors.pink),
      ),
      actions: <Widget>[
        TextButton(
            child: Text("OK".toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    ).show(context);
  }

  Future<void> authSignOut(String subtitle, BuildContext context) async {
    await NDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        "Loging Out",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue),
      ),
      content: Text(
        subtitle,
        style: TextStyle(color: Colors.pink),
      ),
      actions: <Widget>[
        TextButton(
            child: Text("Cancel".toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child:
                Text("OK".toUpperCase(), style: TextStyle(color: Colors.red)),
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.pushNamed(context, 'Landing');
                flutterToast('Logged Out Successfully');
              });
            }),
      ],
    ).show(context);
  }

  void flutterToast(String _msg) {
    Fluttertoast.showToast(
        msg: _msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
