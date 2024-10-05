import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/riwayat.dart';

import 'card.dart';

// Widget lvRiwayat = Container(
//   child: ListView.builder(
//     scrollDirection: Axis.vertical,
//     shrinkWrap: true,
//     itemBuilder: (context, position) {
//       return CvRiwayat();
//     },
//     itemCount: 'Testing'.length,
//   ),
// );

Widget lvRiwayats = Container(
  child: ListView.builder(
    physics: ScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (context, position) {
      return CvRiwayats();
    },
    itemCount: 'Testing'.length,
  ),
);
