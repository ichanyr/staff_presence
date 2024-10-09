import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class HapusLaporanAnggaranController extends GetxController
    with StateMixin<TambahAnggaranModel> {
  Rx<TambahAnggaranModel> laporanData =
      new TambahAnggaranModel(message: "", status: false).obs;
  Rx<String> idstaf = "".obs, id = "".obs;

  Future<void> hapusLaporan() async {
    TambahAnggaranModel fHapusLaporan =
        await ApiService().hapusLaporan(id: id.value, idstaf: idstaf.value);

    change(fHapusLaporan, status: RxStatus.loading());
    update();
    if (fHapusLaporan.status == true) {
      laporanData.value = fHapusLaporan;
      change(fHapusLaporan, status: RxStatus.success());
      update();
    } else {
      laporanData.value = fHapusLaporan;
      change(fHapusLaporan, status: RxStatus.error());
      update();
    }
  }
}
