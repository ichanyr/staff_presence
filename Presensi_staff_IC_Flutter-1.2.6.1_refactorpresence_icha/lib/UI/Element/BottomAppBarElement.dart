import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Warna.dart';

// Bottom App Bar Custom
class AppBarBawah extends StatefulWidget {
  const AppBarBawah({Key? key}) : super(key: key);

  @override
  State<AppBarBawah> createState() => _AppBarBawahState();
}

class _AppBarBawahState extends State<AppBarBawah> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: warnaPutih,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: warnaPutihAbu4,
              width: 2,
            ),
          ),
        ),
        height: 50,
      ),
    );
  }
}
