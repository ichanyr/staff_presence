import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/DetailAnggaranModel.dart';

class DetailAnggaranController extends GetxController
    with StateMixin<DetailAnggaran> {
  Rx<DetailAnggaran> detailAnggaranData =
      DetailAnggaran(data: [], message: "", rows: 0, status: false).obs;
  Rx<int> tipePage = 0.obs;
  Rx<String> btnBawahTeks = "Ubah".obs;
  Rx<String> idDetailAnggaran = "".obs;

  @override
  void onInit() {
    super.onInit();
    getDetailAnggaran();
  }

  Future<void> getDetailAnggaran() async {
    DetailAnggaran fDetailAnggaran =
        await ApiService().getDetailAnggaran(idDetailAnggaran.value);

    if (fDetailAnggaran.status) {
      if (fDetailAnggaran.data.length > 0) {
        detailAnggaranData.value = fDetailAnggaran;
        change(fDetailAnggaran, status: RxStatus.success());
        update();
      } else {
        detailAnggaranData.value = fDetailAnggaran;
        change(fDetailAnggaran, status: RxStatus.empty());
        update();
      }
    } else {
      detailAnggaranData.value = fDetailAnggaran;
      change(fDetailAnggaran, status: RxStatus.error());
      update();
    }
  }

  tentukanTipePage() {
    if (tipePage.value == 0) {
      btnBawahTeks.value = "Ubah";
    } else {
      btnBawahTeks.value = "Laporkan";
    }
  }
}
