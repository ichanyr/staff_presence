import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Element/Filter/DialogFilterUniversal.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Lembur/DetailLembur.dart';
import 'package:presensi_ic_staff/UI/Lembur/TambahLembur.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/LemburModel.dart';

import '../../Dashboard/dashboard.dart';
import '../LemburPage.dart';
import '../model/HapusLemburModel.dart';
import '../model/TambahLemburModel.dart';

class LemburController extends GetxController with StateMixin<LemburModel> {
  /// state
  Rx<LemburModel> data =
      LemburModel(status: false, message: '', data: [], count: 0).obs;
  RxStatus statusState = RxStatus.loading();
  RxString idstaf = ''.obs;
  RxString bulan = ''.obs;
  RxString tahun = ''.obs;
  RxList<int> listTahun = <int>[].obs;

  /// filter
  RxString filterBulanTerpilih = 'Semua'.obs;
  RxString filterCutiTerpilih = 'Semua'.obs;

  /// shared pref
  SharedPref sp = SharedPref();

  Rx<HapusLemburModel> responseHapusLembur =
      HapusLemburModel(status: false, message: '').obs;

  /// resume filter
  RxInt totalJam = 0.obs;
  RxInt totalJamAcc = 0.obs;

  Future<void> onInit() async {
    super.onInit();

    /// sp
    await sp.onInit();
    idstaf.value = sp.getIdstaf();

    /// ketika bulan tahun kosong
    cekBTKosong();

    await getLembur();
  }

  Future<void> getLembur() async {
    /// convert bulan string to int
    bulanToInt();

    /// clear jam
    totalJam.value = 0;
    totalJamAcc.value = 0;

    statusState = RxStatus.loading();

    data.value = await ApiService().getLembur(
        idstaf: idstaf.value, bulan: bulan.value, tahun: tahun.value);

    /// response ok
    if (data.value.status == true) {
      /// ada isinya
      if (data.value.count >= 1) {
        statusState = RxStatus.success();
        fnSumTotalJam();
      }

      /// kosong
      else {
        statusState = RxStatus.empty();
      }
    }

    /// gagal
    else {
      statusState = RxStatus.error(data.value.message);
    }

    /// update
    change(data.value, status: statusState);
  }

  void bulanToInt() {
    switch (filterBulanTerpilih.value) {
      case 'Semua':
        bulan.value = '';
        break;
      case 'Jan':
        bulan.value = '1';
        break;
      case 'Feb':
        bulan.value = '2';
        break;
      case 'Mar':
        bulan.value = '3';
        break;
      case 'Apr':
        bulan.value = '4';
        break;
      case 'Mei':
        bulan.value = '5';
        break;
      case 'Jun':
        bulan.value = '6';
        break;
      case 'Jul':
        bulan.value = '7';
        break;
      case 'Ags':
        bulan.value = '8';
        break;
      case 'Sep':
        bulan.value = '9';
        break;
      case 'Okt':
        bulan.value = '10';
        break;
      case 'Nov':
        bulan.value = '11';
        break;
      case 'Des':
        bulan.value = '12';
        break;
      default:
        bulan.value = 'Semua';
        break;
    }
  }

  /// cek bulan tahun kosong
  void cekBTKosong() {
    DateTime sekarang = DateTime.now();

    if (bulan.value == '') {
      bulan.value = sekarang.month.toString();
    }

    if (tahun.value == '') {
      tahun.value = sekarang.year.toString();
    }
  }

  /// Filter
  Future<void> fnTampilFilter() async {
    if (listTahun.length <= 4) {
      for (int i = 0; i < 5; i++) {
        int tahun = DateTime.now().year - i;
        listTahun.add(tahun);
      }
    }

    await dialogBoxWidget(
        child: DialogFilter(
          isBtnAksiVisible: false,
          listTahun: listTahun,
          tahunTerpilih: tahun.value,
          terpilihFilter: filterBulanTerpilih.value,
          listFilter: [
            'Semua',
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'Mei',
            'Jun',
            'Jul',
            'Ags',
            'Sep',
            'Okt',
            'Nov',
            'Des'
          ],
          onTapTahun: (String value) async {
            tahun.value = value;

            await getLembur();
          },
          onTapFilter: (String value) async {
            filterBulanTerpilih.value = value;
            await getLembur();
          },
        ),
        context: Get.context!);
  }

  /// goto tambah lembur
  void fnGotoTambah() {
    Get.to(() => TambahLemburPage());
  }

  /// goto detail lembur
  void fnGotoDetail({required int index}) {
    Get.to(() => DetailLembur(dataLembur: data.value.data[index]));
  }

  /// prompt hapus lembur
  Future<void> fnPromptHapus({required String idLembur}) async {
    await getDialog(
        body: Column(
          children: [
            ///ya hapus,
            ElevatedBtn(
              isPadding: true,
              isMargin: false,
              isi: 'Ya, Hapus',
              warnaBtn: warnaMerah,
              warnaTeks: warnaPutih,
              tekan: () async {
                await fnHapusLembur(idlembur: idLembur);
              },
            ),

            /// jangan hapus
            ElevatedBtn(
              isPadding: true,
              isMargin: false,
              tekan: () {
                Get.back();
              },
              isi: 'Tidak, jangan hapus',
              warnaTeks: warnaPutih,
              warnaBtn: warnaPrimer,
            )
          ],
        ),
        title: 'Apakah anda yakin ingin menghapus lembur ini ?');
  }

  /// hapus lembur
  Future<void> fnHapusLembur({required String idlembur}) async {
    getDialogLoading(barrierDismissible: false);

    responseHapusLembur.value = await ApiService()
        .delLembur(idstaf: idstaf.value, idlembur: idlembur ?? '');

    /// berhasil
    if (responseHapusLembur.value.status == true) {
      statusState = RxStatus.success();
    } else {
      statusState = RxStatus.error(responseHapusLembur.value.message);
    }

    Get.back();

    /// dialog berhasil dan tidak
    getDialog(
        titleOverflow: TextOverflow.visible,
        barrierDismissible: false,
        body: ElevatedBtn(
          isi: 'OK',
          tekan: () {
            if (responseHapusLembur.value.status == true) {
              Get.offAll(() => DashboardPage());
              Get.to(() => LemburPage());
            } else {
              Get.back();
            }
          },
        ),
        title: responseHapusLembur.value.message);
  }

  /// goto edit lembur
  void fnGotoEditLembur(
      {required String id,
      required String ket,
      required DateTime mulai,
      required DateTime selesai}) {
    Get.to(() => TambahLemburPage(
          id: id,
          ket: ket,
          mulai: mulai,
          selesai: selesai,
        ));
  }

  /// total jam
  void fnSumTotalJam() {
    if (data.value.status == true) {
      /// total semua jam
      data.value.data.forEach((element) {
        totalJam.value += int.tryParse(element.totalJam)!;

        /// yang di acc
        if (element.status.toLowerCase() == 'accept') {
          totalJamAcc.value += int.tryParse(element.totalJam)!;
        }
      });
    }
    // totalTahun.value = data.value.data.
  }
}
