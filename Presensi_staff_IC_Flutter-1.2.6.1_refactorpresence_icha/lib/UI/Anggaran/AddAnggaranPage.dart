import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Anggaran/AnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/DetailAnggaranCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/TambahAnggaranCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/DetailAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller/EditAnggaranCtrl.dart';

class AddAnggaranPage extends StatefulWidget {
  final int tipePage;
  final String idAnggaran;

  const AddAnggaranPage(
      {Key? key, required this.tipePage, required this.idAnggaran})
      : super(key: key);

  @override
  State<AddAnggaranPage> createState() => _AddAnggaranPageState();
}

class _AddAnggaranPageState extends State<AddAnggaranPage> {
  late int tipePage;
  late String btnSimpanTeks, judulAppBar, iduser, nominal_numOnly;
  TambahAnggaranCtrl tambahCtrl = Get.put(TambahAnggaranCtrl());
  EditAnggaranController editCtrl = Get.put(EditAnggaranController());
  DetailAnggaranController detailCtrl = Get.put(DetailAnggaranController());
  TextEditingController judulCtrl = new TextEditingController();
  TextEditingController ketCtrl = new TextEditingController();
  TextEditingController nominalCtrl = new TextEditingController();
  late Future<TambahAnggaranModel> fTambah;
  late SharedPreferences sp;
  late String idAnggaran;

  @override
  void initState() {
    super.initState();
    Future fsp = loadSP();
    tambahCtrl.onReady();
    fsp.then((value) {
      tambahCtrl.idstaf.value = iduser;
    });
  }

  // load untuk sharedpreference
  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
    });
  }

  // pengecekan jika halaman merupakan edit page
  cekPageIsEdit() {
    if (tipePage == 0) {
      detailCtrl.idDetailAnggaran.value = idAnggaran.toString();
      Future<void> fDetail = detailCtrl.getDetailAnggaran();
      fDetail.then((value) {
        if (detailCtrl.detailAnggaranData.value.status == true) {
          judulCtrl.text = detailCtrl.detailAnggaranData.value.data[0].judul;
          ketCtrl.text = detailCtrl.detailAnggaranData.value.data[0].keterangan;
          nominalCtrl.text =
              detailCtrl.detailAnggaranData.value.data[0].nominal;
        }
      });

      // setState(() {});
    }
  }

  // saat build
  @override
  Widget build(BuildContext context) {
    idAnggaran = widget.idAnggaran ?? "0";
    tipePage = widget.tipePage ?? 0;
    tipePage == 1 ? btnSimpanTeks = "Simpan" : btnSimpanTeks = "Tambah";
    tipePage == 1
        ? judulAppBar = "Ubah Anggaran"
        : judulAppBar = "Tambah Anggaran";
    cekPageIsEdit();

    return Scaffold(
        appBar: AppBar(
          title: textIsi2(
              isi: judulAppBar, warna: warnaHitam, fw: FontWeight.bold),
          backgroundColor: warnaPutih,
          foregroundColor: warnaHitam,
          iconTheme: IconThemeData(color: warnaHitam),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: isiPage(),
        ),
        bottomSheet: idAnggaran == "0"
            ? ElevatedBtn(
                tekan: () => fnTambah(),
                isi: btnSimpanTeks,
              )
            : ElevatedBtn(
                tekan: () => fnSimpan(),
                isi: "Simpan",
              ));
  }

  // isi page
  Widget isiPage() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 50),
      child: Column(
        children: <Widget>[
          // input judul
          InputSingleText(
            label: "Judul",
            ctrlteks: judulCtrl,
          ),

          // input keterangan
          InputMultiText(
            maxLength: 500,
            label: "Keterangan",
            minLines: 2,
            ctrlteks: ketCtrl,
          ),

          // input nominal
          InputRupiah(
            ctrlteks: nominalCtrl,
            label: "Nominal",
          )
        ],
      ),
    );
  }

  fnTambah() {
    nominal_numOnly = nominalCtrl.text.replaceAll(new RegExp(r'[^0-9]'), '');

    tambahCtrl.judul.value = judulCtrl.text;
    tambahCtrl.ket.value = ketCtrl.text;
    tambahCtrl.nominal.value = nominal_numOnly;

    fTambah = tambahCtrl.postAnggaran();
    fTambah.then((value) {
      if (tambahCtrl.anggaranData.value.status == true) {
        Get.snackbar("Berhasil", tambahCtrl.anggaranData.value.message,
            backgroundColor: warnaBiru);
        Get.to(() => AnggaranPage());
      } else {
        Get.snackbar("Gagal", tambahCtrl.anggaranData.value.message,
            backgroundColor: warnaMerah);
      }
    });
  }

  fnSimpan() {
    nominal_numOnly = nominalCtrl.text.replaceAll(new RegExp(r'[^0-9]'), '');

    tambahCtrl.judul.value = judulCtrl.text;
    tambahCtrl.ket.value = ketCtrl.text;
    tambahCtrl.nominal.value = nominal_numOnly;

    editCtrl.judul.value = judulCtrl.text;
    editCtrl.id.value = idAnggaran;
    editCtrl.nominal.value = int.parse(nominal_numOnly);
    editCtrl.idstaf.value = iduser;
    editCtrl.ket.value = ketCtrl.text;
    fTambah = editCtrl.putAnggaran();
    fTambah.then((value) {
      if (editCtrl.anggaranData.value.status == true) {
        Get.snackbar("Berhasil", editCtrl.anggaranData.value.message,
            backgroundColor: warnaBiru);
        Get.to(() => AnggaranPage());
      } else {
        Get.snackbar("Gagal", editCtrl.anggaranData.value.message,
            backgroundColor: warnaMerah);
      }
    });
  }
}
