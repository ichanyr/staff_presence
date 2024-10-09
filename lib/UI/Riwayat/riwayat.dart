import 'dart:ffi';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/ListView.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/PoinController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/RiwayatController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/detailRiwayatPager.dart';
import 'package:presensi_ic_staff/UI/Riwayat/detailRiwayats.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/riwayat.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';

class RiwayatPages extends StatefulWidget {
  RiwayatPages({Key? key}) : super(key: key);

  @override
  _RiwayatPages createState() => _RiwayatPages();
}

class _RiwayatPages extends State<RiwayatPages> {
  int _counter = 0;
  late SharedPref sp = SharedPref();
  late String iduser;
  List<String> listIdr = [];
  List<String> listKosong = [];
  List<int> listInt = [];
  List<String> listInt2String = [];

  /// controller
  PoinController poinCtrl = Get.put(PoinController());
  RiwayatController riwayatCtrl = Get.put(RiwayatController());
  RefreshController refreshController = RefreshController();

  loadSP() async {
    await sp.onInit();
    iduser = sp.getIdstaf();
    setState(() {
      iduser = iduser;
      // iduser = (sp.getString('iduser') ?? '');
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
    return Scaffold(
      appBar: AppBar(
        title: tvRiwayatAppBar,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () async {
          await riwayatCtrl.getRiwayat();
          await poinCtrl.getPoin();
          refreshController.refreshCompleted();
        },
        child: Column(
          children: <Widget>[barAtasRiwayat(), tampilFilter()],
        ),
      ),
    );
  }

  Widget tampilFilter() {
    String tahun, bulan;
    return riwayatCtrl.obx(
      (state) => cardRiwayat(state!),
      onLoading: LoadingIc(),
      onEmpty: cardRiwayat(RiwayatModel(
          status: false,
          message: '',
          data: [
            DataRiwayat(
                idStaff: '',
                poin: '0',
                lastTglMasuk: '',
                lastJamMasuk: '',
                lastJamKeluar: '',
                izin: '',
                idRiwayat: '')
          ],
          rows: 0)),
      onError: (e) => TextFormatting(text: e!),
    );
    // if (selectedMonth != null) {
    //   // return null;
    //   tahun = selectedMonth.toString().substring(0, 4);
    //   bulan = selectedMonth.toString().substring(5, 7);
    //   Future<RiwayatModel> getRiwayat = ApiService().getRiwayatFilter(iduser, tahun, bulan);
    //   return FutureBuilder<RiwayatModel>(
    //       future: ApiService().getRiwayatFilter(iduser, tahun, bulan),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           if (snapshot.data!.rows == 0) {
    //             return Container(
    //               margin: const EdgeInsets.only(bottom: 150),
    //               child: DataKosong(
    //                   fungsi: () => ApiService().getRiwayats(iduser)),
    //             );
    //           } else {
    //             return cardRiwayat(snapshot.data!);
    //           }
    //         } else {
    //           return LoadingIc();
    //         }
    //       });
    // } else {
    //   return FutureBuilder<RiwayatModel>(
    //       future: ApiService().getRiwayats(iduser),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           if (snapshot.data!.rows == 0) {
    //             return DataKosong(
    //                 fungsi: () => ApiService().getRiwayats(iduser));
    //           } else {
    //             return cardRiwayat(snapshot.data!);
    //           }
    //         } else {
    //           return LoadingIc();
    //         }
    //       });
    // }
  }

  Widget cardRiwayat(RiwayatModel snap) {
    /// cek jika ada isinya
    if (snap.status == true) {
      listInt.clear();
      snap.data.forEach((idr) {
        saveIdR(idr.idRiwayat!);
        testingUrutan(idr.idRiwayat!);
      });
      sortList();

      // sp.setStringList("idr", listKosong);
      // listIdr = listIdr.toSet().toList();
      // listIdr.sort();
      // sp.setStringList("idr", listIdr);
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 130),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: snap.data.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            String tgl, jm, jk, izin, idriwayat;
            bool iconVisibility = true;

            tgl = snap.data[index].lastTglMasuk ?? '[Belum]';
            jm = snap.data[index].lastJamMasuk ?? '[Belum]';
            jk = snap.data[index].lastJamKeluar ?? '[Belum]';
            izin = snap.data[index].izin!;
            idriwayat = snap.data[index].idRiwayat!;

            jm.length > 7 ? jm = jm.substring(0, 5) : jm = jm;
            jk.length > 7 ? jk = jk.substring(0, 5) : jk = jk;

            if (izin == 'i' || izin == 'c' || izin == 's' || izin == 'a') {
              jm = '';
              jk = tentukanIzin(izin: izin);
              iconVisibility = false;
            }

            List<String> idr = sp.getIdrs();

            return GestureDetector(
              onTap: () => riwayatCtrl.gotoDetailRiwayat(idriwayat: idriwayat),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // tgl masuk
                      Expanded(child: TextFormatting(text: tgl)),

                      // jam masuk
                      Flexible(
                        child: Row(
                          children: [
                            /// icon in
                            Visibility(visible: iconVisibility, child: imgIcoIn),
                            SizedBox(width: 15),

                            /// jm
                            Flexible(child: TextFormatting(text: jm))
                          ],
                        ),
                      ),

                      // jam keluar
                      Flexible(
                        child: Row(
                          children: [
                            /// ico out
                            Visibility(visible: iconVisibility, child: imgIcoOut),
                            SizedBox(width: 15),

                            /// jam keluar
                            Flexible(child: TextFormatting(text: jk))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    /// jika kosong
    else {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 130),
        child: SizedBox.shrink(),
      );
    }
  }

  tentukanIzin({required String izin}) {
    String kembalian;
    izin = izin.toLowerCase();
    switch (izin) {
      case 's':
        kembalian = 'Sakit';
        break;
      case 'i':
        kembalian = 'Izin';
        break;
      case 'a':
        kembalian = 'Alpha';
        break;
      case 'c':
        kembalian = 'Cuti';
        break;
      default:
        kembalian = 'Izin';
        break;
    }

    return kembalian;
  }

  tampilMonthPicker(BuildContext context) {
    showMonthPicker(
      context: Get.context!,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: riwayatCtrl.initialDatetime.value,
      locale: Locale("en"),
    ).then((date) async {
      if (date != null) {
        // setState(() {
        riwayatCtrl.selectedDatetime.value = date;
        riwayatCtrl.isLihat.value = !riwayatCtrl.isLihat.value;
        poinCtrl.selectedDatetime.value = date;
        await poinCtrl.getPoin();
        await riwayatCtrl.getRiwayat();
        // });
      }
    });
  }

  Widget barAtasRiwayat() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [btnPoin(), btnFilterReset()],
        ),
      ),
    );
  }

  Widget btnPoin() {
    return poinCtrl.obx((state) => btnPoints(state!.total.toString()),
        onError: (e) => btnPoints('[Error]'),
        onEmpty: btnPoints('0'),
        onLoading: Container(
            height: 20, width: 100, child: Center(child: LoadingIc())));
  }

  Widget btnFilterReset() {
    return Row(
      children: [
        btnResetFilter(),
        Container(
          child: btnFilters(),
          margin: const EdgeInsets.only(left: 10),
        )
      ],
    );
  }

  Widget btnFilters() {
    return Container(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // background
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 20,
                  width: 20,
                  child: imgFilter),
              tvFilter,
            ],
          ),
        ),
        onPressed: () {
          tampilMonthPicker(context);
        },
      ),
    );
  }

  Widget btnResetFilter() {
    return Obx(() => Visibility(
          visible: riwayatCtrl.isLihat.value,
          child: Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // background
              ),
              child:
                  Padding(padding: const EdgeInsets.all(5.0), child: imgReset),
              onPressed: () async {
                riwayatCtrl.isLihat.value = false;
                riwayatCtrl.selectedDatetime.value = DateTime.now();
                poinCtrl.selectedDatetime.value = DateTime.now();
                await poinCtrl.getPoin();
                await riwayatCtrl.getRiwayat();
              },
            ),
          ),
        ));
  }

  Widget btnPoints(String poin) {
    return Container(
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // background
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [tvPoin, textIsi(poin)],
          ),
        ),
        onPressed: () {
          // showSukses("Anda sudah mendapat " + poin + " Poin", context);
          poinCtrl.showResumePoin();
        },
      ),
    );
  }

  void saveIdR(String idRiwayat) {
    listIdr.add(idRiwayat);
  }

  testingUrutan(String idRiwayat) {
    listInt.add(int.tryParse(idRiwayat)!);
  }

  Future<void> sortList() async {
    listInt = listInt.toSet().toList();
    // listInt.sort();
    // listInt.forEach((element) {
    // });
    listInt2String.clear();
    listInt2String.addAll(listInt.map((e) => e.toString()));
    await sp.delIdrs();
    await sp.setIdrs(listInt2String);
    // setState(() {
    //   // sp.getStringList("idrs");
    // });
  }
}
