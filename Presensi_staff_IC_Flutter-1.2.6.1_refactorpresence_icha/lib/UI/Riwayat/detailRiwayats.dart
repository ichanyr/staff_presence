import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Element/ListView.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:presensi_ic_staff/UI/Login/login.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/todo.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRiwayatPages extends StatefulWidget {
  DetailRiwayatPages({Key? key, required this.idRiwayat, required this.idUser}) : super(key: key);

  final String idRiwayat;
  final String idUser;

  @override
  _DetailRiwayatPages createState() => _DetailRiwayatPages();
}

class _DetailRiwayatPages extends State<DetailRiwayatPages> {
  bool isEdit = true;
  late SharedPreferences sp;
  String? iduser;

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    loadSP();
    BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    String idR = widget.idRiwayat.toString();
    String idU = widget.idUser.toString();
    cekToLogin(idU, context);
    // ApiService().getDetailR("27", "0301001");
    Future<DetailRiwayat> test = ApiService().getDetailR(idR, idU);

    return Scaffold(
      appBar: AppBar(
        title: tvDRiwayatAppBar,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: printFuture(),
      floatingActionButton: Container(width: 80, height: 80, child: FabScan()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget printFuture() {
    String idR = widget.idRiwayat.toString();
    String idU = widget.idUser.toString();
    // ApiService().getDetailR("27", "0301001");
    Future<DetailRiwayat> test = ApiService().getDetailR(idR, idU);
    return FutureBuilder<DetailRiwayat>(
      future: test,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        imgBgBiru,
                        SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: const DecoratedBox(
                            decoration: const BoxDecoration(
                                color: Color(0xffe8f4fe)),
                          ),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(top: 50),
                  ),
                  Column(
                    children: <Widget>[
                      keterlambatan(snapshot),
                      poinDidapat(snapshot),
                      fotoDatang(snapshot.data!.listDataDetailRiwayat![0].fotoDatang,
                          snapshot.data!.listDataDetailRiwayat![0].jamMasuk),
                      ketDatang(
                          snapshot.data!.listDataDetailRiwayat![0].keteranganDatang,
                          snapshot.data!.listDataDetailRiwayat![0].jamMasuk,
                          snapshot.data!.listDataDetailRiwayat![0].fotoDatang),
                      fotoPulang(snapshot.data!.listDataDetailRiwayat![0].fotoPulang,
                          snapshot.data!.listDataDetailRiwayat![0].jamKeluar),
                      ketPulang(
                          snapshot.data!.listDataDetailRiwayat![0].keteranganPulang,
                          snapshot.data!.listDataDetailRiwayat![0].jamKeluar,
                          snapshot.data!.listDataDetailRiwayat![0].fotoPulang),
                      new GestureDetector(
                        child: lapAkt(snapshot.data!.listDataDetailRiwayat![0].todolist),
                        onTap: () => setState(() => isEdit = !isEdit),
                      ),
                    ],
                  ),
                  boxAtas(snapshot),
                ],
              ),
            ],
          ),
        )
            : Text("No Data Yet");
      },
    );
  }

  Widget boxAtas(var snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
// ======================================== Kotak tanggal ========================================
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Container(
                  child: Row(children: <Widget>[
                    Stack(children: <Widget>[
                      Positioned.fill(child: imgKotakTgl),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
// ========================================  tanggal ========================================
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Text(
                                snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamMasuk
                                    .substring(8, 10) +
                                    "-" +
                                    snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamMasuk
                                        .substring(5, 7) +
                                    "-" +
                                    snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamMasuk
                                        .substring(0, 4) ??
                                    "Belum",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ),
// ========================================  JM, JK ========================================
                            Container(
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: imgIcoIn),
// ========================================  Jam Masuk ========================================
                                  Text(
                                    snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamMasuk
                                        .substring(11, 16) ??
                                        "Belum",
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: 20,
                                        color: Colors.black),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: imgIcoOut),
// ========================================  Jam Keluar ========================================
                                  (() {
                                    if (snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamKeluar !=
                                        null) {
                                      return Text(
                                        snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamKeluar
                                            .substring(11, 16) ??
                                            "belum",
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontSize: 20,
                                            color: Colors.black),
                                      );
                                    } else {
                                      return Text(
                                        "belum",
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontSize: 20,
                                            color: Colors.black),
                                      );
                                    }
                                  }())
                                ]),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
// ======================================== Kotak Poin ========================================
              Container(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned.fill(child: imgKotakTgl),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text(
                                "Poin\n" + snapshot.listDataDetailRiwayat.listDataDetailRiwayat.totalPoin ??
                                    "Poin\n0",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 20,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
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

  Widget keterlambatan(var snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 120, left: 30, right: 30),
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
                  var telat = hitungTelat(snapshot.listDataDetailRiwayat.listDataDetailRiwayat.jamMasuk);
                  var detikTelat = cekTelat(telat);
                  var printTelats = printTelat(detikTelat);

                  return Text(
                    printTelats,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 20,
                        color: Colors.black),
                  );
                }())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget poinDidapat(var snapshot) {
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
                Text(
                  snapshot.listDataDetailRiwayat.listDataDetailRiwayat.poin + " Poin",
                  style: TextStyle(
                      fontFamily: "Nunito", fontSize: 20, color: Colors.black),
                )
              ],
            ),
          ),
          imgSeparator(),
        ],
      ),
    );
  }

  Widget fotoDatang(var snapshot, var jm) {
    if (snapshot == "" || snapshot == null) {
      snapshot = null;
    }
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
                  if (jm == null) {
                    return textIsiGray("[Belum Presensi]");
                  } else if (jm != null && snapshot == null) {
                    return textIsiGray("[Presensi QR]");
                  } else {
                    return InkWell(
                      onTap: () => showImage(snapshot, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(snapshot ?? null,
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

  Widget ketDatang(var snapshot, var jm, var fd) {
    if (snapshot == "") {
      snapshot = null;
    }
    if (fd == "") {
      fd = null;
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
                tvKetDatang,
                (() {
                  if (jm == null || jm == "") {
                    return textIsiGray("[Belum presensi]");
                  } else if (jm != null && fd == null) {
                    return textIsiGray("[Presensi QR]");
                  } else if (jm != null && fd != null) {
                    return textIsiGray("[Kosong]");
                  } else {
                    return textIsi(snapshot);
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

  Widget ketPulang(var snapshot, var jamPulang, var fp) {
    if (fp == "") {
      fp = null;
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
                (() {
                  if (jamPulang == null || jamPulang == "") {
                    return textIsiGray("[Belum Presensi]");
                  } else if (jamPulang != null && fp == null) {
                    return textIsiGray("[Presensi QR]");
                  } else if (snapshot == null || snapshot == "") {
                    return textIsiGray("[Kosong]");
                  } else {
                    return textIsi(snapshot);
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

  Widget lapAkt(var snapshot) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: [lapData(snapshot), lapEdit(snapshot)],
          ),
        ),
        imgSeparator(),
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
    return Visibility(
      visible: isEdit,
      child: Container(
          margin: const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
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
    );
  }

  Widget lapEdit(var snapshot) {
    var textCtrl = new TextEditingController();
    var isiSnapshot = snapshot;
    textCtrl.text = isiSnapshot;
    return Visibility(
        visible: !isEdit,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    child: Align(alignment: Alignment.topLeft, child: tvLapAkt),
                  ),
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
                      onPressed: () => simpanTodo(textCtrl.text),
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
        ));
  }

  Widget btnBatal() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () => setState(() => isEdit = !isEdit),
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

  simpanTodo(String isi) {
    var idU = widget.idUser;
    var idR = widget.idRiwayat;
    // ApiService().postTodo(idR, isi);
    Future<TodoAct> futureTodo = ApiService().postTodo(idR, isi);
    futureTodo.then((value) {
      if (value != null) {
        showSukses("Update berhasil!", context);
        setState(() => isEdit = !isEdit);
      } else {
        showSukses("Update gagal!", context);
      }
    });
  }

  cekUpdate(bool snapshot) {
    if (snapshot == true) {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return tampilDialog("Berhasil Update Data!");
      //     });
      setState(() {});
    }
  }
}
