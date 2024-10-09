import 'dart:ffi';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/ListView.dart';
import 'package:presensi_ic_staff/UI/Element/Model/ButtonModel.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:presensi_ic_staff/UI/Login/login.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/DetailRiwayatController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/TodoController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/todo.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';

class DetailRiwayatPagesPager extends StatefulWidget {
  DetailRiwayatPagesPager(
      {Key? key,
      required this.listDetailRiwayat,
      required this.idriwayat,
      required this.listIdRiwayat})
      : super(key: key);

  // final String idRiwayat;
  // final PageController pageCtrl;
  /// load all data detailRiwayat
  List<DetailRiwayat> listDetailRiwayat = <DetailRiwayat>[];
  final String idriwayat;
  final List<int> listIdRiwayat;

  @override
  _DetailRiwayatPagesPager createState() => _DetailRiwayatPagesPager();
}

class _DetailRiwayatPagesPager extends State<DetailRiwayatPagesPager> {
  /// controller
  late TodoController todoCtrl;
  DetailRiwayatController drCtrl = Get.put(DetailRiwayatController());

  /// Share pref
  SharedPref sp = SharedPref();

  @override
  void initState() {
    super.initState();

    // drCtrl.idriwayat.value = widget.idRiwayat;
    // drCtrl.pageCtrl.value = widget.pageCtrl;
    drCtrl.listDetailRiwayat.value = widget.listDetailRiwayat;
    drCtrl.idriwayat.value = widget.idriwayat.toString();
    drCtrl.listIdriwayat.value = widget.listIdRiwayat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: tvDRiwayatAppBar,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Obx(() => Visibility(
                visible: drCtrl.isFeedbackExist.value,
                replacement: SizedBox.shrink(),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                      iconSize: 25,
                      onPressed: () {
                        drCtrl.fnTampilFeedback(context: context);
                      },
                      icon: IcoFeedback(size: 25)),
                ),
              )),
        ],
      ),
      body: Container(color: Color(0xffE8F4FE), child: pvDetailRiwayat()),
    );
  }

  Widget pvDetailRiwayat() {
    return Obx(
      () => PageView.builder(
        itemCount: drCtrl.idr.length,
        controller: drCtrl.pageCtrl.value,
        itemBuilder: (context, index) {
          return printFuture(
              drCtrl.idr[index].toString(), drCtrl.iduser.value, index);
        },
      ),
    );
  }

  Widget printFuture(String idR, String idU, int index) {
    // return drCtrl.obx(
    //     (state) => detailData(snapshot: state, iduser: idU, idriwayat: idR),
    //     onLoading: LoadingIc(),
    //     onEmpty: TextFormatting(text: 'Data Kosong!'),
    //     onError: (e) => TextFormatting(text: 'Telah terjadi error : $e'));
    return detailData(
        iduser: idU, idriwayat: idR, snapshot: drCtrl.listDetailRiwayat[index]);
  }

  Widget detailData(
      {DetailRiwayat? snapshot,
      required String iduser,
      required String idriwayat}) {
    String izin = snapshot!.listDataDetailRiwayat!.first.izin ?? '';

    /// izin kosong
    if (izin == '') {
      return detailDataMasuk(
          snapshot: snapshot, idriwayat: idriwayat, iduser: iduser);
    }

    /// izin ada isinya
    else {
      return detailDataIzin(snapshot: snapshot);
    }
  }

  Widget detailDataMasuk(
      {required DetailRiwayat snapshot,
      required String iduser,
      required String idriwayat}) {
    String fotoD = snapshot.listDataDetailRiwayat!.first.fotoDatang ?? '',
        fotoP = snapshot.listDataDetailRiwayat!.first.fotoPulang ?? '',
        jamM = snapshot.listDataDetailRiwayat!.first.jamMasuk.toString(),
        jamK = snapshot.listDataDetailRiwayat!.first.jamKeluar.toString(),
        ketD = snapshot.listDataDetailRiwayat!.first.keteranganDatang!,
        ketP = snapshot.listDataDetailRiwayat!.first.keteranganPulang!,
        todoListData = snapshot.listDataDetailRiwayat!.first.todolist!,
        idRiwayat = snapshot.listDataDetailRiwayat!.first.idRiwayat!,
        izin = snapshot.listDataDetailRiwayat!.first.izin!;

    return ScrollDenganResponsive(
      onBack: () {
        Get.back();
      },
      child: Container(
          color: warnaPutih,
          child: Stack(
            children: <Widget>[
              //bg
              Container(
                margin: EdgeInsets.only(top: 50),
                width: double.maxFinite,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xffE8F4FE),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                ),
              ),

              // isi data
              Container(
                color: Color(0xffE8F4FE),
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    keterlambatan(snapshot),
                    poinDidapat(snapshot),
                    fotoDatang(fotoD, jamM),
                    ketDatang(ketD, jamM, fotoD),
                    fotoPulang(fotoP, jamK),
                    ketPulang(ketP, jamK, fotoP),

                    // todo list
                    Container(
                        padding: EdgeInsets.only(top: 10, bottom: 130),
                        child: todoListWidget(
                            snap: snapshot, idriwayat: idriwayat)),
                    // new GestureDetector(
                    //   child: lapAkt(todoListData, idRiwayat),
                    //   onTap: () => setState(() => isEdit = !isEdit),
                    // ),
                  ],
                ),
              ),

              // box atas
              boxAtas(snapshot),
            ],
          )),
    );
  }

  Widget detailDataIzin({required DetailRiwayat snapshot}) {
    String fotoD = '',
        fotoP = '',
        jamM = '',
        jamK = '',
        ketD = '',
        ketP = '',
        todoList = '',
        idRiwayat = '',
        izin = '';
    fotoD = snapshot.listDataDetailRiwayat![0].fotoDatang ?? '';
    fotoP = snapshot.listDataDetailRiwayat![0].fotoPulang ?? '';
    jamM = snapshot.listDataDetailRiwayat![0].jamMasuk.toString();
    jamK = snapshot.listDataDetailRiwayat![0].jamKeluar.toString();
    ketD = snapshot.listDataDetailRiwayat![0].keteranganDatang!;
    ketP = snapshot.listDataDetailRiwayat![0].keteranganPulang!;
    todoList = snapshot.listDataDetailRiwayat![0].todolist!;
    idRiwayat = snapshot.listDataDetailRiwayat![0].idRiwayat!;
    izin = snapshot.listDataDetailRiwayat![0].izin!;

    return ScrollDenganResponsive(
      child: Container(
        color: warnaPutih,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                //bg
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: double.maxFinite,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xffE8F4FE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)),
                  ),
                ),

                // isi data
                Container(
                  color: Color(0xffE8F4FE),
                  margin: EdgeInsets.only(top: 120),
                  child: Column(
                    children: <Widget>[poinDidapat(snapshot)],
                  ),
                ),

                // box atas
                boxAtasIzin(snapshot),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget boxAtas(DetailRiwayat snapshot) {
    var tanggal, jm, jk, poin;
    if (snapshot == "[Loading]") {
      tanggal = "[Loading]";
      jm = "[Loading]";
      jk = "[Loading]";
      poin = "[...]";
    } else {
      if (tanggal != "") {
        tanggal = snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(8, 10) +
            "-" +
            snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(5, 7) +
            "-" +
            snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(0, 4);
      } else {
        tanggal = "[Belum]";
      }
      if (jm != "") {
        jm = snapshot.listDataDetailRiwayat![0].jamMasuk
            .toString()
            .substring(11, 16);
      } else {
        jm = "[Belum]";
      }
      if (jk != "[Loading]" &&
          snapshot.listDataDetailRiwayat![0].jamKeluar != null &&
          snapshot.listDataDetailRiwayat![0].jamKeluar!.length >= 16) {
        jk = snapshot.listDataDetailRiwayat![0].jamKeluar
            .toString()
            .substring(11, 16);
      } else {
        jk = "[Belum]";
      }
      if (poin == "") {
        poin = "0";
      } else {
        poin = snapshot.listDataDetailRiwayat![0].totalPoin;
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
// ======================================== Kotak tanggal ========================================
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: warnaPutih,
                borderRadius: BorderRadius.circular(radiusMed),
                boxShadow: [
                  BoxShadow(
                      color: warnaAbuCard, spreadRadius: 1, blurRadius: 5),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(marginDidalamContent),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
// ========================================  tanggal ========================================
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextFormatting(
                          text: tanggal,
                        ),
                      ),
                    ),
                    SizedBox(width: marginDidalamContent / 2),
// ========================================  JM, JK ========================================
                    Flexible(
                      child: Container(
                        child: Column(children: <Widget>[
// ========================================  Jam Masuk ========================================
                          Row(children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: imgIcoIn),
                            Flexible(
                              child: TextFormatting(
                                text: jm,
                              ),
                            ),
                          ]),
                          SizedBox(height: marginDidalamContent / 2),

// ========================================  Jam Keluar ========================================
                          Row(children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: imgIcoOut),
                            Flexible(
                              child: TextFormatting(
                                text: jk,
                              ),
                            )
                          ]),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: marginDidalamContent),
// ======================================== Kotak Poin ========================================
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(marginDidalamContent),
              decoration: BoxDecoration(
                color: warnaPutih,
                borderRadius: BorderRadius.circular(radiusMed),
                boxShadow: [
                  BoxShadow(
                      color: warnaAbuCard, spreadRadius: 1, blurRadius: 5),
                ],
              ),
              child: TextFormatting(
                text: "Poin\n" + poin,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget boxAtasIzin(DetailRiwayat snapshot) {
    var tanggal, izin, poin;
    if (snapshot == "[Loading]") {
      tanggal = "[Loading]";
    } else {
      if (tanggal != "") {
        tanggal = snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(8, 10) +
            "-" +
            snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(5, 7) +
            "-" +
            snapshot.listDataDetailRiwayat![0].jamMasuk
                .toString()
                .substring(0, 4);
      } else {
        tanggal = "[Belum]";
      }
      if (poin == "") {
        poin = "0";
      } else {
        poin = snapshot.listDataDetailRiwayat![0].totalPoin;
      }
      if (snapshot.listDataDetailRiwayat![0].izin != null &&
          snapshot.listDataDetailRiwayat![0].izin != '') {
        izin = expandIzin(izin: snapshot.listDataDetailRiwayat![0].izin!);
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
// ======================================== Kotak tanggal ========================================
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: warnaPutih,
                    borderRadius: BorderRadius.circular(radiusMed),
                    boxShadow: [
                      BoxShadow(
                          color: warnaAbuCard, spreadRadius: 1, blurRadius: 5),
                    ],
                  ),
                  margin: const EdgeInsets.only(right: 20),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // tanggal
                        Flexible(
                          child: TextFormatting(
                              textAlign: TextAlign.end,
                              text: tanggal,
                              overflow: TextOverflow.visible),
                        ),
                        SizedBox(
                          width: marginDidalamContent / 2,
                        ),

                        // izin
                        Flexible(
                          child: TextFormatting(
                            text: 'Kehadiran \n$izin',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
// ======================================== Kotak Poin ========================================
              Flexible(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: warnaPutih,
                      borderRadius: BorderRadius.circular(radiusMed),
                      boxShadow: [
                        BoxShadow(
                            color: warnaAbuCard,
                            spreadRadius: 1,
                            blurRadius: 5),
                      ],
                    ),
                    child: TextFormatting(
                      text: 'Poin\n$poin',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double hitungTelat(String tanggal) {
    DateTime dtJm = DateTime.parse(tanggal);
    TimeOfDay todJm = TimeOfDay.fromDateTime(dtJm);
    int jmlDetik = todJm.hour * 60 * 60 + todJm.minute * 60;
    double telat = jmlDetik.toDouble() - 8 * 60 * 60;
    double telats = (28860 - 8 * 60 * 60).toDouble();

    var pengurangan = telat.toString();

    return telat;
  }

  int cekTelat(double detik) {
    if (detik <= 0) {
      return 0;
    } else {
      return detik.toInt();
    }
  }

  String printTelat(int telat) {
    int hitung = 0;
    String tulisTelat = "";
    if (telat <= 60) {
      tulisTelat = telat.toString() + " detik";
    } else if (telat > 60 && telat <= 60 * 60) {
      hitung = telat ~/ 60;
      tulisTelat = hitung.toString() + " menit";
    } else if (telat > 60 * 60) {
      hitung = telat ~/ (60 * 60);
      tulisTelat = hitung.toString() + " Jam";
    }

    return tulisTelat;
  }

  Widget keterlambatan(DetailRiwayat snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        children: [
          imgSeparator(),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvKeterlambatan,
                (() {
                  var telat;
                  var detikTelat;
                  var printTelats;
                  if (snapshot == "" || snapshot == "[Loading]") {
                    telat = "[Loading]";
                    detikTelat = "[Loading]";
                    printTelats = "[Loading]";
                  } else {
                    telat = hitungTelat(
                        snapshot.listDataDetailRiwayat![0].jamMasuk.toString());
                    detikTelat = cekTelat(telat);
                    printTelats = printTelat(detikTelat);
                  }

                  return TextFormatting(
                    text: printTelats,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,
                  );
                }())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget poinDidapat(DetailRiwayat snapshot) {
    var dataPoin;
    if (snapshot == "[Loading]") {
      dataPoin = "[Loading]";
    } else {
      dataPoin = snapshot.listDataDetailRiwayat![0].poin;
    }
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
      child: Column(
        children: [
          imgSeparator(),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvPoinDidapat,
                TextFormatting(
                  text: dataPoin + " Poin",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.visible,
                )
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  Widget fotoDatang(String imgPath, String jm) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvFotoDatang,
                (() {
                  if (jm == '') {
                    return textIsiGray("[Belum Presensi]");
                  } else if (jm != '' && imgPath == '') {
                    return textIsiGray("[Presensi QR]");
                  } else if (imgPath == "[Loading]") {
                    return textIsiGray("[Loading]");
                  } else {
                    return InkWell(
                      onTap: () => showImage(imgPath, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(imgPath ?? '',
                            fit: BoxFit.fitWidth, width: 150),
                      ),
                    );
                  }
                }())
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  showImage(String gambar, BuildContext context) {
    dialogImage(gambar, context);
  }

  Widget ketDatang(String ketDatang, String jm, String fd) {
    String ketDatangs = ketDatang;

    /// cek belum presensi
    if (jm == '' && ketDatang == '') {
      ketDatangs = '[Belum Presensi]';
    }

    /// presensi QR
    if (fd == '') {
      ketDatangs = '[Presensi QR]';
    }

    return Container(
      margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvKetDatang,
                Flexible(
                  child: TextFormatting(
                    text: ketDatangs,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  Widget printFPulang(var isi) {
    // var snapshot = isi.data.message.fotoPulang;
    return Image.network(isi ?? null, fit: BoxFit.fitWidth, width: 150);
  }

  Widget fotoPulang(var snapshot, var jamPulang) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvFotoPulang,
                (() {
                  if (jamPulang == null || jamPulang == "") {
                    return textIsiGray("[Belum Presensi]");
                  } else if (snapshot == null || snapshot == "") {
                    return textIsiGray("[Presensi QR]");
                  } else if (snapshot == "[Loading]") {
                    return textIsiGray("[Loading]");
                  } else {
                    return InkWell(
                      onTap: () => showImage(snapshot, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: printFPulang(snapshot),
                      ),
                    );
                  }
                }())
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  Widget ketPulang(String snapshot, String jamPulang, String fp) {
    String ketPulang = snapshot;

    /// sudah pulang tapi ket kosong
    if (jamPulang != '' && snapshot == '') {
      ketPulang = '[Kosong]';
    }

    /// belum presensi
    if (jamPulang == '') {
      ketPulang = '[Belum Presensi]';
    }

    return Container(
      margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tvKetPulang,
                Expanded(
                    child: TextFormatting(
                  textAlign: TextAlign.end,
                  text: ketPulang,
                  overflow: TextOverflow.visible,
                ))
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  Widget lapAkt(var snapshot, String idRiwayat) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: [
              lapData(snapshot),
              lapEdit(snapshot, idRiwayat),
              Container(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: imgSeparator(),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 150,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xffe8f4fe)),
          ),
        )
      ],
    );
  }

  Widget lapData(var snapshot) {
    return Obx(
      () => Visibility(
        visible: drCtrl.isEdit.value,
        child: Container(
            margin:
                const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
            child: (() {
              if (snapshot.length >= 15) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tvLapAkt,
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            child: textIsiLeft(snapshot),
                          ),
                          textIsi(" "),
                          imgEdit
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.length > 0) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      tvLapAkt,
                      Row(
                        children: [textIsi(snapshot), textIsi(" "), imgEdit],
                      )
                    ],
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    tvLapAkt,
                    Row(
                      children: [textIsiGray("[Kosong]"), imgEdit],
                    ),
                  ],
                );
              }
            }())),
      ),
    );
  }

  Widget lapEdit(var snapshot, String idRiwayat) {
    var textCtrl = new TextEditingController();
    var isiSnapshot = snapshot;
    textCtrl.text = isiSnapshot;
    return Obx(
      () => Visibility(
          visible: !drCtrl.isEdit.value,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
                child: Column(
                  children: [
                    /// text lap aktifitas
                    Container(
                      child:
                          Align(alignment: Alignment.topLeft, child: tvLapAkt),
                    ),

                    /// input text aktivitas
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: new TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 200,
                        controller: textCtrl,
                        decoration: InputDecoration(
                            hintText: 'Masukkan Detail Aktivitas Anda',
                            labelText: 'Aktivitas',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    btnBatal(),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () => drCtrl.simpanTodo(textCtrl.text),
                        child: Text("Simpan".toUpperCase(),
                            style: TextStyle(fontSize: 20)),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget btnBatal() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () => drCtrl.isEdit.value = !drCtrl.isEdit.value,
          child: Text("Batal".toUpperCase(), style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        width: double.infinity,
        height: 50,
      ),
    );
  }

  Widget btnSimpan(String isi) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () => showSukses(isi, context),
          child: textIsi("Simpan"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        width: double.infinity,
        height: 50,
      ),
    );
  }

  Widget todoListWidget(
      {required DetailRiwayat snap, required String idriwayat}) {
    drCtrl.idriwayat.value = idriwayat;
    drCtrl.loadDetailRiwayat();
    List<Todo>? todo = snap.listTodo;
    TodoController todoCtrl = Get.put(TodoController());

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // teks todo
          TextIsi2(isi: 'Aktivitas'),

          /// List todo
          // drCtrl.obx((state) {
          //   // ketika list to do ada isinya
          //   if (state!.listTodo!.isNotEmpty) {
          //     return Container(
          //       child:
          //           // isi list to do
          //           ListView.builder(
          //         physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         itemCount: state.listTodo!.length,
          //         scrollDirection: Axis.vertical,
          //         itemBuilder: (context, i) {
          //           // bool is_done = false;
          //           String isi = state.listTodo![i].todo!;
          //           Color warnaBtn = warnaPutih;
          //           Color warnaTxt = warnaHitam;
          //
          //           // cek sudah selesai belum
          //           if (drCtrl.listDone[i] == 'y') {
          //             warnaBtn = warnaBiru;
          //             warnaTxt = warnaPutih;
          //           }
          //
          //           return Container(
          //             margin: EdgeInsets.only(top: 15),
          //             child: ElevatedBtnWidget(
          //               warnaBtn: warnaBtn,
          //               tekan: () {
          //                 todoCtrl.fnOnTapTodo(
          //                     context: context,
          //                     idtodos: state.listTodo![i].id,
          //                     statusAsal: state.listTodo![i].isDone,
          //                     isian: state.listTodo![i].todo!);
          //                 drCtrl.loadDetailRiwayat();
          //               },
          //               bentuk: BentukBtnModel(BentukBtnModels.roundMediumTop),
          //               // child: Flexible(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   SizedBox(width: 20),
          //
          //                   // isi teks todo
          //                   Expanded(
          //                     child: TextIsi2(
          //                       isi: isi,
          //                       warna: warnaTxt,
          //                       textOverflow: TextOverflow.visible,
          //                     ),
          //                   ),
          //
          //                   // icon aksi
          //                   Container(
          //                     margin: EdgeInsets.only(left: 20),
          //                     child: Obx(() => iconEditorHapus(
          //                         isDone: state.listTodo![i].isDone!,
          //                         isHapus: todoCtrl.isHapus.value,
          //                         isEdit: todoCtrl.isEdit.value)),
          //                   ),
          //                 ],
          //               ),
          //               // ),
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   }
          //
          //   // ketika list to do tidak ada isinya
          //   else {
          //     return TextIsi2(isi: '[Aktivitas masih kosong]');
          //   }
          // },
          //     onLoading: LoadingIc(),
          //     onEmpty: TextIsi2(isi: 'List todo masih kosong'),
          //     onError: (e) => TextIsi2(
          //           isi: 'terjadi error : $e',
          //         )),

          // btn action to do
          Container(
            child:
                // isi list to do
                Obx(
              () => ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: drCtrl.dataDR.value.listTodo!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  // bool is_done = false;
                  String isi = drCtrl.dataDR.value.listTodo![i].todo!;
                  Color warnaBtn = warnaPutih;
                  Color warnaTxt = warnaHitam;

                  // cek sudah selesai belum
                  if (drCtrl.dataDR.value.listTodo![i].isDone == 'y') {
                    warnaBtn = warnaBiru;
                    warnaTxt = warnaPutih;
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 15),
                    child: ElevatedBtnWidget(
                      warnaBtn: warnaBtn,
                      tekan: () async {
                        todoCtrl.fnOnTapTodo(
                            context: context,
                            idtodos: drCtrl.dataDR.value.listTodo![i].id,
                            statusAsal: drCtrl.dataDR.value.listTodo![i].isDone,
                            isian: drCtrl.dataDR.value.listTodo![i].todo!);
                        await drCtrl.loadDetailRiwayat();
                      },
                      bentuk: BentukBtnModel(BentukBtnModels.roundMediumTop),
                      // child: Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20),

                          // isi teks todo
                          Expanded(
                            child: TextIsi2(
                              isi: isi,
                              warna: warnaTxt,
                              textOverflow: TextOverflow.visible,
                            ),
                          ),

                          // icon aksi
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Obx(() => iconEditorHapus(
                                isDone:
                                    drCtrl.dataDR.value.listTodo![i].isDone!,
                                isHapus: todoCtrl.isHapus.value,
                                isEdit: todoCtrl.isEdit.value)),
                          ),
                        ],
                      ),
                      // ),
                    ),
                  );
                },
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                // btn edit dan hapus
                drCtrl.obx((state) {
                  if (state!.listTodo!.isNotEmpty) {
                    return Row(
                      children: [
                        // edit
                        Container(
                          width: 65,
                          height: 65,
                          margin: EdgeInsets.only(right: 15),
                          child: ElevatedBtnWidget(
                            isPadding: true,
                            warnaBtn: warnaPutih,
                            tekan: () {
                              todoCtrl.fnUbahIsEdit();
                              // drCtrl.loadDetailRiwayat();
                            },
                            bentuk: BentukBtnModel(BentukBtnModels.circle),
                            child: Icon(Icons.edit, color: warnaBiru),
                          ),
                        ),

                        // Hapus
                        Container(
                          width: 65,
                          height: 65,
                          margin: EdgeInsets.only(right: 15),
                          child: ElevatedBtnWidget(
                            isPadding: true,
                            warnaBtn: warnaPutih,
                            tekan: () {
                              todoCtrl.fnUbahIsHapus();
                              drCtrl.loadDetailRiwayat();
                            },
                            bentuk: BentukBtnModel(BentukBtnModels.circle),
                            child: Icon(Icons.delete, color: warnaMerah),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox(width: 0, height: 0);
                  }
                }),

                // btn tambah
                Flexible(
                  child: ElevatedBtn(
                    tekan: () {
                      todoCtrl.insertTodo(ctx: context, isInsert: true);
                    },
                    warnaBtn: warnaBiru,
                    isMargin: false,
                    isi: 'Tambah',
                    isPadding: false,
                    bentuk: BentukBtnModel(BentukBtnModels.stadium),
                  ),
                ),
              ],
            ),
          ),

          Container(padding: EdgeInsets.only(top: 20), child: imgSeparator()),
        ],
      ),
    );
  }

  Widget iconEditorHapus(
      {required bool isHapus, required bool isEdit, required String isDone}) {
    Widget iconUbah = Icon(Icons.check_circle, color: warnaPutih);
    if (isEdit == true) {
      if (isDone == 'n') {
        iconUbah = Icon(Icons.edit, color: warnaBiru);
      } else {
        iconUbah = Icon(Icons.check_circle, color: warnaPutih);
      }
    } else if (isHapus == true) {
      if (isDone == 'n') {
        iconUbah = Icon(Icons.delete, color: warnaMerah);
      } else {
        iconUbah = Icon(Icons.check_circle, color: warnaPutih);
      }
    }
    return Container(
      child: iconUbah,
    );
  }
}

class IconTodo extends StatefulWidget {
  final String? status;

  // final bool isEdit;
  // final bool isHapus;

  const IconTodo({Key? key, this.status
      // , this.isEdit, this.isHapus
      })
      : super(key: key);

  @override
  State<IconTodo> createState() => _IconTodoState();
}

class _IconTodoState extends State<IconTodo> {
  String status = '';

  // bool isEdit = false;
  // bool isHapus = false;
  late TodoController todoCtrl;
  Icon iconAksi = Icon(Icons.check_circle, color: warnaPutih);

  @override
  Widget build(BuildContext context) {
    status = widget.status ?? '';
    // isEdit = widget.isEdit;
    // isHapus = widget.isHapus;
    todoCtrl = Get.put(TodoController());

    if (status == 'n') {
      if (todoCtrl.isEdit.value == true) {
        todoCtrl.isHapus.value = false;
        iconAksi = Icon(Icons.edit, color: warnaBiru);
      }
      if (todoCtrl.isHapus.value == true) {
        todoCtrl.isEdit.value = false;
        iconAksi = Icon(Icons.delete, color: warnaMerah);
      }

      if (todoCtrl.isEdit.value == false && todoCtrl.isHapus.value == false) {
        iconAksi = Icon(Icons.check, color: warnaPutih);
      }
    }

    return iconAksi;
  }
}
