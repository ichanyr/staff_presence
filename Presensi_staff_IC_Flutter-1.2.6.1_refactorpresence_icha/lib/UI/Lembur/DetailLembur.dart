import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/Helper/Waktu.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Lembur/controller/LemburController.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/LemburModel.dart';

import '../../assets/TextCustom.dart';
import '../../assets/ukuran.dart';
import '../Element/ScrollAndResponsive.dart';

class DetailLembur extends StatefulWidget {
  DetailLembur({Key? key, required this.dataLembur}) : super(key: key);

  final DataLembur dataLembur;

  @override
  State<DetailLembur> createState() => _DetailLemburState();
}

class _DetailLemburState extends State<DetailLembur> {
  LemburController lemburCtrl = Get.put(LemburController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormatting(text: 'Detail Lembur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganResponsive(
        child: Container(
          padding: EdgeInsets.all(marginTepi),
          child: listData(),
        ),
      ),
      bottomNavigationBar: btnNavbar(),
    );
  }

  Widget btnNavbar() {
    return Visibility(
      visible: widget.dataLembur.status.toLowerCase() == 'pending',
      replacement: SizedBox.shrink(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// btn Hapus
            ElevatedBtn(
              isMargin: false,
              isi: 'Hapus Lembur',
              tekan: () async {
                await lemburCtrl.fnPromptHapus(
                    idLembur: widget.dataLembur.idLembur);
              },
              warnaBtn: warnaMerah,
              warnaTeks: warnaPutih,
            ),

            /// btn Edit
            ElevatedBtn(
              tekan: () {
                lemburCtrl.fnGotoEditLembur(
                    id: widget.dataLembur.idLembur,
                    ket: widget.dataLembur.keterangan,
                    mulai: widget.dataLembur.mulai,
                    selesai: widget.dataLembur.selesai);
              },
              isMargin: false,
              isi: 'Edit Lembur',
              warnaBtn: warnaPrimer,
              warnaTeks: warnaPutih,
            ),
          ],
        ),
      ),
    );
  }

  Widget listData() {
    return Container(
      child: Column(
        children: [
          /// tangal
          wData(
              data: WaktuHelper().dateToString(
                  waktu: widget.dataLembur.mulai.toString(),
                  tipeWaktus: TipeWaktus.LongDate),
              title: 'Tanggal'),

          /// jam Mulai
          wData(
              data: WaktuHelper().dateToString(
                  waktu: widget.dataLembur.mulai.toString(),
                  tipeWaktus: TipeWaktus.OnlyTimeShort),
              title: 'Jam Mulai'),

          /// jam Selsai
          wData(
              data: WaktuHelper().dateToString(
                  waktu: widget.dataLembur.selesai.toString(),
                  tipeWaktus: TipeWaktus.OnlyTimeShort),
              title: 'Jam Selesai'),

          /// total jam
          wData(data: widget.dataLembur.totalJam + ' Jam', title: 'Total Jam'),

          /// keterangan
          wData(
              data: widget.dataLembur.keterangan.toString(),
              title: 'Keterangan'),

          /// response
          wResponse(),

          /// divider
          Divider(
            thickness: 5,
            height: marginDidalamContent,
          ),

          /// status
          statusLembur(),
        ],
      ),
    );
  }

  Widget wResponse() {
    return Visibility(
      visible: widget.dataLembur.masukan.length >= 1,
      child: Container(
        child: wData(title: 'Respons', data: widget.dataLembur.masukan),
      ),
    );
  }

  /// single data
  Widget wData({required String title, required String data}) {
    if (data == '') {
      data = '[Kosong]';
    }

    return Container(
      child: Column(
        children: [
          Divider(
            thickness: 5,
            height: marginDidalamContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: TextFormatting(text: title)),
              Expanded(child: TextFormatting(text: data, textAlign: TextAlign.end,overflow: TextOverflow.visible,)),
            ],
          ),
        ],
      ),
    );
  }

  /// status
  Widget statusLembur() {
    Icon iconStatus = Icon(Icons.hourglass_bottom);
    Color warnaBtn = warnaAbu;

    /// ubah sesuaikan icon
    if (widget.dataLembur.status.toLowerCase() == 'accept') {
      iconStatus = Icon(Icons.check);
      warnaBtn = warnaPrimer;
    }
    if (widget.dataLembur.status.toLowerCase() == 'refused') {
      iconStatus = Icon(Icons.cancel);
      warnaBtn = warnaMerah;
    }

    return ElevatedBtnWidget(
      warnaBtn: warnaBtn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormatting(text: 'Status', color: warnaPutih),
          Row(
            children: [
              /// text
              TextFormatting(text: widget.dataLembur.status, color: warnaPutih),
              SizedBox(width: marginDidalamContent / 2),

              /// icon
              iconStatus,
            ],
          )
        ],
      ),
    );
  }
}
