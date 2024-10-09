import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/Helper/Waktu.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/PoinController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/poinModel.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';

import '../../assets/ukuran.dart';
import '../Element/button.dart';

class DetailPoinPage extends StatefulWidget {
  const DetailPoinPage({Key? key, required this.poinModel}) : super(key: key);

  final PoinModel poinModel;

  @override
  State<DetailPoinPage> createState() => _DetailPoinPageState();
}

class _DetailPoinPageState extends State<DetailPoinPage> {
  /// state management
  PoinController poinCtrl = Get.put(PoinController());
  late PoinModel poinModel;

  /// helper
  WaktuHelper waktuHelper = WaktuHelper();

  @override
  Widget build(BuildContext context) {
    poinModel = widget.poinModel;

    return Scaffold(
      appBar: AppBar(
        title: TextFormatting(text: 'Detail Poin', color: warnaHitam),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ScrollDenganResponsive(
        child: Stack(
          children: [
            /// bg
            Container(
              color: warnaBackground,
              height: 100,
            ),

            /// data
            totaldanIsi(poinModel)
          ],
        ),
      ),
    );
  }

  /// isi
  Widget totaldanIsi(PoinModel poinModel) {
    return Container(
      child: Column(
        children: [
          /// kotak resume atas
          Stack(
            children: [
              /// BG
              Container(
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: warnaBiruCard,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  width: double.maxFinite,
                  height: 60),

              /// kotakan
              Container(
                margin: EdgeInsets.all(marginTepi),
                child: Column(
                  children: [
                    /// tahun ini
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(marginTepi),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: warnaPrimer),
                      child: Column(
                        children: [
                          /// poin total ini
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: TextFormatting(
                                    text: 'Total poin', color: warnaPutih),
                              ),
                              Flexible(
                                child: TextFormatting(
                                    text: '${poinModel.total} Poin',
                                    color: warnaPutih),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: marginMin),
                    //
                    // /// Poin Bulan ini
                    // Container(
                    //   padding: EdgeInsets.all(marginMin),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       TextFormatting(text: 'Poin Bulan ini'),
                    //       TextFormatting(text: '20 Poin'),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),

          /// isi data
          Container(
              padding: EdgeInsets.only(
                  left: marginTepi, right: marginTepi, bottom: marginTepi),
              color: warnaBiruCard,
              child: listviewData(poinModel)),
        ],
      ),
    );
  }

  /// list data
  Widget listviewData(PoinModel poinModel) {
    return ListView.builder(
      itemCount: poinModel.count,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        /// data tanggal
        String tglString =
            waktuHelper.dateToString(waktu: poinModel.data[index].presentMasuk);

        /// get poin
        String pm = poinModel.data[index].poinMasuk;
        String value = poinModel.data[index].valuePoint.toString();
        String poin = pm == '' || pm == '0' ? value : pm;
        String tipePoin = poinModel.data[index].tipePoint;
        tipePoin.toLowerCase() == 'negatif' ? tipePoin = '-' : tipePoin = '+';

        Color warnaBtn = warnaPutih;
        Color warnaTeks = warnaPrimer;
        tipePoin=='-' ? warnaBtn = warnaMerahCard : warnaBtn = warnaPutih;
        tipePoin=='-' ? warnaTeks = warnaPutih : warnaTeks = warnaPrimer;

        return Column(
          children: [
            /// poin
            ElevatedBtnWidget(
                tekan: () {
                  poinCtrl.dialogDetail(poinModel: poinModel, index: index);
                },
                warnaBtn: warnaBtn,
                warnaTeks: warnaTeks,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: TextFormatting(text: tglString)),
                    Flexible(child: TextFormatting(text: '$poin poin ($tipePoin)'))
                  ],
                )),
            SizedBox(height: marginMin)
          ],
        );
      },
    );
  }
}
