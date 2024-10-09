import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Cuti/Controller/DelCutiController.dart';
import 'package:presensi_ic_staff/UI/Cuti/Controller/DetailCutiController.dart';
import 'package:presensi_ic_staff/UI/Cuti/TambahCutiPage.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';

import '../Element/textView.dart';
import 'Model/DetailCutiModel.dart';

class DetailCutiPage extends StatefulWidget {
  final String id;

  const DetailCutiPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailCutiPage> createState() => _DetailCutiPageState();
}

class _DetailCutiPageState extends State<DetailCutiPage> {
  late String id;
  late DetailCutiController detailCutiCtrl;
  late DelCutiController delCutiCtrl;

  @override
  Widget build(BuildContext context) {
    id = widget.id;
    detailCutiCtrl = Get.put(DetailCutiController());
    delCutiCtrl = Get.put(DelCutiController());
    delCutiCtrl.idcuti.value = id;
    detailCutiCtrl.id.value = id;
    detailCutiCtrl.getDetailData();

    return Scaffold(
      appBar: AppBar(
        title: TextIsi2(isi: 'Detail Cuti'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () => delCutiCtrl.alertHapusCuti(context: context),
            icon: Icon(
              Icons.delete,
              color: warnaMerah,
            ),
          )
        ],
      ),
      body: ScrollDenganResponsive(
        child: detailCutiCtrl.obx(
            (state) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: DataBody(
                    detailCutiModel: state!,
                  ),
                ),
            onError: (e) => Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    children: [
                      TextIsi2(
                        isi: 'Terjadi Error = $e',
                      ),
                      ElevatedBtn(
                          isi: 'Ulangi',
                          warnaBtn: warnaBiru,
                          tekan: () => detailCutiCtrl.getDetailData())
                    ],
                  ),
                ),
            onLoading: LoadingIc(),
            onEmpty: TextIsi2(isi: 'Data tidak ditemukan')),
      ),
    );
  }
}

class DataBody extends StatefulWidget {
  final DetailCutiModel detailCutiModel;

  const DataBody({Key? key, required this.detailCutiModel}) : super(key: key);

  @override
  State<DataBody> createState() => _DataBodyState();
}

class _DataBodyState extends State<DataBody> {
  late DetailCutiModel detail;

  @override
  Widget build(BuildContext context) {
    detail = widget.detailCutiModel;
    String mulai = prettyDT2(detail.data[0].min);
    String selesai = prettyDT2(detail.data[0].max);
    String izin = expandIzin(izin: detail.data[0].izin);
    String ket = detail.data[0].ket;
    String gambar = detail.data[0].img;
    String proses = expandProses(proses: detail.data[0].status);
    Color warnaButton = warnaBiru;
    bool btnUbahtampil = false;
    bool btnProsestampil = false;
    proses.toLowerCase() == 'ditolak'
        ? warnaButton = warnaMerah
        : warnaButton = warnaButton;
    izin.toLowerCase() == 'alpha'
        ? btnProsestampil = false
        : btnProsestampil = true;
    proses.toLowerCase() != 'proses'
        ? btnUbahtampil = false
        : btnUbahtampil = true;
    bool gambarTampil = false;
    gambar == '' || gambar == null ? gambarTampil = false : gambarTampil = true;

    ket == null || ket == '' ? ket = "[KeteranganKosong]" : ket = ket;

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          // tanggal
          ElevatedBtnWidget(
            tekan: () => print(''),
            warnaBtn: warnaPutih,
            isPadding: true,
            isMargin: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [TextIsi2(isi: mulai), TextIsi2(isi: selesai)],
            ),
          ),

          // keterangan
          Container(
            margin: EdgeInsets.only(top: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: warnaPutih,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextIsi2(
                      isi: izin,
                    ),
                    Divider(
                      color: warnaPutihAbu4,
                      thickness: 2,
                      height: 30,
                    ),
                    TextIsi2(isi: ket),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: gambarTampil,
                      child: Image.network(gambar),
                      replacement: TextIsi2(
                        isi: '[Gambar pendukung kosong]',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Btn Aksi
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                // btn ubah
                Visibility(
                  visible: btnUbahtampil,
                  child: ElevatedBtn(
                    tekan: () => Get.to(() => TambahCutiPage(
                        id: detail.data[0].id,
                        dari: detail.data[0].min,
                        sampai: detail.data[0].max,
                        ket: detail.data[0].ket,
                        izin: detail.data[0].izin)),
                    isi: 'Ubah',
                    warnaBtn: warnaBiru,
                    isPadding: false,
                    isMargin: false,
                  ),
                ),

                // btn proses
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Visibility(
                    visible: btnProsestampil,
                    child: ElevatedBtn(
                      tekan: () => print('tekan proses'),
                      isPadding: false,
                      isMargin: false,
                      warnaBtn: warnaButton,
                      isi: 'Status : ' + proses,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String expandProses({required String proses}) {
    String kembali = '';
    switch (proses) {
      case 'p':
        kembali = 'Proses';
        break;
      case 'a':
        kembali = 'Diterima';
        break;
      case 'r':
        kembali = 'Ditolak';
        break;
      default:
        kembali = 'Proses';
        break;
    }

    return kembali;
  }
}
