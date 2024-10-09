import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';

class PresensiQR2 extends StatefulWidget {
  const PresensiQR2({Key? key}) : super(key: key);

  @override
  State<PresensiQR2> createState() => _PresensiQR2State();
}

class _PresensiQR2State extends State<PresensiQR2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Mobile Scanner')),
        body: TextIsi2(
          isi: "QR",
        ));
  }
}
