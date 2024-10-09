
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/SettingAppsMobileModel.dart';

class SettingController extends GetxController
    with StateMixin<SettingAppsMobile> {
  Rx<SettingAppsMobile> settingData =
      SettingAppsMobile(data: [], message: "", rows: 0, status: false).obs;

  @override
  void onInit() {
    super.onInit();
    getSetting();
  }

  getSetting() {
    Future<SettingAppsMobile> fSetting =
    ApiService().getSetting();
    fSetting.then((value) {
      if (value.status) {
        if (value.data.length > 0) {
          settingData.value = value;
          change(value, status: RxStatus.success());
          update();
        } else {
          settingData.value = value;
          change(value, status: RxStatus.empty());
          update();
        }
      } else {
        settingData.value = value;
        change(value, status: RxStatus.error());
        update();
      }
    });
  }
}
