import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconTanggalan extends StatelessWidget {
  const IconTanggalan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "lib/assets/icon/tanggal.svg",
    );
  }
}
