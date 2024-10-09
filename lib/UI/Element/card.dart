import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Element/Icon.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/riwayat.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'imgVector.dart';

class _CvRiwayats extends State<CvRiwayats> {
  // final item = ApiService().getRiwayats();
  Future item = ApiService().getRiwayats("0301001");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<RiwayatModel>(
          future: ApiService().getRiwayats("0301001"),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? new ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data!.data![index].lastTglMasuk!),
                      );
                    })
                : Text("No data yet");
          }),
    );
  }
}

class CvRiwayats extends StatefulWidget {
  _CvRiwayats createState() => _CvRiwayats();
}

class TopCardCuti extends StatelessWidget {
  final String izin;
  final int tahun;

  const TopCardCuti({Key? key, required this.izin, required this.tahun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTanggalan(),
          SizedBox(
            width: 10,
          ),
          TextIsi2(
            isi: '$izin Ketidakhadiran tahun $tahun',
            warna: warnaPutih,
            fw: FontWeight.bold,
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: warnaBiru),
    );
  }
}

class CardCuti extends StatelessWidget {
  final String sakit, cuti, izin, alpha;

  const CardCuti(
      {Key? key,
      required this.sakit,
      required this.cuti,
      required this.izin,
      required this.alpha})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: warnaBiru,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextIsi2(isi: 'Sakit : $sakit', warna: warnaPutih),
          TextIsi2(isi: 'Izin : $izin', warna: warnaPutih),
          TextIsi2(isi: 'Cuti : $cuti', warna: warnaPutih),
          TextIsi2(isi: 'Alpha : $alpha', warna: warnaPutih),
        ],
      ),
    );
  }
}

class CardCutiItem extends StatelessWidget {
  final String tanggal, hari, izin, status;
  final Function() onPress;

  const CardCutiItem(
      {Key? key,
      required this.tanggal,
      required this.hari,
      required this.izin,
      required this.status,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon icPasang = Icon(
      Icons.hourglass_bottom,
      color: warnaBiru,
    );
    Icon icPending = Icon(
      Icons.hourglass_bottom,
      color: warnaAbu,
    );
    Icon icAcc = Icon(
      Icons.check_circle,
      color: warnaBiru,
    );
    Icon icRef = Icon(
      Icons.do_not_disturb,
      color: warnaMerah,
    );

    String tanggalPrety =
        prettyDT2(DateFormat("yyyy-MM-dd HH:mm:ss").parse(tanggal));
    String izins;
    bool iconTerlihat = true;

    switch (status) {
      case 'p':
        icPasang = icPending;
        break;
      case 'a':
        icPasang = icAcc;
        break;
      case 'r':
        icPasang = icRef;
        break;
      default:
        icPasang = icPending;
        break;
    }

    switch (izin) {
      case 's':
        izins = 'Sakit';
        break;
      case 'i':
        izins = 'Izin';
        break;
      case 'c':
        izins = 'Cuti';
        break;
      case 'a':
        izins = 'Alpha';
        iconTerlihat = false;
        break;
      default:
        izins = 'Alpha';
        iconTerlihat = false;
        break;
    }

    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: warnaPutih,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 3, color: warnaAbu),
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextIsi2(isi: tanggalPrety),
              TextIsi2(isi: "$hari hari"),
              Visibility(
                visible: iconTerlihat,
                child: Row(
                  children: [TextIsi2(isi: izins), icPasang],
                ),
                replacement: TextIsi2(isi: izins),
              )
            ],
          ),
        ),
      ),
    );
  }
}
