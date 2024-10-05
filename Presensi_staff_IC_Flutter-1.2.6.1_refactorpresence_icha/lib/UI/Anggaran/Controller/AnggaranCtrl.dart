import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';

class AnggaranCtrl extends GetxController with StateMixin<Anggaran> {
  Rx<Anggaran> anggaranData =
      Anggaran(data: [], message: "", ringkasan: [], rows: 0, status: false)
          .obs;
  Rx<String> id = "".obs, bulan = "".obs, tahun = "".obs;
  Rx<DateTime> bulanSelector = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    getAnggaran();
  }

  Future<void> getAnggaran() async {
    bulan.value = bulanSelector.value.month.toString();
    tahun.value = bulanSelector.value.year.toString();

    Future<Anggaran> fAnggaran =
        ApiService().getAnggaran(id.value, bulan.value, tahun.value);
    fAnggaran.then((value) {
      change(anggaranData.value, status: RxStatus.loading());
      update();
      if (value.status == true) {
        anggaranData.value = value;
        if (value.data.length > 0) {
          change(anggaranData.value, status: RxStatus.success());
          update();
        } else {
          change(anggaranData.value, status: RxStatus.empty());
          update();
        }
      } else {
        anggaranData.value = value;
        change(anggaranData.value, status: RxStatus.error());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    bulanSelector.value = DateTime.now();
  }

  // menentukan bar uang dibawah tanggal
  int gridCount({required double lebar}) {
    int jumlah = 2;

    if (lebar <= 800) {
      jumlah = 2;
    } else {
      jumlah = 4;
    }

    return jumlah;
  }
}
