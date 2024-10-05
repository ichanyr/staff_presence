import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/AnggaranCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/BottomAppBarElement.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Element/ScrollAndResponsive.dart';
import 'AddAnggaranPage.dart';
import 'DetailAnggaranPage.dart';

// Anggaran page
class AnggaranPage extends StatefulWidget {
  const AnggaranPage({Key? key}) : super(key: key);

  @override
  State<AnggaranPage> createState() => _AnggaranPageState();
}

class _AnggaranPageState extends State<AnggaranPage> {
  AnggaranCtrl anggaranCtrl = Get.put(AnggaranCtrl());
  late SharedPreferences sp;
  late String iduser;

  late DateTime selectedMonth;
  DateTime pilihHari = DateTime.now();

  /// refresh controller
  RefreshController refreshController = RefreshController();

  // widget Build
  @override
  Widget build(BuildContext context) {
    anggaranCtrl.onInit();
    return Scaffold(
      appBar: AppBar(
        title:
            textIsi2(isi: "Anggaran", warna: warnaHitam, fw: FontWeight.bold),
        backgroundColor: warnaPutih,
        foregroundColor: warnaHitam,
        // iconTheme: IconThemeData(color: warnaHitam),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: warnaHitam,
          ),
          onPressed: () {
            Get.to(() => DashboardPage());
            anggaranCtrl.onClose();
          },
        ),
      ),
      // body: SingleChildScrollView(
      //   physics: ScrollPhysics(),
      //   child: ResponsiveWrapper(
      //     child: Container(
      //       padding: EdgeInsets.only(bottom: 50),
      //       child: Column(
      //         children: <Widget>[
      //           BarTanggal(
      //             pilihHari: pilihHari,
      //             fnKurangBln: () => tambahBulan(kanan: false),
      //             fnTambahBln: () => tambahBulan(kanan: true),
      //             fnBulan: () => tampilMonthPicker(),
      //           ),
      //           anggaranCtrl.obx((state) {
      //             return barInfoAtas(state: state, kosong: false);
      //           },
      //               onLoading: TextIsi2(isi: "loading"),
      //               onError: (e) => TextIsi2(isi: "error $e"),
      //               onEmpty: barInfoAtas(kosong: true)),
      //           listAnggaran()
      //         ],
      //       ),
      //     ),
      //     maxWidth: 1200,
      //     minWidth: 400,
      //     defaultScale: true,
      //     breakpoints: [
      //       ResponsiveBreakpoint.resize(480, name: MOBILE),
      //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //       ResponsiveBreakpoint.resize(1000, name: DESKTOP),
      //     ],
      //   ),
      // ),
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () async {
          await anggaranCtrl.getAnggaran();
          refreshController.refreshCompleted();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              BarTanggal(
                pilihHari: pilihHari,
                fnKurangBln: () => tambahBulan(kanan: false),
                fnTambahBln: () => tambahBulan(kanan: true),
                fnBulan: () => tampilMonthPicker(),
              ),
              anggaranCtrl.obx((state) {
                return barInfoAtas(state: state!, kosong: false);
              },
                  onLoading: TextIsi2(isi: "loading"),
                  onError: (e) => TextIsi2(isi: "error $e"),
                  onEmpty: barInfoAtas(
                      kosong: true,
                      state: Anggaran(
                          status: false,
                          message: '',
                          ringkasan: [],
                          data: [],
                          rows: 0))),
              listAnggaran()
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FabTambah(
        tekan: () {
          Get.to(() => AddAnggaranPage(
                tipePage: 1,
                idAnggaran: '0',
              ));
        },
      ),
      bottomNavigationBar: AppBarBawah(),
    );
  }

  // init state
  @override
  void initState() {
    super.initState();
    Future fsp = loadSP();
    fsp.then((value) {
      anggaranCtrl.id.value = iduser;
      anggaranCtrl.onInit();
      anggaranCtrl.getAnggaran();
    });
  }

  // shared preference
  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
    });
  }

  // bawah control bar, bagian info bulan
  Widget barInfoAtas({required Anggaran state, required bool kosong}) {
    String diajukan, diterima, dibelanjakan, sisa;
    int gridCount = 2;
    double lebarDevice = MediaQuery.of(context).size.width;

    gridCount = anggaranCtrl.gridCount(lebar: lebarDevice);

    if (kosong) {
      // diajukan = uangFormatter(0.0).compactSymbolOnLeft;
      // diterima = uangFormatter(0.0).compactSymbolOnLeft;
      // dibelanjakan = uangFormatter(0.0).compactSymbolOnLeft;
      // sisa = uangFormatter(0.0).compactSymbolOnLeft;

      diajukan = uangFormatter(0.0);
      diterima = uangFormatter(0.0);
      dibelanjakan = uangFormatter(0.0);
      sisa = uangFormatter(0.0);
    } else {
      diajukan = uangFormatter(double.parse(state.ringkasan[0].diajukan));
      diterima = uangFormatter(double.parse(state.ringkasan[0].diterima));
      dibelanjakan =
          uangFormatter(double.parse(state.ringkasan[0].dibelanjakan));
      sisa = uangFormatter(double.parse(state.ringkasan[0].sisa));

      // diajukan = uangFormatter(double.parse(state.ringkasan[0].diajukan))
      //     .compactSymbolOnLeft;
      // diterima = uangFormatter(double.parse(state.ringkasan[0].diterima))
      //     .compactSymbolOnLeft;
      // dibelanjakan =
      //     uangFormatter(double.parse(state.ringkasan[0].dibelanjakan))
      //         .compactSymbolOnLeft;
      // sisa = uangFormatter(double.parse(state.ringkasan[0].sisa))
      //     .compactSymbolOnLeft;
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.count(
        shrinkWrap: true,
        // clipBehavior: Clip.hardEdge,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 2.0,
        crossAxisCount: gridCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          BarKotakAtas(judul: "Diajukan", uang: diajukan),
          BarKotakAtas(judul: "Diterima", uang: diterima),
          BarKotakAtas(judul: "Dibelanjakan", uang: dibelanjakan),
          BarKotakAtas(judul: "Sisa", uang: sisa),
        ],
      ),
    );
  }

  // list anggaran
  Widget listAnggaran() {
    // Anggaran listAnggaran = anggaranCtrl.anggaranData.value;
    return Container(
      // margin: EdgeInsets.all(10),
      child: anggaranCtrl.obx(
        (state) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                clipBehavior: Clip.hardEdge,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state!.data.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  double uang = double.parse(state.data[i].nominal);
                  return ListAnggaran(
                      id: state.data[i].id,
                      tanggal: hariTanggal(state.data[i].waktuRequest),
                      jumlah: uang,
                      ket: stringTrimmer(state.data[i].judul, 15),
                      status: state.data[i].status);
                },
              ),
            ],
          );
        },
        onEmpty: DataKosong(
          fungsi: () {
            anggaranCtrl.getAnggaran();
          },
        ),
        onError: (e) => ElevatedBtn(
          isi: "Error $e",
          tekan: () => Get.to(() => DashboardPage()),
        ),
        onLoading: LoadingIc(),
      ),
    );
  }

  // tambah dan kurang bulan
  tambahBulan({required bool kanan}) {
    kanan == true
        ? pilihHari =
            DateTime(pilihHari.year, pilihHari.month + 1, pilihHari.day)
        : pilihHari =
            DateTime(pilihHari.year, pilihHari.month - 1, pilihHari.day);
    anggaranCtrl.bulanSelector.value = pilihHari;
    anggaranCtrl.getAnggaran();
    setState(() {});
  }

  // month picker
  tampilMonthPicker() {
    // initialDate: DateTime.now();
    DateTime initialDate = pilihHari;
    // DateTime selectedDate = initialDate;
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: initialDate,
      locale: Locale("en"),
    ).then((date) {
      if (date != null) {
        pilihHari = date;
        anggaranCtrl.bulanSelector.value = date;
        anggaranCtrl.getAnggaran();
        setState(() {});
      }
    });
  }
}

// widget list anggaran
class ListAnggaran extends StatefulWidget {
  final String tanggal, ket, id, status;
  final double jumlah;

  const ListAnggaran(
      {Key? key,
      required this.tanggal,
      required this.ket,
      required this.jumlah,
      required this.status,
      required this.id})
      : super(key: key);

  @override
  State<ListAnggaran> createState() => _ListAnggaranState();
}

class _ListAnggaranState extends State<ListAnggaran> {
  late String tanggal, ket, id, status;
  late double jumlah;

  @override
  Widget build(BuildContext context) {
    tanggal = widget.tanggal;
    ket = widget.ket;
    jumlah = widget.jumlah;
    status = widget.status;
    id = widget.id;

    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () => {
          Get.to(() => DetailAnggaranPage(
                tipePage: 1,
                id: id,
              ))
        },
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // tanggal
              TextIsi2(
                isi: tanggal,
                warna: warnaHitam,
                fw: FontWeight.bold,
              ),

              // jumlah
              TextIsi2(
                isi: uangFormatter(jumlah),
                warna: warnaHitam,
                fw: FontWeight.bold,
              ),

              // keterangan
              TextIsi2(
                isi: ket,
                warna: warnaHitam,
                fw: FontWeight.bold,
              ),

              // status icon
              IconStatus(status: status)
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaPutih,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// widget kota uang bar atas
class BarKotakAtas extends StatefulWidget {
  final String judul, uang;

  const BarKotakAtas({Key? key, required this.judul, required this.uang})
      : super(key: key);

  @override
  State<BarKotakAtas> createState() => _BarKotakAtasState();
}

class _BarKotakAtasState extends State<BarKotakAtas> {
  late String judul, uang;

  @override
  Widget build(BuildContext context) {
    judul = widget.judul;
    uang = widget.uang;
    return Container(
      padding: EdgeInsets.all(18),
      // height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextIsi2(
            isi: judul,
            warna: warnaHitam,
            fw: FontWeight.bold,
          ),
          TextIsi2(
            isi: uang,
            warna: warnaHitam,
            fw: FontWeight.bold,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: warnaBgPink,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// Bar atas, tanggal
class BarTanggal extends StatefulWidget {
  final DateTime pilihHari;
  final Function fnTambahBln, fnKurangBln, fnBulan;

  const BarTanggal(
      {Key? key,
      required this.pilihHari,
      required this.fnTambahBln,
      required this.fnKurangBln,
      required this.fnBulan})
      : super(key: key);

  @override
  State<BarTanggal> createState() => _BarTanggalState();
}

class _BarTanggalState extends State<BarTanggal> {
  late DateTime pilihHari;
  late String showBulan;
  late Function fnTambahBln, fnKurangBln, fnBulan;

  @override
  Widget build(BuildContext context) {
    pilihHari = widget.pilihHari;
    showBulan = bulanTahunShow(pilihHari);
    fnTambahBln = widget.fnTambahBln;
    fnKurangBln = widget.fnKurangBln;
    fnBulan = widget.fnBulan;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // tombol kembali
              btnBulanNav(tekan: fnKurangBln),

              // tombol bulan
              ElevatedButton(
                onPressed: () => fnBulan,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: textIsi2(
                      isi: showBulan, warna: warnaPrimer, fw: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaBgPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // tombol selanjutnya
              RotationTransition(
                turns: AlwaysStoppedAnimation(180 / 360),
                child: btnBulanNav(tekan: fnTambahBln),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: warnaPutih,
            boxShadow: [
              BoxShadow(
                color: warnaPutihAbu5,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
