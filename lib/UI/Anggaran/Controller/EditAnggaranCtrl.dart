import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';

class EditAnggaranController extends GetxController
    with StateMixin<TambahAnggaranModel> {
  Rx<TambahAnggaranModel> anggaranData =
      TambahAnggaranModel(message: "", status: false).obs;
  Rx<String> idstaf = "".obs, judul = "".obs, ket = "".obs, id = "".obs;
  Rx<int> nominal = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<TambahAnggaranModel> putAnggaran() async {
    TambahAnggaranModel fEditAnggaran = await ApiService().putAnggaran(
        id: id.value,
        idStaf: idstaf.value,
        judul: judul.value,
        nominal: nominal.value,
        ket: ket.value);
    change(fEditAnggaran, status: RxStatus.loading());
    update();
    if (fEditAnggaran.status == true) {
      anggaranData.value = fEditAnggaran;
      change(fEditAnggaran, status: RxStatus.success());
      update();
      return fEditAnggaran;
    } else {
      anggaranData.value = fEditAnggaran;
      change(fEditAnggaran, status: RxStatus.error());
      update();
      return fEditAnggaran;
    }
  }
}
