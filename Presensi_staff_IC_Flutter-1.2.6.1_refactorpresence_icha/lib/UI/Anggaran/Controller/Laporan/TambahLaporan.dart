import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class TambahLaporanController extends GetxController
    with StateMixin<TambahAnggaranModel> {
  Rx<TambahAnggaranModel> responseTambahLaporan =
      TambahAnggaranModel(message: "", status: false).obs;
  Rx<int> id = 0.obs;
  Rx<int> idReq = 0.obs;
  Rx<String> idstaf = "".obs;
  Rx<String> item = "".obs;
  Rx<int> nominal = 0.obs;
  Rx<String> catatan = "".obs;
  Rx<String> xfile = "".obs;
  Rx<DateTime> waktu = DateTime.now().obs;

  Future<void> postAnggaran() async {
    TambahAnggaranModel apiPostAnggaran = await ApiService().postLaporan(
        id: id.value,
        item: item.value,
        catatan: catatan.value,
        idstaf: idstaf.value,
        nominal: nominal.value,
        waktu: waktu.value,
        idReq: idReq.value ,
        xfile: xfile.value);

    change(apiPostAnggaran, status: RxStatus.loading());
    update();
    if (responseTambahLaporan.value.status == true) {
      responseTambahLaporan.value = apiPostAnggaran;
      change(apiPostAnggaran, status: RxStatus.success());
      update();
    } else {
      responseTambahLaporan.value = apiPostAnggaran;
      change(apiPostAnggaran, status: RxStatus.error());
      update();
    }
  }
}
