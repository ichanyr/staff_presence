import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Login/login.dart';
import 'package:intl/intl.dart';

void cekToLogin(String iduser, BuildContext context) {
  if (iduser.isEmpty) {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    // });
  }
}

bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  return true;
}

String hariTanggal(DateTime tanggal) {
  String hari = DateFormat('EEEE').format(tanggal);

  switch (hari) {
    case "Sunday":
      hari = "Min";
      break;
    case "Monday":
      hari = "Sen";
      break;
    case "Tuesday":
      hari = "Sel";
      break;
    case "Wednesday":
      hari = "Rab";
      break;
    case "Thursday":
      hari = "Kam";
      break;
    case "Friday":
      hari = "Jum";
      break;
    case "Saturday":
      hari = "Sab";
      break;
  }
  String tgl = DateFormat("dd").format(tanggal);
  hari = "$hari($tgl)";
  return hari;
}

String uangFormatter(double uang) {
  CurrencyFormatterSettings uangFormatter = CurrencyFormatterSettings(
    symbol: 'Rp',
    symbolSide: SymbolSide.left,
    thousandSeparator: '.',
    decimalSeparator: ',',
    // symbolSeparator: ' ',
  );
  String formatted =
      CurrencyFormatter.format(uang, uangFormatter, compact: true);

  return formatted;
}

String stringTrimmer(String isi, int panjang) {
  isi.length > panjang ? isi = isi.substring(0, panjang) + "..." : isi = isi;
  return isi;
}

String bulanTahunShow(DateTime tgl) {
  String tahun = DateFormat("yyyy").format(tgl);
  String bulan = bulanPretty(tgl);

  return "$bulan $tahun";
}

class IconStatus extends StatefulWidget {
  final String status;

  const IconStatus({Key? key, required this.status}) : super(key: key);

  @override
  State<IconStatus> createState() => _IconStatusState();
}

class _IconStatusState extends State<IconStatus> {
  late String status;
  late Icon icoStatus;

  @override
  Widget build(BuildContext context) {
    status = widget.status;
    icoStatus = Icon(Icons.hourglass_bottom, color: warnaAbu);

    switch (status) {
      case "pending":
        icoStatus = Icon(Icons.hourglass_bottom, color: warnaAbu);
        break;
      case "approve":
        icoStatus = Icon(Icons.check_circle_outline_rounded, color: warnaHitam);
        break;
      case "refused":
        icoStatus = Icon(Icons.not_interested, color: warnaMerah);
        break;
      case "transfered":
        icoStatus = Icon(Icons.monetization_on, color: warnaHijau);
        break;
      case "overtime":
        icoStatus = Icon(Icons.hourglass_disabled_rounded, color: warnaMerah);
        break;
      case "disabled":
        icoStatus = Icon(Icons.not_interested, color: warnaMerah);
        break;
      case "completed":
        icoStatus = Icon(Icons.check_circle_rounded, color: warnaHitam);
        break;
      case "done":
        icoStatus = Icon(Icons.check_circle_rounded, color: warnaBiru);
        break;
    }

    return Container(
      child: icoStatus,
    );
  }
}

String prettyDT(DateTime tgl) {
  String tanggal = DateFormat("dd").format(tgl);
  String bulan = bulanPretty(tgl);
  String tahun = DateFormat("yyyy").format(tgl);
  String jam = DateFormat("HH:mm").format(tgl);

  return "$tanggal $bulan $tahun ($jam)";
}

String prettyDT2(DateTime tgl){
  String tanggal = DateFormat("dd").format(tgl);
  String bulan = bulanPretty(tgl);
  String tahun = DateFormat("yyyy").format(tgl);

  return "$tanggal $bulan $tahun";
}

String bulanPretty(DateTime tgl) {
  String bulan = DateFormat("M").format(tgl);

  switch (bulan) {
    case "1":
      bulan = "Jan";
      break;
    case "2":
      bulan = "Feb";
      break;
    case "3":
      bulan = "Mar";
      break;
    case "4":
      bulan = "Apr";
      break;
    case "5":
      bulan = "Mei";
      break;
    case "6":
      bulan = "Jun";
      break;
    case "7":
      bulan = "Jul";
      break;
    case "8":
      bulan = "Ags";
      break;
    case "9":
      bulan = "Sep";
      break;
    case "10":
      bulan = "Okt";
      break;
    case "11":
      bulan = "Nov";
      break;
    case "12":
      bulan = "Des";
      break;
  }

  return bulan;
}

bool lihatFeedback(String status) {
  bool isFb = false;
  status == "pending" ? isFb = false : isFb = true;
  return isFb;
}

bool lihatBtnLapor(String status) {
  bool isBtnLapor = false;
  switch (status) {
    case "transfered":
      isBtnLapor = true;
      break;
    case "overtime":
      isBtnLapor = true;
      break;
    case "completed":
      isBtnLapor = true;
      break;
    case "done":
      isBtnLapor = true;
      break;
  }
  return isBtnLapor;
}

bool isDataLaporanCanEdit(String status) {
  bool isCanEdit = false;
  switch (status) {
    case "transfered":
      isCanEdit = true;
      break;
  }
  return isCanEdit;
}

bool lihatBtnEditAnggaran(String status) {
  bool isVisBtnEdit = false;
  switch (status) {
    case "pending":
      isVisBtnEdit = true;
      break;
  }
  return isVisBtnEdit;
}

// untuk download file
Future<String> downloadFile(String url, String dir) async {
  HttpClient httpClient = new HttpClient();
  File file;
  String filePath = '';
  String myUrl = '';
  String fileName = '';
  int countSeparator = 0;

  try {
    // myUrl = url+'/'+fileName;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);

      // mendeteksi filename
      for (int i = 0; i < url.length; i++) {
        if (url.substring(i, i + 1) == "/") {
          countSeparator = i;
        }
      }
      fileName = url.substring(countSeparator + 1, url.length);

      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else
      filePath = 'Error code: ' + response.statusCode.toString();
  } catch (ex) {
    filePath = 'Can not fetch url : $ex';
  }

  return filePath;
}

// 2. compress file and get file.
Future<String> kompresGambar(File file, String targetPath) async {
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 80,
    minHeight: 800,
    minWidth: 800,
    keepExif: true,
    autoCorrectionAngle: true,

    // rotate: 180,
  );

  return result!.path;
}

String expandIzin({required String izin}) {
  String kembali = '';
  switch (izin) {
    case 'i':
      kembali = 'Izin';
      break;
    case 's':
      kembali = 'Sakit';
      break;
    case 'a':
      kembali = 'Alpha';
      break;
    case 'c':
      kembali = 'Cuti';
      break;
    default:
      kembali = 'Alpha';
      break;
  }

  return kembali;
}