import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class TambahAnggaranCtrl extends GetxController
    with StateMixin<TambahAnggaranModel> {
  Rx<TambahAnggaranModel> anggaranData =
      TambahAnggaranModel(message: "", status: false).obs;
  Rx<String> idstaf = "".obs, judul = "".obs, nominal = "".obs, ket = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<TambahAnggaranModel> postAnggaran() async {
    TambahAnggaranModel fTambahAnggaran = await ApiService()
        .postAnggaran(idstaf.value, judul.value, nominal.value, ket.value);
    // anggaranData.value = value;
    change(fTambahAnggaran, status: RxStatus.loading());
    update();
    if (fTambahAnggaran.status == true) {
      anggaranData.value = fTambahAnggaran;
      change(fTambahAnggaran, status: RxStatus.success());
      update();
      return fTambahAnggaran;
    } else {
      anggaranData.value = fTambahAnggaran;
      change(fTambahAnggaran, status: RxStatus.error());
      update();
      return fTambahAnggaran;
    }
  }
}
