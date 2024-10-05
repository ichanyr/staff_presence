import 'package:get/get.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Riwayat/DetailPoin.dart';
import 'package:presensi_ic_staff/UI/Riwayat/detailRiwayatPager.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/riwayat.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../ApiServices/ApiService.dart';

class RiwayatController extends GetxController with StateMixin<RiwayatModel> {
  /// state
  RxStatus statusState = RxStatus.loading();

  /// data
  Rx<RiwayatModel> dataRiwayat =
      RiwayatModel(status: false, data: [DataRiwayat()], rows: 0, message: '')
          .obs;
  RxString idstaf = ''.obs;
  RxString tahun = ''.obs;
  RxString bulan = ''.obs;

  /// Shared pref
  SharedPref sp = SharedPref();

  /// datepicker
  Rx<DateTime> initialDatetime = DateTime.now().obs;
  Rx<DateTime> selectedDatetime = DateTime.now().obs;
  RxBool isLihat = false.obs;

  /// data detail riwayat
  RxList<DetailRiwayat> listDetailRiwayat = <DetailRiwayat>[].obs;
  RxList<String> listIdriwayat = <String>[].obs;

  /// data todo
  RxList<Todo> listTodo = <Todo>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await initializeDateFormatting();

    change(dataRiwayat.value, status: statusState);

    await getRiwayat();
  }

  /// load detail riwayat by list
  Future<void> loadListDetailRiwayat(
      {required String idrwyt, required int index}) async {
    DetailRiwayat fDR = await ApiService().getDetailR(idrwyt, idstaf.value);

    listDetailRiwayat.add(fDR);
  }

  Future<void> getRiwayat() async {
    await sp.onInit();
    idstaf.value = sp.getIdstaf();
    tahun.value = selectedDatetime.value.year.toString();
    bulan.value = selectedDatetime.value.month.toString();

    // dataRiwayat.close();
    dataRiwayat.value = await ApiService()
        .getRiwayatFilter(idstaf.value, tahun.value, bulan.value);

    /// berhasil terhubung
    if (dataRiwayat.value.status == true) {
      /// data lebih dari 1
      if (dataRiwayat.value.rows >= 1) {
        statusState = RxStatus.success();
      }

      /// data kosong
      else {
        statusState = RxStatus.empty();
      }
    }

    /// gagal
    else {
      statusState = RxStatus.error(dataRiwayat.value.message);
    }

    change(dataRiwayat.value, status: statusState);

    /// insert id riwayat
    listIdriwayat.clear();
    for (int i = 0; i < dataRiwayat.value.data.length; i++) {
      listIdriwayat.add(dataRiwayat.value.data[i].idRiwayat!);
    }

    /// load all data detail riwayat
    listDetailRiwayat.clear();
    for (int i = 0; i < listIdriwayat.length; i++) {
      await loadListDetailRiwayat(idrwyt: listIdriwayat[i], index: i);
    }
  }

  void gotoDetailRiwayat({required String idriwayat}) {
    List<int> listIdRiwayatInt = <int>[];
    listIdriwayat.forEach((element) {
      listIdRiwayatInt.add(int.parse(element));
    });

    Get.to(() => DetailRiwayatPagesPager(
          listDetailRiwayat: listDetailRiwayat,
          idriwayat: idriwayat,
          listIdRiwayat: listIdRiwayatInt,
        ));
  }
}
