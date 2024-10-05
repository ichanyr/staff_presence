import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';

// ============================= Dashboard
/// Dashboard v2

// svg icon list
enum SvgIconMenus { presensi, riwayat, anggaran, cuti, akun, lembur }

class ListSvgIcon extends StatelessWidget {
  ListSvgIcon(
      {Key? key,
      required this.svgIconMenus,
      this.color,
      this.size,
      this.semanticsLabel})
      : super(key: key);

  SvgIconMenus svgIconMenus;
  Color? color;
  Size? size;
  String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    String path = tentukanPathSvgIcon(svgIconMenus: svgIconMenus);
    color ?? warnaHitam;
    size = size ?? Size(30, 30);

    return SvgPicture.asset(
      path,
      semanticsLabel: semanticsLabel ?? '',
      width: size!.width,
      height: size!.height,
    );
  }

  String tentukanPathSvgIcon({required SvgIconMenus svgIconMenus}) {
    switch (svgIconMenus) {
      case SvgIconMenus.presensi:
        return 'lib/assets/images/dashboard/ico_qr.svg';
      case SvgIconMenus.riwayat:
        return 'lib/assets/images/dashboard/ico_riwayat.svg';
      case SvgIconMenus.anggaran:
        return 'lib/assets/images/dashboard/ico_anggaran.svg';
      case SvgIconMenus.cuti:
        return 'lib/assets/images/dashboard/ico_cuti.svg';
      case SvgIconMenus.akun:
        return 'lib/assets/images/dashboard/ico_akun.svg';
      case SvgIconMenus.lembur:
        return 'lib/assets/images/dashboard/ico_lembur.svg';

      default:
        return 'lib/assets/images/dashboard/ico_lembur.svg';
    }
  }
}

/// Dashboard v1

Widget imgBgWave1 = Container(
    child: SizedBox(
        width: double.infinity,
        child: SvgPicture.asset(
          "lib/assets/images/login/bg_wave1_biru.svg",
          width: 400,
          fit: BoxFit.fill,
        )));

Widget imgIconLogo =
    Container(child: SvgPicture.asset("lib/assets/images/login/img_logo.svg"));

Widget imgBgWave2() {
  return Container(
      child: SizedBox(
          width: double.infinity,
          child: SvgPicture.asset(
            "lib/assets/images/login/bg_wave2.svg",
            width: 400,
            fit: BoxFit.fill,
          )));
}

Widget imgBgBiru = Container(
    child: SizedBox(
        width: double.infinity,
        child: SvgPicture.asset("lib/assets/images/login/img_bg_biru.svg",
            width: 400)));

Widget imgDash = Container(
    child: SvgPicture.asset("lib/assets/images/login/img_dashboard.svg"));

class ImgDashPng extends StatelessWidget {
  final String img;

  const ImgDashPng({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image(
            fit: BoxFit.fill,
            image: AssetImage(
              img,
            )));
  }
}

Widget imgIcoIn = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_in.svg"),
);

Widget imgIcoOut = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_out.svg"),
);

Widget imgKotakTgl = Container(
  child: SvgPicture.asset('lib/assets/images/login/img_dashTanggal.svg'),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  ),
);

Widget imgKotakBiru = Expanded(
    child: SvgPicture.asset('lib/assets/images/login/img_kotak_biru.svg'));

Widget imgScan = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_scan.svg"),
);

Widget imgScan2 = Material(
  elevation: 3,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  child: SvgPicture.asset(
    "lib/assets/images/login/btn_presensi.svg",
    height: 80,
    width: 80,
  ),
);

Widget imgAkun = Material(
  elevation: 3,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  child: SvgPicture.asset(
    "lib/assets/images/login/btn_akun.svg",
    width: 80,
    height: 80,
  ),
);

class ImgCuti extends StatelessWidget {
  const ImgCuti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: SvgPicture.asset(
        "lib/assets/images/dashboard/btn_izin.svg",
        width: 80,
        height: 80,
      ),
    );
  }
}

Widget imgAnggaran = Material(
  elevation: 3,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  child: SvgPicture.asset(
    "lib/assets/images/login/btn_anggaran.svg",
    width: 80,
    height: 80,
  ),
);

Widget imgRiwayat = Material(
  elevation: 3,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  child: SvgPicture.asset(
    "lib/assets/images/login/btn_riwayat.svg",
    height: 80,
    width: 80,
  ),
);

Widget imgLupaPass = Container(
    child:
        Image(image: AssetImage('lib/assets/images/login/img_lupa_pass.png')));

Widget imgFilter = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_filter.svg"),
);

// Widget imgSeparator = SvgPicture.asset(
//   "lib/assets/images/login/img_separator.svg",
// );

class imgSeparator extends StatelessWidget {
  const imgSeparator({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Divider(
        color: color ?? Colors.white,
        height: 4,
        thickness: 4,
      ),
    );
  }
}

Widget imgSeparatorAbu = SvgPicture.asset(
  "lib/assets/images/login/img_separator.svg",
  color: Colors.black12,
);

Widget imgEdit = Container(
  child: SvgPicture.asset("lib/assets/images/login/pen-solid.svg",
      height: 20, width: 20),
);

Widget imgReset = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_reset.svg",
      color: Colors.blue, height: 20, width: 20),
);

Widget imgRefresh = Container(
  child: SvgPicture.asset("lib/assets/images/login/ico_refresh.svg",
      color: Colors.blue, height: 20, width: 20),
);

Widget imgWarning() {
  return SizedBox(
    width: 50,
    child: SvgPicture.asset("lib/assets/images/login/btn_warning.svg",
        width: 50, height: 50),
  );
}

class imgNavBulan extends StatefulWidget {
  const imgNavBulan({Key? key}) : super(key: key);

  @override
  State<imgNavBulan> createState() => _imgNavBulanState();
}

class _imgNavBulanState extends State<imgNavBulan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset("lib/assets/images/anggaran/img_nav_bulan.svg",
          color: warnaPrimer, height: 20, width: 20),
    );
  }
}

class IcoUpload extends StatefulWidget {
  const IcoUpload({Key? key}) : super(key: key);

  @override
  State<IcoUpload> createState() => _IcoUploadState();
}

class _IcoUploadState extends State<IcoUpload> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset("lib/assets/images/anggaran/img_upload.svg",
          color: warnaPrimer, height: 20, width: 20),
    );
  }
}

class ImgDataKosong extends StatelessWidget {
  const ImgDataKosong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset("lib/assets/images/anggaran/img_nodata.svg",
          color: warnaPrimer, height: 300, width: 300),
    );
  }
}

class BgBulatAtas extends StatelessWidget {
  const BgBulatAtas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: SvgPicture.asset("lib/assets/images/dashboard/kotak_bulat.svg",
          color: warnaBiruCard, fit: BoxFit.fill),
    );
  }
}

class IcoFeedback extends StatelessWidget {
  const IcoFeedback({Key? key, this.size}) : super(key: key);
  final double? size;

  @override
  Widget build(BuildContext context) {
    double ukuran = size ?? 50;
    return Container(
      width: ukuran,
      height: ukuran,
      child: SvgPicture.asset("lib/assets/images/riwayat/feedback.svg",
          color: warnaPrimer),
      // child: TextIsi2(isi: 'asdf'),
    );
  }
}
