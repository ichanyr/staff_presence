import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/SettingDashModel.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';

class SetDashController extends GetxController
    with StateMixin<SettingDashboard> {
  Rx<SettingDashboard> settinganModel =
      SettingDashboard(status: false, message: "", data: []).obs;
  Rx<String> fileImg = "".obs;

  @override
  void onInit() {
    super.onInit();
    getSettingan();
  }

  void getSettingan() {
    Future<SettingDashboard> fSetDash = ApiService().getSettingDash();
    fSetDash.then((value) {
      change(settinganModel.value, status: RxStatus.loading());
      update();
      if (value.status == true) {
        settinganModel.value = value;
        if (value.data.length > 0) {
          // cekBerlaku(
          //     awal: value.data[0].validFrom,
          //     akhir: value.data[0].validUntil,
          //     urlFile: value.data[0].img);
          change(settinganModel.value, status: RxStatus.success());
          update();
        } else {
          change(settinganModel.value, status: RxStatus.empty());
          update();
        }
      } else {
        settinganModel.value = value;
        change(settinganModel.value, status: RxStatus.error());
      }
    });
  }

  Future<void> cekBerlaku(
      {required DateTime awal,
      required DateTime akhir,
      required String urlFile}) async {
    DateTime sekarang = DateTime.now();
    int selisihAwal = sekarang.difference(awal).inDays;
    int selisihAkhir = sekarang.difference(akhir).inDays;

    Directory tempDir = await getTemporaryDirectory();
    String directory = tempDir.path;

    if (selisihAwal < 0) {
      fileImg.value = '';
    }
    if (selisihAkhir > 0) {
      fileImg.value = '';
    }
    if (selisihAwal > 0 && selisihAkhir < 0) {
      fileImg.value = await downloadFile(urlFile, directory);
    }
  }
}
