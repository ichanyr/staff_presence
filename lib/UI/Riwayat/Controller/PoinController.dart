import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/Helper/Waktu.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/poinModel.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import '../../Element/dialogBox.dart';
import '../../Element/textView.dart';
import '../DetailPoin.dart';

class PoinController extends GetxController with StateMixin<PoinModel> {
  /// init data
  Rx<PoinModel> dataPoin = PoinModel(
          message: '',
          status: false,
          count: 0,
          data: [],
          tm: 0,
          sm: 0,
          tk: 0,
          total: 0)
      .obs;
  Rx<String> idstaf = ''.obs;
  Rx<DateTime> selectedDatetime = DateTime.now().obs;
  Rx<String> bulan = ''.obs;
  Rx<String> tahun = ''.obs;
  Rx<bool> isTotal = false.obs;
  Rx<int> lastData = 0.obs;
  Rx<String> idPresensi = ''.obs;

  /// data
  late PoinModel fPoin;
  RxStatus statusState = RxStatus.empty();

  /// shared pref
  SharedPref sp = SharedPref();

  /// Helper
  WaktuHelper waktuHelper = WaktuHelper();

  @override
  Future<void> onInit() async {
    super.onInit();

    /// init sp
    await sp.onInit();

    /// ambil poin
    await getPoin();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// ambil poin
  Future<void> getPoin() async {
    idstaf.value = sp.getIdstaf();
    bulan.value = selectedDatetime.value.month.toString();
    tahun.value = selectedDatetime.value.year.toString();

    fPoin = await ApiService().getPoinV2(
        idstaf: idstaf.value,
        bulan: bulan.value,
        idPresensi: idPresensi.value,
        isTotal: isTotal.value,
        lastData: lastData.value,
        tahun: tahun.value);

    if (fPoin.status == true) {
      statusState = RxStatus.success();
    } else {
      if (fPoin.count == 0) {
        statusState = RxStatus.empty();
      } else {
        statusState = RxStatus.error('Telah terjadi error');
      }
    }

    change(fPoin, status: statusState);
  }

  /// dialog box poin
  Future<void> showResumePoin() async {
    PoinModel poinModel = fPoin;
    getDialog(
        barrierDismissible: false,
        body: Container(
          child: Column(
            children: [
              /// teks total poin
              TextFormatting(
                  overflow: TextOverflow.visible,
                  text: 'Total poin anda adalah ${poinModel.total} poin'),
              SizedBox(height: marginAntarContent),

              /// last 5 poin
              Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: poinModel.count >= 5 ? 5 : poinModel.count,
                  itemBuilder: (context, index) {
                    /// data tanggal
                    String tglString = waktuHelper.dateToString(
                        waktu: poinModel.data[index].presentMasuk);

                    /// get poin
                    String pm = poinModel.data[index].poinMasuk;
                    String value = poinModel.data[index].valuePoint.toString();
                    String poin = pm == '' || pm == '0' ? value : pm;

                    return Column(
                      children: [
                        /// poin
                        ElevatedBtnWidget(
                            tekan: () => dialogDetail(
                                poinModel: poinModel, index: index),
                            warnaBtn: warnaPutih,
                            warnaTeks: warnaPrimer,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormatting(text: tglString),
                                TextFormatting(text: '$poin poin')
                              ],
                            )),
                        SizedBox(height: marginMin)
                      ],
                    );
                  },
                ),
              ),

              /// lihat lainya
              Container(
                height: 40,
                child: ElevatedBtn(
                  isMargin: false,
                  isPadding: false,
                  isi: 'Lihat lainya',
                  tekan: () {
                    gotoPoinDetail();
                  },
                  warnaBtn: warnaPrimer,
                  warnaTeks: warnaPutih,
                ),
              ),
              SizedBox(height: marginDidalamContent),

              Container(
                height: 40,
                child: ElevatedBtn(
                  isi: 'OK',
                  isMargin: false,
                  isPadding: false,
                  tekan: () {
                    Get.back();
                  },
                  warnaBtn: warnaPutih,
                  warnaTeks: warnaPrimer,
                ),
              ),
            ],
          ),
        ),
        title: 'Poin Anda');
  }

  /// goto detail poin
  void gotoPoinDetail() {
    Get.offAll(DashboardPage());
    Get.to(RiwayatPages());
    Get.to(DetailPoinPage(poinModel: fPoin));
  }

  void dialogDetail({required PoinModel poinModel, required int index}) {
    /// data
    String poinMasuk = poinModel.data[index].poinMasuk.toString();
    String valuePoin = poinModel.data[index].valuePoint.toString();
    String poinHariIni = poinMasuk == '0' ? valuePoin : poinMasuk;

    String keterangan = poinModel.data[index].keteranganPoint == ''
        ? '[Kosong]'
        : poinModel.data[index].keteranganPoint;

    String kategori =
        poinModel.data[index].kategoriPoint.toLowerCase() == 'manual'
            ? 'Atasan/Manajer'
            : poinModel.data[index].kategoriPoint;

    String jamPresensi = poinModel.data[index].presentMasuk;
    jamPresensi = waktuHelper.dateToString(
        waktu: jamPresensi, tipeWaktus: TipeWaktus.OnlyTimeShort);

    String tanggal = poinModel.data[index].presentMasuk;
    tanggal = waktuHelper.dateToString(
        waktu: tanggal, tipeWaktus: TipeWaktus.LongDate);

    String tipePoin = poinModel.data[index].tipePoint;

    getDialog(
        body: Column(
          children: [
            /// isi
            Column(
              children: [
                /// Jumalh Poin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormatting(
                        text: 'Poin',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Flexible(
                      child: TextFormatting(
                        text: '$poinHariIni poin',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: marginMin),

                /// Tipe poin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormatting(
                        text: 'Tipe poin',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Flexible(
                      child: TextFormatting(
                        text: '$tipePoin',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: marginMin),

                /// Ket
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextFormatting(
                      text: 'Keterangan',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                    Flexible(
                      child: TextFormatting(
                        text: keterangan,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: marginMin),

                /// Kategori
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextFormatting(
                      text: 'Kategori poin',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                    Flexible(
                        child: TextFormatting(
                      text: kategori,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
                SizedBox(height: marginMin),

                /// Presensi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextFormatting(
                      text: 'Jam presensi',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                    Flexible(
                        child: TextFormatting(
                      text: jamPresensi,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
                SizedBox(height: marginMin),

                /// Tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: TextFormatting(
                      text: 'Tanggal',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                    Flexible(
                        child: TextFormatting(
                      text: tanggal,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.end,
                    )),
                  ],
                ),
                SizedBox(height: marginMin),
              ],
            ),
            SizedBox(height: marginAntarContent),

            /// btn
            ElevatedBtn(
              isi: 'OK',
              isPadding: false,
              isMargin: false,
              tekan: () => Get.back(),
              warnaTeks: warnaPutih,
              warnaBtn: warnaPrimer,
            ),
          ],
        ),
        title: 'Detail Poin');
  }
}
