import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Anggaran/AnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Cuti/CutiPage.dart';
import 'package:presensi_ic_staff/UI/Element/BottomSheet.dart';
import 'package:presensi_ic_staff/UI/Element/Model/ButtonModel.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Presensi/PresensiQr.dart';
import 'package:presensi_ic_staff/UI/Presensi/PresensiQr2.dart';
import 'package:presensi_ic_staff/UI/Presensi/model/Presensi.dart';
import 'package:presensi_ic_staff/UI/Presensi/qr.dart';
import 'package:presensi_ic_staff/UI/Profil/akun.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Element/toast.dart';
import 'package:presensi_ic_staff/UI/Login/login.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import 'package:presensi_ic_staff/main.dart';
import 'package:intl/intl.dart';

import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';

Widget btnLogin = Container(
  child: Container(
    margin: const EdgeInsets.only(top: 50, bottom: 20),
    child: TextButton(
        child: Text("Login".toUpperCase(), style: TextStyle(fontSize: 20)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () => null),
  ),
);

/// Dashboard V2
class BtnDashboard extends StatefulWidget {
  const BtnDashboard(
      {Key? key, required this.onPressed, this.svgIconMenus, this.namaMenu})
      : super(key: key);

  final Function() onPressed;
  final SvgIconMenus? svgIconMenus;
  final String? namaMenu;

  @override
  State<BtnDashboard> createState() => _BtnDashboardState();
}

class _BtnDashboardState extends State<BtnDashboard> {
  late Function() onPressed;
  late SvgIconMenus svgIconMenus;
  late String namaMenu;

  @override
  Widget build(BuildContext context) {
    svgIconMenus = widget.svgIconMenus ?? SvgIconMenus.presensi;
    namaMenu = widget.namaMenu ?? 'Presensi';
    onPressed = widget.onPressed;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Column(
          children: [
            /// btn + icon
            Expanded(
              flex: 5,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: ElevatedBtnWidget(
                  tekan: onPressed,
                  bentuk: BentukBtnModel(BentukBtnModels.roundMedium),
                  warnaBtn: warnaPutih,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: ListSvgIcon(svgIconMenus: svgIconMenus),
                  ),
                ),
              ),
            ),
            SizedBox(height: marginMin),

            /// text
            Flexible(
              flex: 3,
              child: TextFormatting(
                text: namaMenu,
                color: warnaBiru,
                formatTek: FormatTeks.H3,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================= Dashboard v1
Widget btnScan = Container(
  child: Center(
    child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(child: imgKotakTgl),
            Container(margin: const EdgeInsets.all(0), child: imgScan2)
          ],
        ),
        Container(margin: const EdgeInsets.only(top: 10), child: txtPresensiBtn)
      ],
    ),
  ),
);

Widget btnAkun = Container(
  child: Center(
    child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(child: imgKotakTgl),
            Container(margin: const EdgeInsets.all(0), child: imgAkun)
          ],
        ),
        Container(margin: const EdgeInsets.only(top: 10), child: txtAkunBtn)
      ],
    ),
  ),
);

class BtnAkun1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(child: imgKotakTgl),
                  Container(margin: const EdgeInsets.all(0), child: imgAkun)
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10), child: txtAkunBtn)
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AkunPage()));
          },
        ),
      ),
    );
  }
}

class _BtnScan extends State<BtnScan> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              try {
                ScanResult barcodes = await BarcodeScanner.scan();
                setState(() {
                  barcode = barcodes.rawContent;
                });
                log('isi dari barcode: $barcode');
              } on PlatformException catch (error) {
                if (error.code == BarcodeScanner.cameraAccessDenied) {
                  setState(() {
                    barcode = 'Izin kamera tidak diizinkan oleh si pengguna';
                  });
                } else {
                  setState(() {
                    barcode = 'Error: $error';
                  });
                }
              }
            },
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned.fill(child: imgKotakTgl),
                    Container(margin: const EdgeInsets.all(0), child: imgScan2)
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: txtPresensiBtn),
              ],
            ),
          ),
          Text('Isi Barcode = $barcode'),
        ],
      ),
    );
  }
}

class BtnScan extends StatefulWidget {
  @override
  _BtnScan createState() => new _BtnScan();
}

class BtnQr extends StatefulWidget {
  final bool isNotSafeDevice;

  const BtnQr({Key? key, required this.isNotSafeDevice}) : super(key: key);

  @override
  _BtnQr createState() => new _BtnQr();
}

class _BtnQr extends State<BtnQr> {
  String barcode = "";
  late bool isNotSafeDevice;

  @override
  Widget build(BuildContext context) {
    isNotSafeDevice = widget.isNotSafeDevice;
    return Center(
      child: InkWell(
          child: Column(
            children: <Widget>[
              /// img
              Stack(
                children: <Widget>[
                  Positioned.fill(child: imgKotakTgl),
                  Container(margin: const EdgeInsets.all(0), child: imgScan2)
                ],
              ),

              /// txt
              Flexible(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: txtPresensiBtn),
              ),
            ],
          ),
          onTap: () {
            /// ketika device safe
            if (isNotSafeDevice == false) {
              if (Platform.isIOS || Platform.isAndroid) {
                Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => PresensiQRPage()));
                    MaterialPageRoute(builder: (context) => PresensiQRPage()));
              } else {
                dialogBox(
                    context: context,
                    isi:
                        'Platform yang didukung untuk  presensi sementara adalah Android dan IOS!',
                    judul: 'Platform tidak didukung!',
                    btn1: 'Oke',
                    fnBtn1: () => Get.back(),
                    warnaBtn1: warnaPrimer,
                    warnaTeksBtn1: warnaPutih);
              }
            }

            /// rooted / mock gps
            else {
              getDialog(
                  body: ElevatedBtn(
                    isi: 'OK',
                    tekan: () => Get.back(),
                    warnaBtn: warnaPrimer,
                    warnaTeks: warnaPutih,
                    isPadding: true,
                    enabled: true,
                    isMargin: false,
                    bentuk: BentukBtnModel(BentukBtnModels.round),
                  ),
                  title: 'Device anda menggunakan FAKE GPS '
                      'Aplikasi tidak bisa digunakan untuk presensi!');
            }
          }),
    );
  }
}

class BtnRiwayat extends StatefulWidget {
  @override
  _BtnRiwayat createState() => _BtnRiwayat();
}

class _BtnRiwayat extends State<BtnRiwayat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => RiwayatPages()));
            Get.to(() => RiwayatPages());
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(child: imgKotakTgl),
                  Container(margin: const EdgeInsets.all(0), child: imgRiwayat)
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10), child: txtRiwayatBtn)
            ],
          ),
        ),
      ),
    );
  }
}

class BtnAnggaran extends StatefulWidget {
  @override
  _BtnAnggaran createState() => _BtnAnggaran();
}

class _BtnAnggaran extends State<BtnAnggaran> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AnggaranPage()));
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(child: imgKotakTgl),
                  Container(margin: const EdgeInsets.all(0), child: imgAnggaran)
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10), child: txtAnggaranBtn)
            ],
          ),
        ),
      ),
    );
  }
}

class BtnPoin extends StatefulWidget {
  @override
  _BtnPoin createState() => _BtnPoin();
}

class _BtnPoin extends State<BtnPoin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70, // background
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: tvPoin,
        ),
        onPressed: () {
          // Toast(isi: 'testing',);
          // Toast();
          final snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}

class BtnCuti extends StatelessWidget {
  const BtnCuti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () {
            Get.to(() => CutiPage());
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(child: imgKotakTgl),
                  Container(margin: const EdgeInsets.all(0), child: ImgCuti())
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TxtMenu(teks: "Cuti"))
            ],
          ),
        ),
      ),
    );
  }
}

// ============================= Riwayat

class BtnFilter extends StatefulWidget {
  @override
  _BtnFilter createState() => _BtnFilter();
}

class _BtnFilter extends State<BtnFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70, // background
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 20,
                  width: 20,
                  child: imgFilter),
              tvFilter,
            ],
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}

class FabScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 10.0,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: imgScan,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        onPressed: () {
          if (Platform.isIOS || Platform.isAndroid) {
            Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => PresensiQRPage()));
                MaterialPageRoute(builder: (context) => PresensiQRPage()));
          } else {
            dialogBox(
                context: context,
                isi:
                    'Platform yang didukung untuk  presensi sementara adalah Android dan IOS!',
                judul: 'Platform tidak didukung!',
                btn1: 'Oke',
                fnBtn1: () => Navigator.pop(context),
                warnaBtn1: warnaPrimer,
                warnaTeksBtn1: warnaPutih);
          }
        });
  }
}

class btnBulanNav extends StatefulWidget {
  final Function tekan;

  const btnBulanNav({Key? key, required this.tekan}) : super(key: key);

  @override
  State<btnBulanNav> createState() => _btnBulanNavState();
}

class _btnBulanNavState extends State<btnBulanNav> {
  @override
  Widget build(BuildContext context) {
    Function tekan = widget.tekan;

    return Container(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          tekan();
        },
        child: imgNavBulan(),
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaBgPink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}

// FAB Tambah
class FabTambah extends StatefulWidget {
  final Function tekan;

  const FabTambah({Key? key, required this.tekan}) : super(key: key);

  @override
  State<FabTambah> createState() => _FabTambahState();
}

class _FabTambahState extends State<FabTambah> {
  late Function tekan;

  @override
  Widget build(BuildContext context) {
    tekan = widget.tekan;

    return FloatingActionButton(
      onPressed: () => tekan(),
      child: Icon(Icons.add, color: warnaPrimer),
      backgroundColor: warnaPutih,
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: warnaPutihAbu4, style: BorderStyle.solid, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}

class ElevatedBtn extends StatefulWidget {
  final String? isi;
  final Function()? tekan;
  final Color? warnaBtn, warnaTeks;
  final bool? isPadding, isMargin;
  final bool? enabled;
  final BentukBtnModel? bentuk;

  const ElevatedBtn(
      {Key? key,
      this.isi,
      this.tekan,
      this.warnaBtn,
      this.warnaTeks,
      this.isPadding,
      this.enabled,
      this.isMargin,
      this.bentuk})
      : super(key: key);

  @override
  State<ElevatedBtn> createState() => _ElevatedBtnState();
}

class _ElevatedBtnState extends State<ElevatedBtn> {
  late String isi;
  late Function() tekan;
  late Color warnaBtn, warnaTeks;
  late bool isPadding, isMargin;
  late bool enabled;
  late BentukBtnModel bentuk;

  @override
  Widget build(BuildContext context) {
    isi = widget.isi ?? "";
    tekan = widget.tekan ?? () => print("perintah kosong");
    warnaBtn = widget.warnaBtn ?? warnaPrimer;
    warnaTeks = widget.warnaTeks ?? warnaPutih;
    isPadding = widget.isPadding ?? true;
    isMargin = widget.isMargin ?? true;
    enabled = widget.enabled ?? true;
    OutlinedBorder outline;

    if (enabled == false) {
      warnaBtn = warnaAbu;
      warnaTeks = warnaPutih;
    }

    double pad = 10;
    double marg = 10;

    isPadding == false ? pad = 0 : pad = 10;
    isMargin == false ? marg = 0 : marg = 10;

    enabled == true
        ? tekan = widget.tekan!
        : tekan = () => print("perintah disabled");

    bentuk = widget.bentuk ?? BentukBtnModel(BentukBtnModels.round);
    if (bentuk.bentuk == BentukBtnModels.circle) {
      outline = CircleBorder();
    } else if (bentuk.bentuk == BentukBtnModels.stadium) {
      outline = StadiumBorder();
    } else {
      outline =
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
    }

    return Container(
      width: double.infinity,
      height: 60,
      padding: new EdgeInsets.all(pad),
      margin: new EdgeInsets.all(marg),
      child: ElevatedButton(
        onPressed: tekan,
        child: TextIsi2(
          isi: isi,
          ukuran: 14,
          warna: warnaTeks,
          fw: FontWeight.bold,
          align: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaBtn,
          shape: outline,
        ),
      ),
    );
  }
}

class ElevatedBtnWidget extends StatefulWidget {
  final Widget child;
  final Function()? tekan;
  final Color? warnaBtn, warnaTeks;
  final bool? isPadding, isMargin;
  final bool? enabled;
  final BentukBtnModel? bentuk;
  final double? width;
  final double? elevation;

  const ElevatedBtnWidget(
      {Key? key,
      required this.child,
      this.tekan,
      this.warnaBtn,
      this.warnaTeks,
      this.isPadding,
      this.enabled,
      this.bentuk,
      this.isMargin,
      this.width,
      this.elevation})
      : super(key: key);

  @override
  State<ElevatedBtnWidget> createState() => _ElevatedBtnWidgetState();
}

class _ElevatedBtnWidgetState extends State<ElevatedBtnWidget> {
  late Widget child;
  late Function() tekan;
  late Color warnaBtn, warnaTeks;
  late bool isPadding, isMargin;
  late bool enabled;
  late OutlinedBorder outline;
  late BentukBtnModel bentuk;
  late double width;

  @override
  Widget build(BuildContext context) {
    tekan = widget.tekan ?? () => print("perintah kosong");
    warnaBtn = widget.warnaBtn ?? warnaPrimer;
    warnaTeks = widget.warnaTeks ?? warnaPutih;
    isPadding = widget.isPadding ?? true;
    isMargin = widget.isMargin ?? false;
    enabled = widget.enabled ?? true;
    child = widget.child;
    bentuk = widget.bentuk ?? BentukBtnModel(BentukBtnModels.round);
    width = widget.width ?? double.infinity;

    if (enabled == false) {
      warnaBtn = warnaAbu;
      warnaTeks = warnaPutih;
    }

    double pad = 20;
    double marg = 15;

    isPadding == false ? pad = 0 : pad = pad;
    isMargin == false ? marg = 0 : marg = marg;

    enabled == true
        ? tekan = widget.tekan ?? () => print("perintah disabled")
        : tekan = () => print("perintah disabled");

    if (bentuk.bentuk == BentukBtnModels.circle) {
      outline = CircleBorder();
    } else if (bentuk.bentuk == BentukBtnModels.stadium) {
      outline = StadiumBorder();
    } else if (bentuk.bentuk == BentukBtnModels.roundMedium) {
      outline =
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
    } else if (bentuk.bentuk == BentukBtnModels.roundMediumTop) {
      outline =
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0));
    } else {
      outline =
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
    }

    return Container(
      width: width,
      margin: EdgeInsets.all(marg),
      child: ElevatedButton(
        onPressed: tekan,
        child: Center(child: child),
        style: ElevatedButton.styleFrom(
          elevation: widget.elevation ?? 5,
          backgroundColor: warnaBtn,
          surfaceTintColor: warnaBtn,
          shape: outline,
          padding: EdgeInsets.all(pad),
        ),
      ),
    );
  }
}

class BtnStatus extends StatefulWidget {
  final Function tekan;
  final String isi;
  final String status;

  const BtnStatus(
      {Key? key, required this.tekan, required this.isi, required this.status})
      : super(key: key);

  @override
  State<BtnStatus> createState() => _BtnStatusState();
}

class _BtnStatusState extends State<BtnStatus> {
  late Function tekan;
  late String isi;
  late String status;
  late Color warnaBtn;
  late Color warnaTeks;

  @override
  Widget build(BuildContext context) {
    tekan = widget.tekan;
    isi = widget.isi ?? "";
    status = widget.status;

// proses penentuan warna
    tentukanWarna(status);

    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => tekan,
        child: TextIsi2(
          isi: isi,
          warna: warnaTeks,
          fw: FontWeight.bold,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: warnaBtn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  tentukanWarna(String status) {
    if (status == "pending") {
// belum dikonfirmasi
      isi = "Belum Dikonfirmasi";
      warnaBtn = warnaPutihAbu4;
      warnaTeks = warnaPrimer;
    } else if (status == "approve") {
// dikonfirmasi
      isi = "Telah Dikonfirmasi";
      warnaBtn = warnaPrimer;
      warnaTeks = warnaPutih;
    } else if (status == "refused") {
// ditolak
      isi = "Pengajuan Ditolak";
      warnaBtn = warnaMerah;
      warnaTeks = warnaHitam;
    } else if (status == "transfered") {
// Sudah Ditransfer
      isi = "Telah Ditransfer";
      warnaBtn = warnaPrimer;
      warnaTeks = warnaPutih;
    } else if (status == "disabled") {
// Tidak Aktif
      isi = "Tidak Aktif";
      warnaBtn = warnaPutihAbu4;
      warnaTeks = warnaHitam;
    } else if (status == "overtime") {
// Tidak Aktif
      isi = "Melebihi waktu";
      warnaBtn = warnaPutihAbu4;
      warnaTeks = warnaHitam;
    } else if (status == "completed") {
// Diselesaikan
      isi = "Laporan lengkap";
      warnaBtn = warnaHijau;
      warnaTeks = warnaPutih;
    } else if (status == "done") {
// Selesai
      isi = "Sudah Selesai";
      warnaBtn = warnaHijau;
      warnaTeks = warnaPutih;
    } else {
// nonaktif
      isi = "Nonaktif";
      warnaBtn = warnaPutihAbu4;
      warnaTeks = warnaHitam;
    }
  }
}

class BtnTanggal extends StatefulWidget {
  DateTime tanggal;
  Function fnTanggal;
  bool enabled;

  BtnTanggal(
      {Key? key,
      required this.tanggal,
      required this.fnTanggal,
      required this.enabled})
      : super(key: key);

  @override
  State<BtnTanggal> createState() => _BtnTanggalState();
}

class _BtnTanggalState extends State<BtnTanggal> {
  late String btnTeks;
  late String formattedDate;
  late DateTime tanggal;
  late Function fnTanggal;
  late bool enabled;

  @override
  Widget build(BuildContext context) {
    btnTeks = "Pilih Tanggal";
    tanggal = widget.tanggal;
// fnTanggal = widget.fnTanggal;
    enabled = widget.enabled ?? true;

    enabled == true
        ? fnTanggal = widget.fnTanggal
        : fnTanggal = widget.fnTanggal;

    formattedDate = DateFormat('dd/MM/yyyy').format(tanggal);
    tanggal == '' ? btnTeks = "Pilih Tanggal" : btnTeks = formattedDate;

    return Container(
// width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () => fnTanggal,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextIsi2(
            isi: btnTeks,
          ),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: warnaPutih,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: warnaPutihAbu4,
                style: BorderStyle.solid,
                width: 2,
              ),
            )),
      ),
    );
  }
}

class BtnCamera extends StatefulWidget {
  Function fnGaleri, fnKamera;
  bool enabled;

  BtnCamera(
      {Key? key,
      required this.fnKamera,
      required this.fnGaleri,
      required this.enabled})
      : super(key: key);

  @override
  State<BtnCamera> createState() => _BtnCameraState();
}

class _BtnCameraState extends State<BtnCamera> {
  late Function fnGaleri, fnKamera;
  late bool enabled;

  @override
  Widget build(BuildContext context) {
    fnGaleri = widget.fnGaleri;
    fnKamera = widget.fnKamera;
    enabled = widget.enabled ?? true;

    return Container(
      child: ElevatedButton(
        onPressed: () => showModal(),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IcoUpload(),
              TextIsi2(
                isi: "Pilih Foto",
                align: TextAlign.center,
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: warnaPutih,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: warnaPutihAbu4,
                style: BorderStyle.solid,
                width: 2,
              ),
            )),
      ),
    );
  }

  void showModal() {
    if (enabled == true) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BSCameraOrGalery(
              fnGaleri: fnGaleri,
              fnKamera: fnKamera,
            );
          });
    }
  }
}

class BtnFilterDialog extends StatefulWidget {
  const BtnFilterDialog(
      {Key? key, required this.onTapReset, required this.onTapTerapkan})
      : super(key: key);

  @override
  State<BtnFilterDialog> createState() => _BtnFilterState();

  final VoidCallback onTapReset;
  final VoidCallback onTapTerapkan;
}

class _BtnFilterState extends State<BtnFilterDialog> {
  @override
  Widget build(BuildContext context) {
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
              tekan: () => widget.onTapReset,
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
              tekan: () => widget.onTapTerapkan,
            ),
          ),
        ],
      ),
    );
  }
}
