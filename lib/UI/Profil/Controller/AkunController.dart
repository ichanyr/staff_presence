import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';

import '../../../ApiServices/ApiService.dart';

class AkunController extends GetxController with StateMixin<ProfilModel> {
  /// data
  Rx<ProfilModel> dataProfil =
      ProfilModel(status: false, dataProfil: DataProfil(name: '')).obs;
  RxString idstaf = ''.obs;
  RxStatus statusState = RxStatus.loading();

  /// shared pref
  SharedPref sp = SharedPref();

  Future<void> onInit() async {
    super.onInit();

    await sp.onInit();
    idstaf.value = sp.getIdstaf();

    await getProfil();
  }

  Future<void> getProfil() async {
    change(dataProfil.value, status: statusState);
    ProfilModel futureProfil = await ApiService().getProfil(idstaf.value);
    dataProfil.value = futureProfil;

    /// berhasil get profil
    if (futureProfil.status == true) {
      statusState = RxStatus.success();
    }

    /// gagal
    else {
      statusState = RxStatus.error('Terjadi kesalahan');
    }

    change(futureProfil, status: statusState);
  }
}
