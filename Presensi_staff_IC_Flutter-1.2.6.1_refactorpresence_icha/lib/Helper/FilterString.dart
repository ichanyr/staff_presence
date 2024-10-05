import 'dart:ui';

import 'package:presensi_ic_staff/UI/Element/Warna.dart';

enum TypeFilterStrings { KurungSiku }

class FilterString {
  Color filterStringColor(
      {required TypeFilterStrings typeFilterStrings, required String string, required Color warnaAsli }) {
    Color warna = warnaHitamTxt;
    RegExp regex = RegExp(r'^\[.*\]$');

    switch (typeFilterStrings) {
      case TypeFilterStrings.KurungSiku:
        warna = regex.hasMatch(string) ? warnaAbu : warnaAsli;
        break;

      default:
        warna = warnaHitamTxt;
        break;
    }

    return warna;
  }
}
