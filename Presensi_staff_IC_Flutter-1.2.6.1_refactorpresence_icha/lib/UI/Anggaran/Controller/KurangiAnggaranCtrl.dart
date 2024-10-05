import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/KurangAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class KurangiAnggaranController extends GetxController
    with StateMixin<KurangAnggaranModel> {
  Rx<KurangAnggaranModel> anggaranDataKurang =
      KurangAnggaranModel(status: false, message: "init").obs;
  Rx<String> idstaf = "".obs, id = "".obs;

  Future<void> delAnggaran() async {
    KurangAnggaranModel fKurangiAnggaran =
        await ApiService().deleteAnggaran(id.value, idstaf.value);
    if (fKurangiAnggaran.status = true) {
      anggaranDataKurang.value = fKurangiAnggaran;
      change(fKurangiAnggaran, status: RxStatus.success());
    } else {
      change(anggaranDataKurang.value, status: RxStatus.error());
    }
  }
}
