import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'imgVector.dart';

class CardLaporan extends StatefulWidget {
  Function fnGaleri, fnKamera, fnHapus, fnTanggal, fnImage, fnHapusImg;
  XFile? xFile;
  TextEditingController judulCtrl, uangCtrl, catatanCtrl;
  DateTime tanggal;
  bool isLihat;
  bool iscanEdit;

  CardLaporan(
      {Key? key,
      required this.fnKamera,
      required this.fnGaleri,
      this.xFile,
      required this.fnHapus,
      required this.judulCtrl,
      required this.uangCtrl,
      required this.catatanCtrl,
      required this.tanggal,
      required this.fnTanggal,
      required this.fnImage,
      required this.isLihat,
      required this.fnHapusImg,
      required this.iscanEdit})
      : super(key: key);

  @override
  State<CardLaporan> createState() => _CardLaporanState();
}

class _CardLaporanState extends State<CardLaporan> {
  final kunciWidget = GlobalKey();
  late double ukuran;
  late Function fnGaleri, fnKamera, fnTanggal, fnImage;
  late Function fnHapus, fnHapusImg;
  late String path;
  late DateTime tanggal;
  late TextEditingController judulCtrl, uangCtrl, catatanCtrl;
  late bool isLihat;
  late bool iscanEdit;

  @override
  Widget build(BuildContext context) {
    ukuran = 0;
    fnKamera = widget.fnKamera;
    fnGaleri = widget.fnGaleri;
    fnHapus = widget.fnHapus;
    fnHapusImg = widget.fnHapusImg;
    fnTanggal = widget.fnTanggal;
    bool isGambarIsi = false;
    judulCtrl = widget.judulCtrl;
    uangCtrl = widget.uangCtrl;
    catatanCtrl = widget.catatanCtrl;
    tanggal = widget.tanggal;
    fnImage = widget.fnImage;
    isLihat = widget.isLihat;
    iscanEdit = widget.iscanEdit;

    widget.xFile == null ? path = "" : path = widget.xFile!.path;
    widget.xFile == null ? isGambarIsi = false : isGambarIsi = true;

    // Span cell
    final cells = <SpannableGridCellData>[];

    // upload image
    cells.add(SpannableGridCellData(
        id: "home",
        column: 1,
        row: 1,
        columnSpan: 8,
        rowSpan: 8,
        child: Container(
          child: Visibility(
            visible: !isGambarIsi,
            replacement: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () =>fnImage,
                child: Container(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      // tampilan image
                      Image.file(
                        File(path),
                        fit: BoxFit.fitWidth,
                      ),

                      // tampilan btn overlay
                      Visibility(
                        visible: iscanEdit,
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          child: Visibility(
                            visible: isLihat,
                            child: ElevatedBtn(
                              tekan: () => fnHapusImg,
                              warnaBtn: warnaMerah,
                              isi: "X",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: BtnCamera(
              fnKamera: fnKamera,
              fnGaleri: fnGaleri,
              enabled: iscanEdit,
            ),
          ),
        )));

    // tanggal, pengeluaran
    cells.add(SpannableGridCellData(
      id: "1",
      column: 9,
      row: 1,
      columnSpan: 12,
      rowSpan: 10,
      child: Column(
        children: [
          // tanggal
          Container(
            width: double.infinity,
            child: BtnTanggal(
                tanggal: tanggal, fnTanggal: fnTanggal, enabled: iscanEdit),
          ),

          // pengeluaran
          Container(
            child: InputRupiah(
              label: "Pengeluaran",
              size: 20,
              ctrlteks: uangCtrl,
              enable: iscanEdit,
            ),
          ),
        ],
      ),
    ));

    // ukuran = kunciWidget.currentContext.size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
            children: [
              // item
              InputSingleText(
                label: "Item",
                size: 20,
                ctrlteks: judulCtrl,
                enable: iscanEdit,
              ),

              // camera, tanggal, uang
              SpannableGrid(
                style: SpannableGridStyle(
                  spacing: 4.0,
                ),
                cells: cells,
                columns: 20,
                rows: 10,
                showGrid: false,
                editingStrategy: SpannableGridEditingStrategy.disabled(),
              ),

              // input catatan
              InputMultiText(
                ctrlteks: catatanCtrl,
                label: "Catatan",
                maxLength: 200,
                maxLines: 4,
                minLines: 1,
                enabled: iscanEdit,
              ),

              // btn hapus
              Visibility(
                visible: iscanEdit,
                child: ElevatedBtn(
                  tekan: () => fnHapus,
                  isi: "Hapus",
                  // isPadding: false,
                  warnaBtn: warnaMerah,
                  warnaTeks: warnaPutih,
                  enabled: iscanEdit,
                ),
              ),

              // pembatas
              Container(
                width: double.infinity,
                height: 5,
                color: warnaPutihAbu3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardRoundTop extends StatefulWidget {
  String judul, uang;

  CardRoundTop({Key? key, required this.judul, required this.uang})
      : super(key: key);

  @override
  State<CardRoundTop> createState() => _CardRoundTopState();
}

class _CardRoundTopState extends State<CardRoundTop> {
  late String judul, uang;

  @override
  Widget build(BuildContext context) {
    widget.judul == ""
        ? judul = "undefined"
        : judul = widget.judul;
    widget.uang == ""
        ? uang = "Rp. 0"
        : uang = widget.uang;

    return Container(
      padding: EdgeInsets.all(18),
      height: 120,
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

class TopBarAnggaran extends StatefulWidget {
  TopBarAnggaran(
      {Key? key, required this.anggaran, required this.dibelanjakan})
      : super(key: key);

  String anggaran, dibelanjakan;

  @override
  State<TopBarAnggaran> createState() => _TopBarAnggaranState();
}

class _TopBarAnggaranState extends State<TopBarAnggaran> {
  late String anggaran, dibelanjakan;

  @override
  Widget build(BuildContext context) {
    widget.anggaran == ""
        ? anggaran = "Rp 0"
        : anggaran = widget.anggaran;
    widget.dibelanjakan == ""
        ? dibelanjakan = "Rp 0"
        : dibelanjakan = widget.dibelanjakan;

    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.count(
        shrinkWrap: true,
        clipBehavior: Clip.hardEdge,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 2.0,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          CardRoundTop(
              judul: "Anggaran", uang: uangFormatter(double.parse(anggaran))),
          CardRoundTop(
              judul: "Dibelanjakan",
              uang: uangFormatter(double.parse(dibelanjakan))),
        ],
      ),
    );
  }
}

// widget untuk refresh ketika data kosong
class DataKosong extends StatefulWidget {
  final Function fungsi;

  const DataKosong({Key? key, required this.fungsi}) : super(key: key);

  @override
  State<DataKosong> createState() => _DataKosongState();
}

class _DataKosongState extends State<DataKosong> {
  late Function fungsi;

  @override
  Widget build(BuildContext context) {
    fungsi = widget.fungsi;

    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          ImgDataKosong(),
          Container(
              padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
              child: ElevatedBtn(
                isi: "Refresh",
                tekan: () => fungsi,
              )),
        ],
      ),
    );
  }
}
