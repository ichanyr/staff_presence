import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/GetLaporanModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class LapAnggaranCtrl extends GetxController with StateMixin<LaporanAnggaran> {
  Rx<LaporanAnggaran> lapAnggaranData =
      LaporanAnggaran(data: [], message: "", uang: [], jumlah: 0, status: false)
          .obs;
  Rx<String> id = "".obs;

  @override
  void onInit() {
    super.onInit();
    // getAnggaran();
  }

  Future<void> getAnggaran() async {
    LaporanAnggaran fLapAnggaran = await ApiService().getLaporan(id.value);

    change(fLapAnggaran, status: RxStatus.loading());
    update();
    if (fLapAnggaran.status == true) {
      if (fLapAnggaran.data.length > 0 || fLapAnggaran.uang.length > 0) {
        lapAnggaranData.value = fLapAnggaran;
        change(fLapAnggaran, status: RxStatus.success());
        update();
      } else {
        lapAnggaranData.value = fLapAnggaran;
        change(fLapAnggaran, status: RxStatus.empty());
        update();
      }
    } else {
      lapAnggaranData.value = fLapAnggaran;
      change(fLapAnggaran, status: RxStatus.error());
      update();
    }
  }
}
