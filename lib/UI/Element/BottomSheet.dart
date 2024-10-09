import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';

class BSCameraOrGalery extends StatefulWidget {
  Function fnKamera, fnGaleri;

  BSCameraOrGalery({Key? key,
    required this.fnGaleri,
    required this.fnKamera})
      : super(key: key);

  @override
  State<BSCameraOrGalery> createState() => _BSCameraOrGaleryState();
}

class _BSCameraOrGaleryState extends State<BSCameraOrGalery> {
  late Function fnGaleri, fnKamera;

  @override
  Widget build(BuildContext context) {
    fnKamera = widget.fnKamera;
    fnGaleri = widget.fnGaleri;

    return Column(
      children: [
        ElevatedBtn(
          tekan: () => fnGaleri,
          isi: "Galeri",
        ),
        ElevatedBtn(
          tekan: () => fnKamera,
          isi: "Kamera",
        )
      ],
    );
  }
}
