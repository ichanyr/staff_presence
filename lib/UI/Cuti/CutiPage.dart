import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Cuti/Controller/CutiController.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/CutiModel.dart';
import 'package:presensi_ic_staff/UI/Element/Model/ButtonModel.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/card.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Element/ScrollAndResponsive.dart';
import '../Element/Warna.dart';

class CutiPage extends StatefulWidget {
  const CutiPage({Key? key}) : super(key: key);

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  CutiController cutiCtrl = Get.put(CutiController());
  late int gridCount;

  RefreshController refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    gridCount = cutiCtrl.cekGridCount(lebar: MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: TextIsi2(isi: 'Cuti'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () async {
          await cutiCtrl.getCuti();
          refreshController.refreshCompleted();
        },
        child: cutiCtrl.obx(
            (state) => BodyPage(
                cutiModel: cutiCtrl.cutiData.value, gridcount: gridCount),
            // onEmpty: DataKosong(fungsi: () => print('Data Kosong')),
            onEmpty: DataKosong(
              fungsi: () {
                cutiCtrl.getCuti();
              },
            ),
            onLoading: Center(child: LoadingIc()),
            onError: (e) => TextIsi2(isi: e!)),
      ),
      bottomNavigationBar: NavBar(
        tahun: DateTime.now().year,
      ),
    );
  }
}

class BodyPage extends StatelessWidget {
  final CutiModel cutiModel;
  final int gridcount;

  const BodyPage({Key? key, required this.cutiModel, required this.gridcount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CutiController cutiCtrl = Get.put(CutiController());
    String cutiTahunan = cutiModel.jatahCuti[0].cuti;
    String sakit = cutiModel.sum.sakit,
        izin = cutiModel.sum.izin,
        cuti = cutiModel.sum.cuti,
        alpha = cutiModel.sum.alpha;
    int izinTahunIni =
        int.parse(sakit) + int.parse(izin) + int.parse(cuti) + int.parse(alpha);

    return Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            // top bar
            GridView.count(
              crossAxisCount: gridcount,
              shrinkWrap: true,
              childAspectRatio: 5.0,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TopCardCuti(
                  izin: izinTahunIni.toString(),
                  tahun: cutiCtrl.tahunPilih.value,
                ),
                CardCuti(
                  izin: izin,
                  sakit: sakit,
                  cuti: "$cuti/$cutiTahunan",
                  alpha: alpha,
                ),
              ],
            ),

            // cuti list
            Container(
                margin: EdgeInsets.only(top: 15),
                child: CutiList(cutiModel: cutiModel)),
          ],
        ));
  }
}

class CutiList extends StatelessWidget {
  final CutiModel cutiModel;

  const CutiList({Key? key, required this.cutiModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CutiController cutiCtrl = Get.put(CutiController());
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cutiModel.izin.length,
          itemBuilder: (context, index) {
            String tanggal = cutiModel.izin[index].mulai.toString();
            String izin = cutiModel.izin[index].izin;
            String hari = cutiModel.izin[index].berapaHari;
            String status = cutiModel.izin[index].status;
            String id = cutiModel.izin[index].id;

            return CardCutiItem(
              onPress: () => cutiCtrl.fnPindahDetailPage(id: id),
              tanggal: tanggal,
              izin: izin,
              hari: hari,
              status: status,
            );
          }),
    );
  }
}

class NavBar extends StatefulWidget {
  final int tahun;

  const NavBar({Key? key, required this.tahun}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int tahun;
  late CutiController cutiCtrl;

  @override
  Widget build(BuildContext context) {
    tahun = widget.tahun;
    cutiCtrl = Get.put(CutiController());
    return Container(
      height: 80,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          // btn filter
          ElevatedBtnWidget(
            isMargin: false,
            isPadding: false,
            width: 70,
            tekan: () => filter(),
            child: Icon(Icons.filter_alt_rounded, color: warnaBiru),
            warnaBtn: warnaPutih,
          ),

          // jarak
          SizedBox(
            width: 15,
          ),

          // btn tambah
          Expanded(
            child: ElevatedBtnWidget(
              tekan: () => cutiCtrl.fnTambahCuti(),
              isPadding: false,
              isMargin: false,
              warnaBtn: warnaPrimer,
              // child: TextIsi2(isi: 'hallo'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// icon
                  Icon(Icons.add, color: warnaPutih),
                  SizedBox(width: 10),

                  /// text
                  TextIsi2(
                    isi: 'Izin',
                    warna: warnaPutih,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void filter() {
    dialogBoxWidget(child: DialogFilter(tahun: tahun), context: context);
  }
}

class DialogFilter extends StatefulWidget {
  final int tahun;

  const DialogFilter({Key? key, required this.tahun}) : super(key: key);

  @override
  State<DialogFilter> createState() => _DialogFilterState();
}

class _DialogFilterState extends State<DialogFilter> {
  late int tahun;

  @override
  Widget build(BuildContext context) {
    tahun = widget.tahun;
    return ScrollDenganResponsive(
      child: Container(
        child: Column(
          children: [
            /// Filter
            TextIsi2(
              isi: 'Filter',
            ),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip tahun
            ChipTahun(),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip cuti
            ChipCuti(),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip proses
            ChipProses(),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// btn FIlter
            BtnFilter()
          ],
        ),
      ),
    );
  }
}

class ChipTahun extends StatefulWidget {
  const ChipTahun({Key? key}) : super(key: key);

  @override
  State<ChipTahun> createState() => _ChipTahunState();
}

class _ChipTahunState extends State<ChipTahun> {
  int tahunSekarang = DateTime.now().year;
  late CutiController cutiCtrl;

  Set<int> pilihanTahun = <int>{2022, 2021, 2020, 2019};

  @override
  Widget build(BuildContext context) {
    cutiCtrl = Get.put(CutiController());
    return Wrap(
      children: cutiCtrl.setTahun
          .map((e) => Container(
                margin: EdgeInsets.all(10),
                child: ChoiceChip(
                  backgroundColor: warnaPutih,
                  elevation: 2,
                  pressElevation: 5,
                  selectedColor: warnaBiru,
                  padding: EdgeInsets.all(15),
                  label: TextIsi2(
                    isi: e.toString(),
                    warna: warnaHitam,
                  ),
                  selected: cutiCtrl.tahunPilih.value == e,
                  onSelected: (_) {
                    setState(() => cutiCtrl.tahunPilih.value = e);
                  },
                ),
              ))
          .toList(),
      spacing: 5,
    );
  }
}

class ChipCuti extends StatefulWidget {
  const ChipCuti({Key? key}) : super(key: key);

  @override
  State<ChipCuti> createState() => _ChipCutiState();
}

class _ChipCutiState extends State<ChipCuti> {
  late CutiController cutiCtrl;

  @override
  Widget build(BuildContext context) {
    cutiCtrl = Get.put(CutiController());
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Wrap(
        children: cutiCtrl.listIzin.value.listIzinModel
            .map(
              (e) => FilterChip(
                selectedColor: warnaBiru,
                backgroundColor: warnaPutih,
                elevation: 2,
                padding: EdgeInsets.all(15),
                label: TextIsi2(isi: e.string),
                selected: e.isSelected,
                onSelected: (_) {
                  setState(() {
                    cutiCtrl.filterChipIzinClicked(e);
                  });
                },
              ),
            )
            .toList(),
        spacing: 15,
        runSpacing: 15,
      ),
    );
  }
}

class ChipProses extends StatefulWidget {
  const ChipProses({Key? key}) : super(key: key);

  @override
  State<ChipProses> createState() => _ChipProsesState();
}

class _ChipProsesState extends State<ChipProses> {
  late CutiController cutiCtrl;

  @override
  Widget build(BuildContext context) {
    cutiCtrl = Get.put(CutiController());
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Wrap(
        children: cutiCtrl.listProses.value.listIzinModel
            .map(
              (e) => FilterChip(
                selectedColor: warnaBiru,
                backgroundColor: warnaPutih,
                elevation: 2,
                padding: EdgeInsets.all(15),
                label: TextIsi2(isi: e.string),
                selected: e.isSelected,
                onSelected: (_) {
                  setState(() {
                    cutiCtrl.filterChipProsesClicked(e);
                  });
                },
              ),
            )
            .toList(),
        spacing: 15,
        runSpacing: 15,
      ),
    );
  }
}

class BtnFilter extends StatefulWidget {
  const BtnFilter({Key? key}) : super(key: key);

  @override
  State<BtnFilter> createState() => _BtnFilterState();
}

class _BtnFilterState extends State<BtnFilter> {
  late CutiController cutiCtrl;

  @override
  Widget build(BuildContext context) {
    cutiCtrl = Get.put(CutiController());
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            child: ElevatedBtnWidget(
              isPadding: false,
              bentuk: BentukBtnModel(BentukBtnModels.circle),
              tekan: () => Get.back(),
              child: Icon(Icons.close),
              warnaBtn: warnaMerah,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 3,
            child: ElevatedBtnWidget(
              isPadding: false,
              bentuk: BentukBtnModel(BentukBtnModels.stadium),
              tekan: () => cutiCtrl.fnBtnUlang(),
              warnaBtn: warnaPutih,
              warnaTeks: warnaPutih,
              child: TextIsi2(isi: 'Ulang'),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 3,
            child: ElevatedBtnWidget(
                isPadding: false,
                bentuk: BentukBtnModel(BentukBtnModels.stadium),
                child: TextIsi2(
                  isi: 'Terapkan',
                  warna: warnaPutih,
                ),
                tekan: () => cutiCtrl.fnBtnTerapkan()),
          ),
        ],
      ),
    );
  }
}
