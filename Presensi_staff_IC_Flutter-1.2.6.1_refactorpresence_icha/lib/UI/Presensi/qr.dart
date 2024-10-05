import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QRPage extends StatefulWidget {
  QRPage({Key? key, this.btnLogin}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final ElevatedButton? btnLogin;

  @override
  _QRPage createState() => _QRPage();
}

class _QRPage extends State<QRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: new BoxConstraints.loose(
            new Size(600, 500),
          ),
          child: (Column(
            children: <Widget>[],
          ))),
    );
  }
}
