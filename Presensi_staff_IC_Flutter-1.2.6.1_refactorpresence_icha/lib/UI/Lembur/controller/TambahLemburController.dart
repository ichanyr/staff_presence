import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Lembur/LemburPage.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/TambahLemburModel.dart';

class TambahLemburController extends GetxController
    with StateMixin<TambahLemburModel> {
  /// input
  RxString idLembur = ''.obs;
  RxString idstaf = ''.obs;
  Rx<TextEditingController> ketCtrl = TextEditingController().obs;
  Rx<DateTime> tanggalPilih = DateTime.now().obs;
  Rx<DateTime> tanggalPilihSelesai = DateTime.now().obs;
  Rx<TimeOfDay> jamPilih = TimeOfDay.now().obs;
  Rx<TimeOfDay> jamPilihSelesai = TimeOfDay.now().obs;

  /// data
  Rx<TambahLemburModel> responseTambahLembur =
      TambahLemburModel(status: false, message: '').obs;
  Rx<TambahLemburModel> responseHapusLembur =
      TambahLemburModel(status: false, message: '').obs;
  RxStatus statusState = RxStatus.empty();

  /// String btn
  RxString stringBtnAction = 'Ajukan'.obs;

  /// helper
  SharedPref sharedPref = SharedPref();

  Future<void> onInit() async {
    super.onInit();

    await sharedPref.onInit();

    idstaf.value = sharedPref.getIdstaf();
  }

  /// datepicker
  Future<void> fnAmbilTanggal() async {
    tanggalPilih.value = await showDatePicker(
            context: Get.context!,
            firstDate: DateTime.now().subtract(Duration(days: 30)),
            lastDate: DateTime.now().add(Duration(days: 30)),
            initialDate: DateTime.now()) ??
        DateTime.now();
  }

  /// timepicker
  Future<void> fnAmbilJam() async {
    jamPilih.value = await showTimePicker(
            context: Get.context!, initialTime: jamPilih.value) ??
        TimeOfDay.now();
    tanggalPilih.value = DateTime(
        tanggalPilih.value.year,
        tanggalPilih.value.month,
        tanggalPilih.value.day,
        jamPilih.value.hour,
        jamPilih.value.minute);
  }

  Future<void> fnAmbilJamSelesai() async {
    jamPilihSelesai.value = await showTimePicker(
            context: Get.context!, initialTime: jamPilihSelesai.value) ??
        TimeOfDay.now();
    tanggalPilihSelesai.value = DateTime(
        tanggalPilihSelesai.value.year,
        tanggalPilihSelesai.value.month,
        tanggalPilihSelesai.value.day,
        jamPilihSelesai.value.hour,
        jamPilihSelesai.value.minute);
  }

  /// ajukan lembur
  Future<void> fnAjukanLembur() async {
    getDialogLoading(barrierDismissible: false);
    change(responseTambahLembur.value, status: statusState);

    responseTambahLembur.value = await ApiService().postLembur(
        ket: ketCtrl.value.text,
        idstaf: idstaf.value,
        mulai: tanggalPilih.value.toString(),
        selesai: tanggalPilihSelesai.value.toString(),
        idlembur: idLembur.value ?? '');

    /// berhasil
    if (responseTambahLembur.value.status == true) {
      statusState = RxStatus.success();
    } else {
      statusState = RxStatus.error(responseTambahLembur.value.message);
    }

    Get.back();

    /// dialog berhasil dan tidak
    getDialog(
        titleOverflow: TextOverflow.visible,
        barrierDismissible: false,
        body: ElevatedBtn(
          isi: 'OK',
          isMargin: false,
          isPadding: true,
          tekan: () {
            if (responseTambahLembur.value.status == true) {
              Get.offAll(() => DashboardPage());
              Get.to(() => LemburPage());
            } else {
              Get.back();
            }
          },
        ),
        title: responseTambahLembur.value.message);

    change(responseTambahLembur.value, status: statusState);
  }
}
