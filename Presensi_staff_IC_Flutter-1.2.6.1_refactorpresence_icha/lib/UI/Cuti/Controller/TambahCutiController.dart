import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Cuti/CutiPage.dart';
import 'package:presensi_ic_staff/UI/Cuti/DetailCutiPage.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/InsertCutiModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/TambahCutiPage.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahCutiController extends GetxController
    with StateMixin<InsertCutiModel> {
  DateTime dari = DateTime.now();
  Rx<DateTime> pilihTanggal = DateTime
      .now()
      .obs;
  DateTime batasMax = DateTime.now();
  Rx<TextEditingController> dariCtrl = TextEditingController().obs;
  Rx<TextEditingController> sampaiCtrl = TextEditingController().obs;
  Rx<TextEditingController> ketCtrl = TextEditingController().obs;
  RxList<String> listIzin = ['Sakit', 'Izin', 'Cuti'].obs;
  Rx<String> izinPilih = 'Izin'.obs;
  Rx<DateTime> batasMin = DateTime
      .now()
      .obs;
  Rx<String> idstaf = ''.obs;
  Rx<XFile> xFile = XFile('').obs;
  Rx<String> fileTerpilih = ''.obs;
  late SharedPreferences sp;
  Rx<InsertCutiModel> cutiData = InsertCutiModel(
      status: false,
      message: '',
      jatahCuti: [],
      jumlahCuti: JumlahCuti(
          jumlahCuti: 0,
          jatahCuti: 0,
          tahun: DateTime.now().toString(),
          bolehCuti: false))
      .obs;
  Rx<bool> isVisibleHapusImg = false.obs;
  late FilePickerResult resultFilePicker;
  Rx<String> idcuti = ''.obs;
  late String izinPilihs;

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    idstaf.value = (await sp.getString('iduser'))!;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadSP();
    fnPotongFileName();
  }

  fnShowDTPicker(
      {required BuildContext context, required bool isMulai, required DateTime initDate}) async {
    batasMax = DateTime(dari.year + 1, dari.month, dari.day);
    pilihTanggal.value = initDate ?? DateTime.now();
    initDate.isBefore(batasMin.value) == true
        ? initDate = DateTime.now()
        : initDate = initDate;
    if (isMulai == false) {
      // batasMin.value = DateFormat("yyyy-MM-dd").parse(sampaiCtrl.value.text);
      bool setelahnya = DateFormat('yyyy-MM-dd')
          .parse(sampaiCtrl.value.text)
          .isBefore(DateFormat('yyyy-MM-dd').parse(dariCtrl.value.text));
      if (dariCtrl.value.text != null && dariCtrl.value.text != '') {
        batasMin.value = DateFormat('yyyy-MM-dd').parse(dariCtrl.value.text);
        initDate = DateFormat('yyyy-MM-dd').parse(dariCtrl.value.text);
      }
    } else {
      // batasMin.value = DateFormat("yyyy-MM-dd").parse(dariCtrl.value.text);
      batasMin.value = DateTime.now();
    }
    pilihTanggal.value = (await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: batasMin.value,
      lastDate: batasMax,
      helpText: 'Pilih tanggal!',
    ))!;
    isMulai == true
        ? dariCtrl.value.text = pilihTanggal.value.toString().substring(0, 10)
        : sampaiCtrl.value.text =
        pilihTanggal.value.toString().substring(0, 10);

  }

  fnShowIzin() {
    DropdownButton(
      // Initial Value
      value: izinPilih.value,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: listIzin.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        izinPilih.value = newValue!;
      },
    );
  }

  fnAssignIzin() {
    izinPilihs = izinPilih.value.substring(0, 1).toLowerCase();
  }

  fnInsertCuti(BuildContext context) async {
    change(cutiData.value, status: RxStatus.loading());
    String reverseDari = DateFormat('dd-MM-yyyy')
        .format(DateFormat("yyyy-MM-dd").parse(dariCtrl.value.text));
    String reverseSampai = DateFormat('dd-MM-yyyy')
        .format(DateFormat("yyyy-MM-dd").parse(sampaiCtrl.value.text));
    cutiData.value = await ApiService().postCuti(
        idstaf: idstaf.value,
        ket: ketCtrl.value.text,
        izin: izinPilihs,
        dari: reverseDari,
        sampai: reverseSampai,
        id: idcuti.value,
        xfile: xFile.value.path);

    // berhasil tambah cuti
    if (cutiData.value.status == true) {
      dialogBoxWidget(
        context: context,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextIsi2(isi: cutiData.value.message, ukuran: 28),
              Divider(
                color: warnaPutihAbu4,
                height: 15,
                thickness: 2,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedBtn(
                  isi: 'Oke',
                  isPadding: false,
                  isMargin: false,
                  tekan: () {
                    Get.delete();
                    Get.deleteAll();
                    Get.off(() => CutiPage());
                  },
                ),
              )
            ],
          ),
        ),
      );
      change(cutiData.value, status: RxStatus.success());
    }

    // gagal tambah cuti
    else {
      dialogBoxWidget(
        context: context,
        child: ScrollDenganResponsive(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextIsi2(isi: 'Gagal Tambah Izin!', ukuran: 28),
                Divider(
                  color: warnaPutihAbu4,
                  height: 15,
                  thickness: 2,
                ),
                TextIsi2(isi: cutiData.value.message),
                Divider(
                  color: warnaPutihAbu4,
                  height: 15,
                  thickness: 2,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: ElevatedBtn(
                    isi: 'Oke',
                    isPadding: false,
                    isMargin: false,
                    tekan: () => Get.back(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
      change(cutiData.value, status: RxStatus.error());
    }
  }

  bool simpanCanClick() {
    izinPilih.value = 'Izin';
    if (idstaf.value != null &&
        idstaf.value != '' &&
        dariCtrl.value.text != null &&
        dariCtrl.value.text != '' &&
        sampaiCtrl.value.text != null &&
        sampaiCtrl.value.text != '') {
      return true;
    } else {
      return false;
    }
  }

  fnPickFile() async {
    resultFilePicker =
    (await FilePicker.platform.pickFiles(type: FileType.image))!;
    // File file = File(result.files.single.path);
    // xFiles.value = File(result.files.single.path);
    xFile.value = XFile(resultFilePicker.files.single.path!);
    fileTerpilih.value = xFile.value.name;
    fnPotongFileName();
    isVisibleHapusImg.value = true;
      // User canceled the picker
    update();
  }

  fnHapusFile() {
    resultFilePicker.files.clear();
    fileTerpilih.value = 'Foto Pendukung (Disarankan)';
    xFile.value = XFile('');
    isVisibleHapusImg.value = false;
    update();
  }

  fnPotongFileName() {
    if (fileTerpilih.value == '' || fileTerpilih.value == null) {
      fileTerpilih.value = 'Foto Pendukung (Disarankan)';
      isVisibleHapusImg.value = false;
    } else if (fileTerpilih.value.length >= 15) {
      int panjang = fileTerpilih.value.length;
      int lastDot = 0;
      for (int i = 0; i < panjang; i++) {
        if (fileTerpilih.value.substring(i, i + 1) == '.') {
          lastDot = i;
        }
      }

      fileTerpilih.value = fileTerpilih.value.substring(0, 15) +
          ' ... ' +
          fileTerpilih.value.substring(lastDot - 3, panjang);
      isVisibleHapusImg.value = true;
    }
  }
}
