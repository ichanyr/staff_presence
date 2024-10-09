import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Controller/SetDashController.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/ResponseSetToken.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Login/Model/Login.dart';
import 'package:presensi_ic_staff/UI/Presensi/PresensiQr.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';

import 'Controller/DashboardController.dart';
import 'Model/dashboard.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  _DashboardPage createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  late Future<bool> fCekKoneksi;
  bool isNotSafeDevice = false;

  /// state
  DashboardController dashCtrl = Get.put(DashboardController());

  // SetDashController setDashCtrl = Get.put(SetDashController());

  Future<void> loadSP() async {}

  /// refresh controller
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    /// cek koneksi ke server
    cekKoneksi();

    /// loadSP();
    Future loadPage = loadSP();

    loadSP();

    BackButtonInterceptor.add(myInterceptor);

    /// cek mock location
    // checkMockorRooted();

    // load settingan gambar
    // setDashCtrl.onInit();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () {
          Get.offAll(() => DashboardPage());
        },
        child: bodyIsi(),
      ),
    );
  }

  Widget bodyIsi() {
    Widget imgDash;

    String img = "lib/assets/images/login/img_dashboard.png";
    imgDash = ImgDashPng(img: img);

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          /// Hi, Selamat datang
          Stack(children: <Widget>[
            imgBgWave2(),
            Container(
                margin: const EdgeInsets.only(top: 50, left: 20),
                child: Obx(() => txtHi(dashCtrl.profil.value.dataProfil.name))),
          ]),

          /// menu
          Container(
            child: Stack(
                alignment: Alignment.topCenter,
                // children: <Widget>[imgDash, dashMenu()]),
                children: <Widget>[imgDash, dashMenu()]),
          ),
        ],
      ),
    );
  }

  Widget dashMenu() {
    return Padding(
      padding: const EdgeInsets.only(top: 250),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// menu atas
            Stack(
              children: [
                // bg kotak tanggal poin
                Container(
                  margin: EdgeInsets.only(top: 25),
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

                // kotak tgl poin
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: kotakTglPoin()),
              ],
            ),

            /// menu bawah
            Container(
              height: 500,
              alignment: Alignment.topCenter,
              color: Color(0xffE8F4FE),
              child: Column(
                children: [
                  /// menu
                  rangBtnDash(),

                  /// versi
                  Obx(() => Container(
                      // margin: EdgeInsets.only(top: marginAntarContent),
                      child: TextFormatting(
                          text: 'Versi ${dashCtrl.packageInfo.value.version}')))
                ],
              ),
            ),

            /// versi
            Container(
              padding: EdgeInsets.all(marginMin),
              width: double.maxFinite,
              color: Color(0xffE8F4FE),
              alignment: Alignment.center,
              child: Obx(
                () => Visibility(
                  child: TextFormatting(
                      text: 'Versi : ' + dashCtrl.packageInfo.value.version),
                  visible: dashCtrl.versiVisibility.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rangBtnDash() {
    double panjang = MediaQuery.of(context).size.height;
    double lebar = MediaQuery.of(context).size.width;
    double aspecRatio = 0.75;
    int jumlahMenu = 6;

    if (lebar <= 480) {
      aspecRatio = 0.75;
      jumlahMenu = 3;
    } else if (lebar <= 600 && lebar > 480) {
      aspecRatio = 0.75;
      jumlahMenu = 4;
    } else if (lebar <= 700 && lebar > 600) {
      aspecRatio = 0.8;
      jumlahMenu = 5;
    } else if (lebar <= 800 && lebar > 700) {
      aspecRatio = 0.9;
      jumlahMenu = 5;
    } else if (lebar > 800 && lebar <= 1000) {
      aspecRatio = 0.9;
      jumlahMenu = 6;
    } else if (lebar > 1000 && lebar <= 1200) {
      aspecRatio = 1.0;
      jumlahMenu = 6;
    } else if (lebar > 1200 && lebar <= 1400) {
      aspecRatio = 1.0;
      jumlahMenu = 7;
    } else if (lebar > 1400) {
      aspecRatio = 1.1;
      jumlahMenu = 7;
    }

    return Container(
      margin: const EdgeInsets.only(top: 0),
      alignment: Alignment.topCenter,
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: jumlahMenu,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: aspecRatio,
        children: [
          // BtnQr(isNotSafeDevice: isNotSafeDevice),
          // BtnRiwayat(),
          // BtnAnggaran(),
          // BtnCuti(),
          // BtnAkun1(),

          /// Presensi
          BtnDashboard(
            namaMenu: 'Presensi',
            svgIconMenus: SvgIconMenus.presensi,
            onPressed: () async {
              await dashCtrl.fnBtnQr();
            },
          ),

          /// Riwayat
          BtnDashboard(
              namaMenu: 'Riwayat',
              svgIconMenus: SvgIconMenus.riwayat,
              onPressed: () {
                dashCtrl.fnBtnRiwayat();
              }),

          /// Anggaran
          BtnDashboard(
              namaMenu: 'Anggaran',
              svgIconMenus: SvgIconMenus.anggaran,
              onPressed: () {
                dashCtrl.fnBtnAnggaran();
              }),

          /// Cuti
          BtnDashboard(
              namaMenu: 'Cuti',
              svgIconMenus: SvgIconMenus.cuti,
              onPressed: () {
                dashCtrl.fnBtnCuti();
              }),

          /// Lembur
          BtnDashboard(
              namaMenu: 'Lembur',
              svgIconMenus: SvgIconMenus.lembur,
              onPressed: () {
                dashCtrl.fnBtnLembur();
              }),

          /// Akun
          BtnDashboard(
              namaMenu: 'Akun',
              svgIconMenus: SvgIconMenus.akun,
              onPressed: () {
                dashCtrl.fnBtnAkun();
              }),
        ],
      ),
    );
  }

  Widget kotakTanggal(String tgl, String jm, String jk) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiusMed),
        color: warnaPutih,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// tanggal
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: TextFormatting(
                    text: tgl,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.end,
                  )),
            ),

            /// jm, jk
            Flexible(
              child: Container(
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: imgIcoIn),
                    Flexible(child: textIsi(jm))
                  ]),
                  Row(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: imgIcoOut),
                    Flexible(
                      child: Container(
                          child: (() {
                        if (jk == "") {
                          return textIsiGray("[Belum]");
                        } else {
                          return textIsi(jk.substring(0, 5));
                        }
                      }())),
                    )
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kotakPoin(String poin) {
    return Container(
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned.fill(child: imgKotakTgl),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    textIsiCenter("Poin\n" + poin),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget kotakTglPoin() {
    return Container(
      child: dashCtrl.obx(
          (state) => subKotakTglPoin(
              lastJamKeluar: state!.message.lastJamKeluar,
              lastJamMasuk: state.message.lastJamMasuk,
              lastTglMasuk: state.message.lastTglMasuk,
              poin: state.message.poin),
          onError: (e) => TextFormatting(text: e ?? "Terjadi kesalahan!"),
          onEmpty: subKotakTglPoin(
              lastJamKeluar: '[Kosong]',
              lastJamMasuk: '[Kosong]',
              lastTglMasuk: '[Kosong]',
              poin: '0'),
          onLoading: Container(
              width: double.maxFinite,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: warnaPutih,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(child: LoadingIc()))),
    );
  }

  Widget subKotakTglPoin(
      {required String lastTglMasuk,
      required String lastJamMasuk,
      required String lastJamKeluar,
      required String poin}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            child: kotakTanggal(
                lastTglMasuk == '' ? '[Belum]' : lastTglMasuk,
                lastJamMasuk == '' ? '[Belum]' : lastJamMasuk.substring(0, 5),
                lastJamKeluar),
          ),
        ),
        kotakPoin(poin),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget backButton() {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("data"),
          leading: new IconButton(
            icon: new Icon(Icons.ac_unit),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Future<void> cekKoneksi() async {
    fCekKoneksi = ApiService().cekServer();
    fCekKoneksi.then((value) {
      if (value != true) {
        dialogBox(
            judul: "⚠️Tidak Terhubung!⚠️",
            isi: "Cek koneksi anda! Atau mungkin server sedang sibuk!",
            btn1: "OK",
            warnaBtn1: warnaPrimer,
            warnaTeksBtn1: warnaPutih,
            context: context,
            fnBtn1: () => Get.back());
      }
    });
  }

  /// check if device jailbroken / use mock
// void checkMockorRooted() async {
//   bool isMockGps = await SafeDevice.canMockLocation;
//   // bool isRooted = await SafeDevice.isJailBroken;
//
//
//   if (isMockGps == true) {
//     getDialog(
//         body: ElevatedBtn(isi: 'OK', tekan: () => Get.back()),
//         title: 'Device anda menggunakan FAKE GPS atau GPS MOCK, '
//             'Aplikasi tidak bisa digunakan untuk presensi '
//             'sebelum menggunakan GPS asli dari device!');
//     isNotSafeDevice = true;
//   }
//
//   // if(isRooted == true){
//   //   getDialog(
//   //       body: ElevatedBtn(isi: 'OK', tekan: () => Get.back()),
//   //       title: 'Device anda terdeteksi tidak aman / ROOTED, '
//   //           'Aplikasi tidak bisa digunakan untuk presensi!');
//   //   isNotSafeDevice = true;
//   // }
// }
}
