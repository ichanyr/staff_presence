import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Anggaran/AddAnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Anggaran/AnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/KurangiAnggaranCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/SettingAppsCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/LaporAnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controller/DetailAnggaranCtrl.dart';
import 'Model/DetailAnggaranModel.dart';
import 'Model/KurangAnggaranModel.dart';
import 'Model/TambahAnggaranModel.dart';

class DetailAnggaranPage extends StatefulWidget {
  final int tipePage;
  final String id;

  const DetailAnggaranPage(
      {Key? key, required this.tipePage, required this.id})
      : super(key: key);

  @override
  State<DetailAnggaranPage> createState() => _DetailAnggaranPageState();
}

class _DetailAnggaranPageState extends State<DetailAnggaranPage> {
  late int tipePage;
  late String btnBawahTeks, id;
  DetailAnggaranController daCtrl = Get.put(DetailAnggaranController());
  SettingController settingCtrl = Get.put(SettingController());
  KurangiAnggaranController kurangiCtrl = Get.put(KurangiAnggaranController());
  late Function btnBawahFn;
  late int statusBtn;
  bool isDeadlineVisible = false, isBtnLapor = false;

  late SharedPreferences sp;
  late String idstaf;
  late String idAnggaran;

  // data load value
  late String judul, ket, feedback, status;
  late double nominal;
  late DateTime waktu, deadline;

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      idstaf = (sp.getString('iduser') ?? '');
      kurangiCtrl.idstaf.value = idstaf;
    });
  }

  @override
  Widget build(BuildContext context) {
    // on init controller
    initController();

    return Scaffold(
        appBar: AppBar(
          title: textIsi2(
              isi: "Detail Anggaran", warna: warnaHitam, fw: FontWeight.bold),
          backgroundColor: warnaPutih,
          foregroundColor: warnaHitam,
          iconTheme: IconThemeData(color: warnaHitam),
          actions: [
            daCtrl.obx((state) {
              if (state!.data[0].status == "pending") {
                return IconButton(
                    onPressed: () => dialogHapusAnggaran(),
                    icon: Icon(
                      Icons.delete,
                      color: warnaMerah,
                    ));
              } else {
                return Container();
              }
            })
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: daCtrl.obx((state) {
            return isiPage(state!);
          }, onEmpty: DataKosong(
            fungsi: () {
              daCtrl.getDetailAnggaran();
            },
          ), onError: (e) => TextIsi2(isi: "error $e"), onLoading: LoadingIc()),
        ),
        bottomSheet: daCtrl.obx((state) {
          isBtnLapor = lihatBtnLapor(state!.data[0].status);
          return Visibility(
            visible: isBtnLapor,
            child: ElevatedBtn(
              tekan: () => btnBawahFn,
              isi: btnBawahTeks,
            ),
          );
        }));
  }

  // init state
  @override
  void initState() {
    super.initState();
    daCtrl.onReady();
    settingCtrl.onReady();
    loadSP();
  }

  initController() async {
    id = widget.id;
    daCtrl.idDetailAnggaran.value = id;
    daCtrl.onInit();
    tipePage = widget.tipePage;
    btnBawahTeks = "Ubah";

    kurangiCtrl.id.value = id;

    // penentuan tipe page
    tentukanTipePage();
  }

  // isi page
  Widget isiPage(DetailAnggaran state) {
    judul = state.data[0].judul;
    ket = state.data[0].keterangan;
    nominal = double.parse(state.data[0].nominal);
    feedback = state.data[0].feedback ?? '';
    status = state.data[0].status;
    waktu = state.data[0].waktuRequest;
    deadline = state.data[0].deadline;
    idAnggaran = state.data[0].id;

    bool isKet = false, isFeedback = false, isLihatFeedback = false;
    ket == "" || ket == null ? isKet = false : isKet = true;
    isLihatFeedback = lihatFeedback(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(margin: EdgeInsets.only(bottom: 10), child: garisBatas()),
          textLine(isi: judul),
          Visibility(
            child: textLine(isi: ket),
            visible: isKet,
            replacement: textLine(isi: "[Keterangan Kosong]"),
          ),
          // textLine(isi: ket),
          textLine(isi: uangFormatter(nominal)),
          Visibility(
            visible: isLihatFeedback,
            child: Visibility(
              child: textLine(isi: feedback),
              visible: isFeedback,
              replacement: textLine(isi: "[Feedback Kosong]"),
            ),
          ),
          textLine(isi: prettyDT(waktu)),

          // teks deadline
          settingCtrl.obx((state) {
            return Visibility(
              child: textLine(isi: prettyDT(deadline)),
              visible: isDeadlineVisible,
            );
          }),

          // btn ubah anggaran
          Visibility(
              visible: lihatBtnEditAnggaran(status),
              child: ElevatedBtn(
                  isi: "Ubah Anggaran",
                  tekan: () => Get.to(() => AddAnggaranPage(
                        tipePage: 0,
                        idAnggaran: idAnggaran,
                      )))),

          // btn status
          Container(
            margin: EdgeInsets.only(top: 50),
            child: BtnStatus(
              tekan: () => print("Tambah"),
              // isi: "Belum dikonfirmasi",
              isi: status,
              status: status,
            ),
          )
        ],
      ),
    );
  }

  // teks + garis
  Widget textLine({required String isi}) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[TextIsi2(isi: isi), garisBatas()],
      ),
    );
  }

  // garis antar teks
  Widget garisBatas() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 2,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: warnaBgPink,
      ),
    );
  }

  // tentukan tipe halaman
  tentukanTipePage() {
    if (tipePage == 0) {
      // Ubah Anggaran
      btnBawahTeks = "Ubah";
      statusBtn = 0;
      btnBawahFn = () => Get.to(() => AddAnggaranPage(tipePage: 1, idAnggaran: '0'));
    } else {
      // Laporkan Anggaran
      statusBtn = 1;
      btnBawahTeks = "Laporan";
      btnBawahFn = () => Get.to(() => LaporAnggaranPage(
            idAnggaran: int.parse(idAnggaran),
            judul: judul,
            status: status,
          ));
    }
  }

  // dialog hapus Anggaran
  dialogHapusAnggaran() {
    dialogBox(
      judul: "Hapus Anggaran ?",
      context: context,
      isi: "Ingin Menghapus Anggaran ?",
      btn1: "Ya, Hapus",
      btn2: "Tidak",
      warnaBtn1: warnaMerah,
      warnaTeksBtn1: warnaPutih,
      fnBtn1: () => hapusAnggaran(),
      fnBtn2: () => Navigator.pop(context),
    );
  }

  // hapus anggaran
  hapusAnggaran() {
    Future<void> fKurang = kurangiCtrl.delAnggaran();
    fKurang.then((value) {
      if (kurangiCtrl.status.isLoading != true) {
        if (kurangiCtrl.status.isSuccess) {
          Get.snackbar("Berhasil", kurangiCtrl.anggaranDataKurang.value.message,
              backgroundColor: warnaBiru);
          Navigator.pop(context);
          Get.to(() => AnggaranPage());
        } else {
          Get.snackbar("Gagal", kurangiCtrl.anggaranDataKurang.value.message,
              backgroundColor: warnaMerah);
        }
      }
    });
  }
}
