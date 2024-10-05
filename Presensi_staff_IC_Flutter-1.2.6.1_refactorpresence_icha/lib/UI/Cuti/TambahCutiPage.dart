import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Cuti/Controller/CutiController.dart';
import 'package:presensi_ic_staff/UI/Cuti/Controller/TambahCutiController.dart';
import 'package:presensi_ic_staff/UI/Cuti/CutiPage.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/card.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';

import '../Element/button.dart';
import '../Element/textView.dart';
import 'Model/CutiModel.dart';
import 'package:intl/intl.dart';

class TambahCutiPage extends StatefulWidget {
  final DateTime dari, sampai;
  final String ket, izin;
  final String id;

  const TambahCutiPage(
      {Key? key,
      required this.dari,
      required this.sampai,
      required this.ket,
      required this.izin,
      required this.id})
      : super(key: key);

  @override
  State<TambahCutiPage> createState() => _TambahCutiPageState();
}

class _TambahCutiPageState extends State<TambahCutiPage> {
  late CutiController cutiCtrl;
  late TambahCutiController tambahCtrl;
  late CutiModel cutiModel;
  late DateTime dariWidget, sampaiWidget;

  late String ketWidget, izinWidget;
  late String btnSimpanLabel;
  late String id;

  @override
  Widget build(BuildContext context) {
    // value dari widget
    dariWidget = widget.dari ?? DateTime.now();
    sampaiWidget = widget.sampai ?? DateTime.now();
    id = widget.id;
    ketWidget = widget.ket;
    izinWidget = widget.izin;

    // controller
    cutiCtrl = Get.put(CutiController());
    tambahCtrl = Get.put(TambahCutiController());
    cutiModel = cutiCtrl.cutiData.value;
    String cutiTahunan = cutiModel.jatahCuti[0].cuti;
    String sakit = cutiModel.sum.sakit,
        izin = cutiModel.sum.izin,
        cuti = cutiModel.sum.cuti,
        alpha = cutiModel.sum.alpha;
    int izinTahunIni =
        int.parse(sakit) + int.parse(izin) + int.parse(cuti) + int.parse(alpha);
    String appBarTitle = 'Tambah Cuti';
    widget.dari != null && widget.dari != ''
        ? appBarTitle = 'Ubah Cuti'
        : appBarTitle = appBarTitle;
    widget.dari != null && widget.dari != ''
        ? btnSimpanLabel = 'Simpan'
        : btnSimpanLabel = 'Tambah';

    // assign value ubah cuti ke controller
    tambahCtrl.dariCtrl.value.text =
        DateFormat('yyyy-MM-dd').format(dariWidget);
    tambahCtrl.sampaiCtrl.value.text =
        DateFormat('yyyy-MM-dd').format(sampaiWidget);
    tambahCtrl.idcuti.value = id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: TextIsi2(isi: appBarTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganResponsive(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              TopCardCuti(
                izin: izinTahunIni.toString(),
                tahun: cutiCtrl.tahunPilih.value,
              ),

              // dari
              DatePicker(
                onTap: () => tambahCtrl.fnShowDTPicker(
                    isMulai: true, context: context, initDate: dariWidget),
                hintText: 'Tanggal Mulai Izin!',
                labelText: 'Mulai',
                textCtrl: tambahCtrl.dariCtrl.value,
              ),

              // sampai
              DatePicker(
                onTap: () => tambahCtrl.fnShowDTPicker(
                    isMulai: false, context: context, initDate: sampaiWidget),
                hintText: 'Tanggal Izin Selesai!',
                labelText: 'Selesai',
                textCtrl: tambahCtrl.sampaiCtrl.value,
              ),

              // izin
              Container(
                margin: EdgeInsets.only(top: 15),
                // width: double.maxFinite,
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(25),
                  value: tambahCtrl.izinPilih.value,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isExpanded: true,
                  items: tambahCtrl.listIzin.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      tambahCtrl.izinPilih.value = newValue!;
                      tambahCtrl.fnAssignIzin();
                    });
                  },
                ),
              ),

              // keterangan
              Container(
                margin: EdgeInsets.only(top: 15),
                child: InputMultiText(
                  ctrlteks: tambahCtrl.ketCtrl.value,
                  label: 'Keterangan',
                  hint: 'Masukkan keterangan izin anda!',
                  maxLength: 200,
                  maxLines: 5,
                ),
              ),

              // image picker
              Obx(
                () {
                  // tombol hapus terlihat
                  if (tambahCtrl.isVisibleHapusImg.value == true) {
                    return Row(
                      children: [
                        Container(
                          width: 70,
                          child: ElevatedBtnWidget(
                            tekan: () => tambahCtrl.fnHapusFile(),
                            isPadding: false,
                            isMargin: false,
                            warnaBtn: warnaMerah,
                            child: Icon(Icons.delete),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                              child: ElevatedBtn(
                                  isMargin: false,
                                  isPadding: false,
                                  isi: tambahCtrl.fileTerpilih.value,
                                  tekan: () => tambahCtrl.fnPickFile())),
                        )
                      ],
                    );
                  } else {
                    return Container(
                        child: ElevatedBtn(
                            isMargin: false,
                            isPadding: false,
                            isi: tambahCtrl.fileTerpilih.value,
                            tekan: () => tambahCtrl.fnPickFile()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedBtn(
          tekan: () => tambahCtrl.fnInsertCuti(context),
          isi: btnSimpanLabel,
          enabled: tambahCtrl.simpanCanClick(),
          isPadding: true),
    );
  }
}

class DatePicker extends StatefulWidget {
  final TextEditingController textCtrl;
  final Function() onTap;
  final String hintText, labelText;

  const DatePicker(
      {Key? key,
      required this.textCtrl,
      required this.onTap,
      required this.hintText,
      required this.labelText})
      : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late TextEditingController textCtrl;
  late Function() onTap;
  late String hintText, labelText;

  @override
  Widget build(BuildContext context) {
    textCtrl = widget.textCtrl;
    onTap = widget.onTap;
    hintText = widget.hintText;
    labelText = widget.labelText;

    return Container(
        margin: EdgeInsets.only(top: 15),
        child: TextFormField(
            keyboardType: TextInputType.datetime,
            controller: textCtrl,
            onTap: onTap,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                hintText: hintText,
                labelText: labelText,
                border: OutlineInputBorder())));
  }
}
