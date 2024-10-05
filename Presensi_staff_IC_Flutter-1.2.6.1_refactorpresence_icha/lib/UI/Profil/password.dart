import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Element/SharedPrefs.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Profil/akun.dart';
import 'package:presensi_ic_staff/UI/Profil/model/EditProfil.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/Password.dart';

class PassPage extends StatefulWidget {
  PassPage({Key? key}) : super(key: key);

  @override
  _PassPage createState() => _PassPage();
}

class _PassPage extends State<PassPage> {
  late SharedPreferences sp;
  late String iduser;
  bool isLihat = true;
  var pass1Ctrl = new TextEditingController();
  var pass2Ctrl = new TextEditingController();
  var pass3Ctrl = new TextEditingController();

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
      cekToLogin(iduser, context);
    });
  }

  @override
  void initState() {
    super.initState();
    // loadSP();
    Future loadPage = loadSP();
    loadPage.then((value) {
      cekToLogin(iduser, context);
    });
    BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: tvAkunAppBar,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: bodyWidget(),
        ),
      ),
      floatingActionButton: Container(width: 80, height: 80, child: FabScan()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget bodyWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 150),
      child: Column(
        children: [
          inputPass1(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: imgSeparatorAbu,
          ),
          inputPass2(),
          inputPass3(),
          btnSimpan()
        ],
      ),
    );
  }

  Widget inputPass1() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: pass1Ctrl,
        decoration: InputDecoration(
            hintText: 'Masukkan Password LAMA Anda',
            labelText: 'Password Lama',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget inputPass2() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: pass2Ctrl,
        decoration: InputDecoration(
            hintText: 'Masukkan Password BARU Anda',
            labelText: 'Password Baru',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget inputPass3() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: pass3Ctrl,
        decoration: InputDecoration(
            hintText: 'Ulangi Password BARU Anda',
            labelText: 'Ulangi Password Baru',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget btnSimpan() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 100, bottom: 10),
        child: ElevatedButton(
          onPressed: () =>
              cekSama(pass1Ctrl.text, pass2Ctrl.text, pass3Ctrl.text, iduser),
          child: Text("Simpan".toUpperCase(), style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  cekSama(String pertama, String kedua, String ketiga, String iduser) {
    if (ketiga != kedua) {
      dialogBtn("Password Tidak Sama", "Pastikan password 1 dan 2 sama!", "ok",
          context);
    } else {
      putPass(iduser, pertama, ketiga);
    }
  }

  putPass(String iduser, String pass1, String pass2) {
    Future<ResponUpdatePassword> futurePutPass =
        ApiService().putPassword(pass1, pass2, iduser);
    futurePutPass.then((value) {
      if (value.status == true) {
        dialogBtn("Ubah Password", "Ubah Password berhasil", "ok", context);
      } else {
        dialog1Btn("Ubah Password", "Ubah Password gagal", "ok", context);
      }
    });
  }

  Widget isiDlgIsi(String judul, String isi, String ok, BuildContext context) {
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AkunPage()));
                },
                child: Text(ok.toUpperCase(), style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
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

  dialogBtn(String judul, String isi, String ok, BuildContext context) async {
    await Future.delayed(Duration(microseconds: 0));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return isiDlgIsi(judul, isi, ok, context);
        });
  }
}
