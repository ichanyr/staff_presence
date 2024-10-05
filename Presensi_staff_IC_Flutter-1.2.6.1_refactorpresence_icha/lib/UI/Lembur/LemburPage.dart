import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/Helper/Waktu.dart';
import 'package:presensi_ic_staff/UI/Element/Filter/DialogFilterUniversal.dart';
import 'package:presensi_ic_staff/UI/Element/Model/ButtonModel.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Lembur/controller/LemburController.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/LemburModel.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LemburPage extends StatefulWidget {
  const LemburPage({Key? key}) : super(key: key);

  @override
  State<LemburPage> createState() => _LemburPageState();
}

class _LemburPageState extends State<LemburPage> {
  LemburController lemburCtrl = Get.put(LemburController());

  /// refresh
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormatting(text: 'Lembur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () async {
          await lemburCtrl.getLembur();
          refreshController.refreshCompleted();
        },
        child: Container(
          padding: EdgeInsets.all(marginTepi),
          child: Column(
            children: <Widget>[
              /// bar atas + filter
              barAtasFilter(),
              SizedBox(height: marginDidalamContent / 2),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: marginDidalamContent / 2),

              /// data
              lemburCtrl.obx((state) => dataList(data: state!),
                  onEmpty: TextFormatting(text: 'Data lembur kosong!'),
                  onError: (e) => TextFormatting(text: 'Terjadi galat : $e'))
            ],
          ),
        ),
      ),
      bottomNavigationBar: addButton(),
    );
  }

  /// bar atas
  Widget barAtasFilter() {
    return ElevatedBtnWidget(
      tekan: () async => await lemburCtrl.fnTampilFilter(),
      warnaBtn: warnaPutih,
      bentuk: BentukBtnModel(BentukBtnModels.roundMedium),
      child: Column(
        children: [
          /// kolom atas isi gambar + Teks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// gambar
              ListSvgIcon(
                svgIconMenus: SvgIconMenus.lembur,
                size: Size.square(50),
              ),
              SizedBox(width: marginDidalamContent),

              /// teks
              Expanded(
                child: Column(
                  children: [
                    /// Total semua
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Jam
                        Flexible(
                          child: Obx(
                            () => TextFormatting(
                                overflow: TextOverflow.visible,
                                text:
                                    'total Jam ${lemburCtrl.filterBulanTerpilih.value} di tahun ${lemburCtrl.tahun.value}'),
                          ),
                        ),

                        /// jumlah
                        Obx(
                          () => TextFormatting(
                              text: '${lemburCtrl.totalJam} jam'),
                        ),
                      ],
                    ),

                    /// Total
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Jam
                        Flexible(
                          child: TextFormatting(
                              overflow: TextOverflow.visible,
                              text: 'Total jam yang di-acc'),
                        ),

                        /// jumlah
                        Obx(
                          () => TextFormatting(
                              text: '${lemburCtrl.totalJamAcc} jam'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: marginDidalamContent),

          /// filter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// icon
              Icon(Icons.filter_alt),
              SizedBox(width: marginDidalamContent),

              /// text filter
              TextFormatting(text: 'Filter')
            ],
          )
        ],
      ),
    );
  }

  /// data
  Widget dataList({required LemburModel data}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.count,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return dataItem(
            index: i,
            tanggal: data.data[i].mulai,
            jam: int.parse(data.data[i].totalJam),
            status: data.data[i].status);
      },
    );
  }

  Widget dataItem(
      {required DateTime tanggal,
      required int jam,
      required String status,
      required int index}) {
    /// warna icon
    Color warnaIcon = warnaAbu;
    Icon iconStatus = Icon(Icons.hourglass_empty_outlined, color: warnaIcon);

    if (status.toLowerCase() == 'accept') {
      warnaIcon = warnaPrimer;
      iconStatus = Icon(Icons.check, color: warnaIcon);
    }
    if (status.toLowerCase() == 'refused') {
      warnaIcon = warnaMerah;
      iconStatus = Icon(Icons.cancel, color: warnaIcon);
    }

    /// convert jam to readable
    WaktuHelper waktuHelper = WaktuHelper();
    String tgl = waktuHelper.dateToString(
        waktu: tanggal.toString(), tipeWaktus: TipeWaktus.LongDate);

    return Container(
      margin: EdgeInsets.only(bottom: marginDidalamContent),
      child: ElevatedBtnWidget(
        tekan: () {
          lemburCtrl.fnGotoDetail(index: index);
        },
        warnaBtn: warnaPutih,
        warnaTeks: warnaPrimer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// tanggal
            TextFormatting(text: tgl),

            /// jam + icon
            Row(
              children: [
                /// jam
                TextFormatting(text: jam.toString() + ' Jam'),

                /// icon
                iconStatus
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget addButton() {
    return ElevatedBtn(
      isi: 'Tambah lembur',
      warnaBtn: warnaPrimer,
      warnaTeks: warnaPutih,
      tekan: () => lemburCtrl.fnGotoTambah(),
    );
  }
}
