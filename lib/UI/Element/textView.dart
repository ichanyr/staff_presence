import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Login/lupaPass.dart';

import 'Warna.dart';

Widget txtLupaPass = Container(
    child: Container(
        padding: const EdgeInsets.all(10), child: Text("Lupa akun ?")));

Widget txtPresensi = Container(
  child: Text(
    "Presensi",
    style: TextStyle(fontFamily: 'Nunito', fontSize: 40, color: Colors.white),
  ),
);

// ============================= Dashboard

Widget txtPresensiBtn = Container(
  child: Text(
    "Presensi",
    overflow: TextOverflow.ellipsis,
    style:
        TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.blueAccent),
  ),
);

Widget txtRiwayatBtn = Container(
  child: Text(
    "Riwayat",
    style:
        TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.blueAccent),
  ),
);

Widget txtAkunBtn = Container(
  child: Text(
    "Akun",
    style:
        TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.blueAccent),
  ),
);

Widget txtAnggaranBtn = Container(
  child: Text(
    "anggaran",
    style:
        TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.blueAccent),
  ),
);

class TxtMenu extends StatefulWidget {
  final String? teks;

  const TxtMenu({Key? key, this.teks}) : super(key: key);

  @override
  State<TxtMenu> createState() => _TxtMenuState();
}

class _TxtMenuState extends State<TxtMenu> {
  late String teks;

  @override
  Widget build(BuildContext context) {
    teks = widget.teks ?? '';

    return Text(
      teks,
      style: TextStyle(
          fontFamily: 'Nunito', fontSize: 20, color: Colors.blueAccent),
    );
  }
}

Widget txtStaff = Container(
  child: Text(
    "Staff",
    style: TextStyle(fontFamily: 'Nunito', fontSize: 25, color: Colors.white),
  ),
);

Widget txtHi(String nama) {
  return Container(
    child: Text(
      "Hi, selamat datang " + nama + "!",
      style: TextStyle(fontFamily: 'Nunito', fontSize: 25, color: Colors.white),
    ),
  );
}

Widget txtTanggal = Container(
  child: Text(
    "21-01-2021",
    style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
  ),
);

Widget txtPoin = Container(
  child: Text(
    "0\nPoin",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 20,
      color: Colors.black,
    ),
  ),
);

Widget txtJM = Container(
  child: Text("08.00",
      style:
          TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black)),
);

Widget txtJK = Container(
  child: Text("16.00",
      style:
          TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black)),
);

Widget tvLupaPassAppBar = Text(
  "Lupa Password",
  style: TextStyle(
    color: Colors.black,
  ),
);

Widget tvRiwayatAppBar = Text(
  "Riwayat",
  style: TextStyle(
    color: Colors.black,
  ),
);

Widget tvDRiwayatAppBar = Text(
  "Detail Riwayat",
  style: TextStyle(
    color: Colors.black,
  ),
);

Widget tvAkunAppBar = Text(
  "Profil",
  style: TextStyle(
    color: Colors.black,
  ),
);

Widget tvPresensiQR = Text(
  "Presensi",
  style: TextStyle(
    color: Colors.black,
  ),
);

class TvLupaPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
      child: InkWell(
        child: Text("Lupa akun ?"),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LupaPassPage()));
        },
      ),
    );
  }
}

Widget txtInsResetPass = Container(
  child: Text(
      "Masukkan email, tekan Reset Password, Kemudian ikuti instruksi di Email.",
      style:
          TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black)),
);

Widget tvPoin = Container(
  child: Text("Poin",
      style:
          TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black)),
);

Widget tvFilter = Container(
  child: Text("Filter",
      style:
          TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.black)),
);

Widget tvTanggal = Text(
  "26-1-2021",
  style: TextStyle(fontFamily: "Nunito", fontSize: 30, color: Colors.black),
);

Widget tvTanggalIsi = Text(
  "26-1-2021",
  style: TextStyle(fontFamily: "Nunito", fontSize: 30, color: Colors.black),
);

Widget tvKeterlambatan = Text(
  'Keterlambatan',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvPoinDidapat = Text(
  'Poin Didapat',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvFotoDatang = Text(
  'Foto datang',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvFotoPulang = Text(
  'Foto Pulang',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvKetDatang = Text(
  'Keterangan Datang',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvKetPulang = Text(
  'Keterangan Pulang',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget tvLapAkt = Text(
  'Laporan Aktivitas',
  style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.black),
);

Widget textIsi(String isi) {
  return Text(
    isi,
    textAlign: TextAlign.right,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.black),
  );
}

Widget textIsiCenter(String isi) {
  return Text(
    isi,
    textAlign: TextAlign.center,
    style: TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.black),
  );
}

Widget textIsiLeft(String isi) {
  return Text(
    isi,
    textAlign: TextAlign.left,
    style: TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.black),
  );
}

Widget textIsiGray(String isi) {
  return Text(
    isi,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.grey),
  );
}

Widget textIsiWhite(String isi) {
  return Text(
    isi,
    style: TextStyle(fontFamily: "Nunito", fontSize: 20, color: Colors.white),
  );
}

Widget textIsi2(
    {String? isi,
    Color? warna,
    double? ukuran,
    FontWeight? fw,
    TextAlign? align}) {
  warna == null ? warna = Colors.black : warna;
  ukuran == null ? ukuran = 20 : ukuran;
  fw == null ? fw = FontWeight.normal : fw;
  align == null ? align = TextAlign.left : align;
  return Text(
    isi ?? '',
    textAlign: align,
    style: TextStyle(
        fontFamily: "Nunito", fontSize: ukuran, color: warna, fontWeight: fw),
  );
}

// widget Text isi reusable
class TextIsi2 extends StatefulWidget {
  final String? isi;
  final Color? warna;
  final double? ukuran;
  final FontWeight? fw;
  final TextAlign? align;
  final TextOverflow? textOverflow;

  const TextIsi2(
      {Key? key,
      this.isi,
      this.warna,
      this.ukuran,
      this.fw,
      this.align,
      this.textOverflow})
      : super(key: key);

  @override
  State<TextIsi2> createState() => _TextIsi2State();
}

class _TextIsi2State extends State<TextIsi2> {
  late String isi;
  late Color warna;
  late double ukuran;
  late FontWeight fw;
  late TextAlign align;
  late TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    // double lebar = Get.width;

    isi = widget.isi ?? '';
    warna = widget.warna ?? warnaHitam;
    ukuran = widget.ukuran ?? 20;
    fw = widget.fw ?? FontWeight.normal;
    align = widget.align ?? TextAlign.left;
    textOverflow = widget.textOverflow ?? TextOverflow.ellipsis;

    if (isi != '') {
      isi.contains("[") && isi.contains("]") ? warna = warnaAbu : warna = warna;
    }

    isi != '' ? isi : isi = "";
    // isi == "" ? isi = "kosong" : isi;

    return Text(
      isi,
      textAlign: align,
      overflow: textOverflow,
      style: TextStyle(
          fontFamily: "Nunito", fontSize: ukuran, color: warna, fontWeight: fw),
    );
  }
}
