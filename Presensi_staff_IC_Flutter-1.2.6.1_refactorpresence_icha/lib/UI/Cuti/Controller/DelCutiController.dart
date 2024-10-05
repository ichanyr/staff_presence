import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';

import '../../Element/Warna.dart';
import '../../Element/button.dart';
import '../../Element/dialogBox.dart';
import '../../Element/textView.dart';
import '../CutiPage.dart';
import '../Model/HapusCutiModel.dart';

class DelCutiController extends GetxController with StateMixin<HapusCutiModel> {
  Rx<HapusCutiModel> hapusResponse =
      HapusCutiModel(status: false, message: '').obs;
  Rx<String> idcuti = ''.obs;

  Future<void> hapusCuti({required BuildContext context}) async {
    HapusCutiModel fHapus = await ApiService().delCuti(id: idcuti.value);
    change(fHapus, status: RxStatus.loading());
    update();

    if (fHapus.status == true) {
      change(fHapus, status: RxStatus.success());
      dialogBoxWidget(
        context: context,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextIsi2(isi: fHapus.message, ukuran: 28),
              Divider(
                color: warnaPutihAbu4,
                height: 15,
                thickness: 2,
              ),

              // hapus cuti
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedBtn(
                  isi: 'Oke',
                  isPadding: false,
                  isMargin: false,
                  tekan: () {
                    Get.delete();
                    Get.deleteAll();
                    Get.off(() => CutiPage());
                  },
                ),
              )
            ],
          ),
        ),
      );
    } else {
      change(fHapus, status: RxStatus.error(fHapus.message));
      dialogBoxWidget(
        context: context,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextIsi2(isi: fHapus.message, ukuran: 28),
              Divider(
                color: warnaPutihAbu4,
                height: 15,
                thickness: 2,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedBtn(
                  isi: 'Oke',
                  isPadding: false,
                  isMargin: false,
                  tekan: () => Get.to(() => CutiPage()),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  alertHapusCuti({required BuildContext context}) {
    dialogBoxWidget(
      context: context,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// hapus izin
            TextIsi2(isi: 'Hapus izin ?', ukuran: 28),
            Divider(
              color: warnaPutihAbu4,
              height: 15,
              thickness: 2,
            ),

            // hapus
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedBtn(
                isi: 'Ya, Hapus',
                warnaBtn: warnaMerah,
                isPadding: false,
                isMargin: false,
                tekan: () {
                  hapusCuti(context: context);
                },
              ),
            ),

            // jangan hapus
            Container(
              margin: EdgeInsets.only(top: 15),
              child: ElevatedBtn(
                isi: 'Tidak, Jangan hapus',
                warnaBtn: warnaBiru,
                warnaTeks: warnaPutih,
                isPadding: false,
                isMargin: false,
                tekan: () {
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
