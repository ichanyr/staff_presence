import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';

import '../../Element/dialogBox.dart';
import '../../Element/textView.dart';
import '../model/todo.dart';

class DetailRiwayatController extends GetxController
    with StateMixin<DetailRiwayat> {
  Rx<DetailRiwayat> dataDR = DetailRiwayat(
      listDataDetailRiwayat: [], message: '', status: false, listTodo: []).obs;
  Rx<String> idriwayat = ''.obs;
  Rx<String> iduser = ''.obs;
  RxList<String> listDone = <String>[].obs;
  Rx<bool> isFeedbackExist = false.obs;
  RxList<DetailRiwayat> listDetailRiwayat = <DetailRiwayat>[].obs;

  /// page
  Rx<PageController> pageCtrl = PageController().obs;
  RxList<String> idr = <String>[].obs, idrTemp = <String>[].obs;
  RxInt indexPage = 0.obs;
  RxList<int> listIdriwayat = <int>[].obs;

  /// shared pref
  SharedPref sp = SharedPref();

  /// edit tugas
  RxBool isEdit = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    listDone.value = <String>[];

    /// sp
    await sp.onInit();
    iduser.value = sp.getIdstaf();

    cekToLogin(iduser.value, Get.context!);

    idr.value = [
      ...{...sp.getIdrs()}
    ];
    // idrTemp.value = [
    //   ...{...idr}
    // ];
    // await sp.delIdrs();
    // await sp.setIdrs(idrTemp);

    /// page ctrl
    // pageCtrl.value =
    //     PageController(initialPage: idr.indexOf(idriwayat.value.toString()));
    /// moving to selected page
    indexPage.value = idr.indexOf(idriwayat.value);
    pageCtrl.value.animateToPage(indexPage.value,
        duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);

    // await loadDetailRiwayat();

    // indexPage.value = idr.indexOf(idriwayat.value);

    /// load all data detail riwayat
    // for(int i = 0; i<idr.length ; i++){
    //   await loadListDetailRiwayat(idrwyt: idr[i], index: i);
    // }
  }

  @override
  void onClose() {
    super.onClose();
    listDone.value = <String>[];
  }

  Future<void> loadDetailRiwayat() async {
    listDone.value = <String>[];
    DetailRiwayat fDR =
        await ApiService().getDetailR(idriwayat.value, iduser.value);
    change(fDR, status: RxStatus.loading());

    /// berhasil
    if (fDR.status == true) {
      /// data kosong
      if (fDR.listDataDetailRiwayat!.length == 0) {
        change(fDR, status: RxStatus.empty());
        dataDR.value = fDR;

        update();
      }

      /// data ada
      else {
        /// set untuk tampilan feedback exist
        if (fDR.listDataDetailRiwayat!.first.notePulang!.isNotEmpty ||
            fDR.listDataDetailRiwayat!.first.noteMasuk!.isNotEmpty) {
          isFeedbackExist.value = true;
        } else {
          isFeedbackExist.value = false;
        }
        fDR.listTodo!.forEach((element) {
          element.isDone == 'y' ? listDone.add('y') : listDone.add('n');
        });
        change(fDR, status: RxStatus.success());
        dataDR.value = fDR;

        update();
      }
    }

    /// gagal
    else {
      String? error = fDR.message;
      change(fDR, status: RxStatus.error(error));
      dataDR.value = fDR;

      update();
    }
  }

  /// load detail riwayat by list
  Future<void> loadListDetailRiwayat(
      {required String idrwyt, required int index}) async {
    DetailRiwayat fDR = await ApiService().getDetailR(idrwyt, iduser.value);

    listDetailRiwayat.add(fDR);
  }

  String isiTodo({String? isi}) {
    double lebar = Get.width;
    String isiReturn = isi ?? '';
    if (isi!.length > 0 && lebar < 600 && isi.length > 20) {
      isiReturn = isi.substring(0, 20) + '...' + lebar.toString();
    } else {
      isiReturn = isi + lebar.toString();
    }
    // update();
    return isiReturn;
  }

  /// on press feedback icon
  void fnTampilFeedback({required BuildContext context}) {
    dialogBoxWidget(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// feedback masuk
          Visibility(
              visible: dataDR
                  .value.listDataDetailRiwayat!.first.noteMasuk!.isNotEmpty,
              child: Column(
                children: [
                  TextIsi2(isi: 'Feedback Presensi Masuk'),
                  TextIsi2(
                      isi: dataDR.value.listDataDetailRiwayat!.first.noteMasuk),
                ],
              )),

          /// separator
          Visibility(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  imgSeparator(color: warnaPutihAbu4),
                  SizedBox(height: 20)
                ],
              ),
              visible: dataDR.value.listDataDetailRiwayat!.first.noteMasuk!
                      .isNotEmpty &&
                  dataDR.value.listDataDetailRiwayat!.first.notePulang!
                      .isNotEmpty),

          /// feedback keluar
          Visibility(
              visible: dataDR
                  .value.listDataDetailRiwayat!.first.notePulang!.isNotEmpty,
              child: Column(
                children: [
                  TextIsi2(isi: 'Feedback Presensi Pulang'),
                  TextIsi2(
                      isi:
                          dataDR.value.listDataDetailRiwayat!.first.notePulang),
                ],
              )),
          SizedBox(height: 32),

          /// btn ok
          ElevatedBtn(
            isi: 'OK',
            tekan: () => Get.back(),
            isPadding: false,
          )
        ],
      ),
    );
  }

  /// simpan todo
  Future<void> simpanTodo(String isi) async {
    Future<TodoAct> futureTodo = ApiService().postTodo(idriwayat.value, isi);
    await showSukses("Update berhasil!", Get.context!);
    isEdit.value != isEdit.value;

    await loadAllDetailRiwayat();
  }

  Future<void> loadAllDetailRiwayat()async{
    /// clear dulu
    listDetailRiwayat.clear();

    /// load all data detail riwayat
    for (int i = 0; i < listIdriwayat.length; i++) {
      await loadListDetailRiwayat(idrwyt: listIdriwayat[i].toString(), index: i);
    }
  }
}
