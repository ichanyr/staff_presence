import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/Helper/Waktu.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Lembur/controller/TambahLemburController.dart';

import '../../assets/TextCustom.dart';
import '../../assets/ukuran.dart';
import '../Element/ScrollAndResponsive.dart';

class TambahLemburPage extends StatefulWidget {
  TambahLemburPage({Key? key, this.id, this.mulai, this.selesai, this.ket})
      : super(key: key);

  final String? id;
  final DateTime? mulai;
  final DateTime? selesai;
  final String? ket;

  @override
  State<TambahLemburPage> createState() => _TambahLemburPageState();
}

class _TambahLemburPageState extends State<TambahLemburPage> {
  /// Controller
  TambahLemburController tambahCtrl = Get.put(TambahLemburController());

  ///helper
  WaktuHelper waktuHelper = WaktuHelper();

  @override
  Widget build(BuildContext context) {
    /// cek jika edit controller
    if (widget.id != null && widget.mulai != null && widget.selesai != null) {
      tambahCtrl.idLembur.value = widget.id ?? '';
      tambahCtrl.tanggalPilih.value = widget.mulai ?? DateTime.now();
      tambahCtrl.tanggalPilihSelesai.value = widget.selesai ?? DateTime.now();
      tambahCtrl.ketCtrl.value.text = widget.ket ?? '';

      tambahCtrl.stringBtnAction.value = 'Ubah';
    }

    return Scaffold(
      appBar: AppBar(
        title: TextFormatting(text: 'Tambah Lembur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganResponsive(
        child:
            Container(padding: EdgeInsets.all(marginTepi), child: listWidget()),
      ),
      bottomNavigationBar: btnAjukan(),
    );
  }

  Widget listWidget() {
    return Column(
      children: [
        /// Tanggal
        Container(
            margin: EdgeInsets.only(bottom: marginDidalamContent),
            child: tanggal()),

        /// jam Mulai,
        Container(
            margin: EdgeInsets.only(bottom: marginDidalamContent),
            child: waktuMulai()),

        /// jam Mulai,
        Container(
            margin: EdgeInsets.only(bottom: marginDidalamContent),
            child: waktuSelesai()),

        /// Ket
        keterangan(),
      ],
    );
  }

  /// datepicker
  Widget tanggal() {
    return ElevatedBtnWidget(
      warnaBtn: warnaPutih,
      tekan: () async {
        await tambahCtrl.fnAmbilTanggal();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// icon
          Padding(
            padding: EdgeInsets.only(right: marginMin),
            child: Icon(
              Icons.calendar_month,
              color: warnaPrimer,
            ),
          ),

          /// teks
          Flexible(
            child: Obx(() => TextFormatting(
                text: 'Tanggal '
                    '${waktuHelper.dateToString(waktu: tambahCtrl.tanggalPilih.value.toString(), tipeWaktus: TipeWaktus.LongDate)}')),
          )
        ],
      ),
    );
  }

  /// timepicker
  Widget waktuMulai() {
    return ElevatedBtnWidget(
        warnaBtn: warnaPutih,
        tekan: () async {
          await tambahCtrl.fnAmbilJam();
        },
        child: Obx(() => TextFormatting(
            text: 'Jam mulai : '
                '${waktuHelper.dateToString(waktu: tambahCtrl.tanggalPilih.value.toString(), tipeWaktus: TipeWaktus.OnlyTimeShort)}')));
  }

  /// timepicker
  Widget waktuSelesai() {
    return ElevatedBtnWidget(
        warnaBtn: warnaPutih,
        tekan: () async {
          await tambahCtrl.fnAmbilJamSelesai();
        },
        child: Obx(() => TextFormatting(
            text: 'Jam selesai : '
                '${waktuHelper.dateToString(waktu: tambahCtrl.tanggalPilihSelesai.value.toString(), tipeWaktus: TipeWaktus.OnlyTimeShort)}')));
  }

  /// keterangan
  Widget keterangan() {
    return InputMultiText(
      ctrlteks: tambahCtrl.ketCtrl.value,
      hint: 'Isikah keterangan yang perlu ditambahkan',
      label: 'Keterangan',
      maxLines: 3,
      maxLength: 100,
      minLines: 1,
    );
  }

  /// btn tambah
  Widget btnAjukan() {
    return Obx(
      () => ElevatedBtn(
        isi: tambahCtrl.stringBtnAction.value,
        warnaTeks: warnaPutih,
        warnaBtn: warnaPrimer,
        isPadding: true,
        tekan: () async {
          tambahCtrl.fnAjukanLembur();
        },
      ),
    );
  }
}
