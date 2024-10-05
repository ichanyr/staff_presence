import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/DetailCutiModel.dart';

class DetailCutiController extends GetxController
    with StateMixin<DetailCutiModel> {
  Rx<DetailCutiModel> detailCutiData =
      DetailCutiModel(status: false, message: '', data: []).obs;
  Rx<String> id = ''.obs;
  Rx<bool> isHapusBtnLihat = false.obs;

  @override
  Future<void> onInit() async{
    super.onInit();
    await getDetailData();
  }

  Future<void> getDetailData() async {
    change(detailCutiData.value, status: RxStatus.loading());
    DetailCutiModel getData = await ApiService().getDetailCuti(id: id.value);

    if (getData.status == true) {
      detailCutiData.value = getData;
      hapusBtnLihat();
      change(getData, status: RxStatus.success());
      update();
    } else {
      detailCutiData.value = getData;
      change(getData, status: RxStatus.error(getData.message));
      update();
    }
  }

  hapusBtnLihat() {
    if (detailCutiData.value.data.first.izin.toLowerCase() != 'a' &&
        detailCutiData.value.data.first.status.toLowerCase() == 'p') {
      isHapusBtnLihat.value = true;
    } else {
      isHapusBtnLihat.value = false;
    }
  }
}
