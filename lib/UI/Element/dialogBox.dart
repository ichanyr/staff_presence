import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import '../../assets/TextCustom.dart';
import '../../assets/ukuran.dart';
import 'ScrollAndResponsive.dart';
import 'Warna.dart';

Widget isiDialog(String isi) {
  return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1000,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: textIsiLeft(isi),
      ));
}

tampilDialog(String isi, BuildContext context) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return isiDialog(isi);
      });
}

Future<void> showSukses(String isi, BuildContext context) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return isiDialog(isi);
      });
}

moveDashboard(BuildContext context) async {
  await Future.delayed(Duration.zero, () async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  });
}

Widget isiDlgBtnIsi(String judul, String isi, String ok, BuildContext context) {
  Future futureTodo;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 1000,
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textIsiLeft(judul),
          textIsi(""),
          textIsiLeft(isi),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(ok.toUpperCase(), style: TextStyle(fontSize: 20)),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

dialog1Btn(String judul, String isi, String ok, BuildContext context) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return isiDlgBtnIsi(judul, isi, ok, context);
      });
}

Widget wdImage(String image, BuildContext context) {
  Future futureTodo;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 1000,
    child: ScrollDenganResponsive(
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            printImage(image),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ok".toUpperCase(), style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget printImage(String image) {
  return Container(
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Image.network(image, fit: BoxFit.fitWidth, width: 150),
    ),
  );
}

dialogImage(String gambar, BuildContext context) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return wdImage(gambar, context);
      });
}

class IsiDialog extends StatefulWidget {
  final String judul;
  final String isi;
  final String btn1;
  final String btn2;
  final String btn3;
  final VoidCallback fnBtn1;
  final VoidCallback fnBtn2;
  final VoidCallback fnBtn3;
  final Color warnaBtn1, warnaTeksBtn1, warnaBtn3, warnaTeksBtn3;
  final Color warnaBtn2, warnaTeksBtn2;

  const IsiDialog(
      {Key? key,
      required this.judul,
      required this.isi,
      required this.btn1,
      required this.btn2,
      required this.fnBtn1,
      required this.fnBtn2,
      required this.warnaBtn1,
      required this.warnaTeksBtn1,
      required this.warnaBtn2,
      required this.warnaTeksBtn2,
      required this.btn3,
      required this.fnBtn3,
      required this.warnaBtn3,
      required this.warnaTeksBtn3})
      : super(key: key);

  @override
  State<IsiDialog> createState() => _IsiDialogState();
}

class _IsiDialogState extends State<IsiDialog> {
  late String judul;
  late String isi;
  late String btn1;
  late String btn2;
  late String btn3;

  late VoidCallback fnBtn1;
  late VoidCallback fnBtn2;
  late VoidCallback fnBtn3;

  bool isLihatIsi = false;
  bool isLihatBtn1 = false;
  bool isLihatBtn2 = false;
  bool isLihatBtn3 = false;

  late Color warnaBtn1, warnaTeksBtn1;
  late Color warnaBtn2, warnaTeksBtn2;
  late Color warnaBtn3, warnaTeksBtn3;

  @override
  Widget build(BuildContext context) {
    judul = widget.judul;
    widget.isi == "" ? isi = "" : isi = widget.isi;
    widget.btn1 == "" ? btn1 = "" : btn1 = widget.btn1;
    widget.btn2 == "" ? btn2 = "" : btn2 = widget.btn2;
    widget.btn3 == "" ? btn3 = "" : btn3 = widget.btn3;

    fnBtn1 = widget.fnBtn1;
    fnBtn2 = widget.fnBtn2;
    fnBtn3 = widget.fnBtn3;

    warnaBtn1 = widget.warnaBtn1;
    warnaBtn2 = widget.warnaBtn2;
    warnaBtn3 = widget.warnaBtn3;

    warnaTeksBtn1 = widget.warnaTeksBtn1;
    warnaTeksBtn2 = widget.warnaTeksBtn2;
    warnaTeksBtn3 = widget.warnaTeksBtn3;

    widget.isi == "" ? isLihatIsi = false : isLihatIsi = true;
    // widget.fnBtn1 == () {} ? isLihatBtn1 = false : isLihatBtn1 = true;
    // widget.fnBtn2 == () {} ? isLihatBtn2 = false : isLihatBtn2 = true;
    // widget.fnBtn3 == () {} ? isLihatBtn3 = false : isLihatBtn3 = true;
    btn1 == '' ? isLihatBtn1 = false : isLihatBtn1 = true;
    btn2 == '' ? isLihatBtn2 = false : isLihatBtn2 = true;
    btn3 == '' ? isLihatBtn3 = false : isLihatBtn3 = true;

    // widget.fnBtn1 == () {} ? fnBtn1 = fnKosong : fnBtn1 = () => widget.fnBtn1;
    // widget.fnBtn2 == () {} ? fnBtn2 = fnKosong : fnBtn2 = () => widget.fnBtn2;
    // widget.fnBtn3 == () {} ? fnBtn3 = fnKosong : fnBtn3 = () => widget.fnBtn3;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1000,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textIsiLeft(judul),
            textIsi(""),
            textIsiLeft(isi),
            // btn1
            Visibility(
              visible: isLihatBtn1,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: fnBtn1,
                  child:
                      Text(btn1.toUpperCase(), style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(warnaTeksBtn1),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(warnaBtn1),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // btn3
            Visibility(
              visible: isLihatBtn2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () => fnBtn2,
                  child:
                      Text(btn2.toUpperCase(), style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(warnaTeksBtn2),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(warnaBtn2),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // btn3
            Visibility(
              visible: isLihatBtn3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () => fnBtn3,
                  child:
                      Text(btn3.toUpperCase(), style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(warnaTeksBtn3),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(warnaBtn3),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

dialogBox(
    {String? judul,
    String? isi,
    String? btn1,
    String? btn2,
    String? btn3,
    VoidCallback? fnBtn1,
    VoidCallback? fnBtn2,
    VoidCallback? fnBtn3,
    Color? warnaBtn1,
    Color? warnaTeksBtn1,
    Color? warnaBtn2,
    Color? warnaTeksBtn2,
    Color? warnaBtn3,
    Color? warnaTeksBtn3,
    required BuildContext context}) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return IsiDialog(
          judul: judul ?? '',
          isi: isi ?? '',
          btn1: btn1 ?? '',
          fnBtn1: fnBtn1!,
          btn2: btn2 ?? '',
          fnBtn2: () => fnBtn2,
          btn3: btn3 ?? '',
          fnBtn3: () => fnBtn3,
          warnaBtn1: warnaBtn1 ?? warnaPrimer,
          warnaBtn2: warnaBtn2 ?? warnaPrimer,
          warnaBtn3: warnaBtn3 ?? warnaPrimer,
          warnaTeksBtn1: warnaTeksBtn1 ?? warnaPrimer,
          warnaTeksBtn2: warnaTeksBtn2 ?? warnaPrimer,
          warnaTeksBtn3: warnaTeksBtn3 ?? warnaPrimer,
        );
      });
}

class DialogWidget extends StatefulWidget {
  final Widget child;

  const DialogWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  late Widget child;

  @override
  Widget build(BuildContext context) {
    child = widget.child;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1000,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

Future<void> dialogBoxWidget(
    {required Widget child, required BuildContext context}) async {
  await Future.delayed(Duration(microseconds: 0));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          child: child,
        );
      });
}

void fnKosong() {
  print("Perintah Kosong");
}

Future<void> getDialog(
    {required Widget body,
    required String title,
    EdgeInsets? padding,
    TextOverflow? titleOverflow,
    bool? barrierDismissible}) async {
  padding ?? EdgeInsets.symmetric(horizontal: marginTepi, vertical: marginTepi);

  Get.dialog(
      Center(
        child: ScrollDenganResponsive(
          child: Container(
            margin: EdgeInsets.all(marginTepi * 2),
            padding: EdgeInsets.all(marginTepi),
            // color: warnaPutih,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radiusMed),
                color: warnaPutih),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: TextStyle(),
                  child: TextFormatting(
                      text: title,
                      overflow: titleOverflow ?? TextOverflow.visible,
                      formatTek: FormatTeks.H1,
                      textAlign: TextAlign.center),
                ),
                Container(
                  margin: EdgeInsets.only(top: marginAntarContent),
                  child: DefaultTextStyle(style: TextStyle(), child: body),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible ?? true,
      useSafeArea: true);
}

Future<void> getDialogLoading(
    {EdgeInsets? padding, bool? barrierDismissible}) async {
  padding ?? EdgeInsets.symmetric(horizontal: marginTepi, vertical: marginTepi);

  Get.dialog(
      Center(
        child: ScrollDenganResponsive(
          child: Container(
            margin: EdgeInsets.all(marginTepi * 2),
            padding: EdgeInsets.all(marginTepi),
            // color: warnaPutih,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radiusMed),
                color: warnaPutih),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible ?? true,
      useSafeArea: true);
}
