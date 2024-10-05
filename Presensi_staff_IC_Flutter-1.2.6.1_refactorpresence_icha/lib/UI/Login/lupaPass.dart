import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Password.dart';

class LupaPassPage extends StatefulWidget {
  @override
  _LupaPassPage createState() => _LupaPassPage();
}

class _LupaPassPage extends State<LupaPassPage> {
  var emailCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: tvLupaPassAppBar,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: bodyWidget(),
      ),
    );
  }

  Widget bodyWidget() {
    return Column(
      children: <Widget>[
        imgLupaPass,
        Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: txtInsResetPass,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: inputEmail(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(width: double.infinity, child: btnLupaPass()),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget inputEmail() {
    return Container(
      child: TextField(
        controller: emailCtrl,
        decoration: InputDecoration(
            hintText: 'Masukkan Email Anda',
            labelText: 'Email',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget btnLupaPass() {
    return ElevatedButton(
      onPressed: () {
        lupaPass(emailCtrl.text);
      },
      child: Text("Reset Password", style: TextStyle(fontSize: 20)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  lupaPass(String email) {
    Future<ResponUpdatePassword> futureLupaPass =
        ApiService().postLupaPass(email);
    futureLupaPass.then((value) {
      if (value != null) {
        if (value.status == true) {
          dialog1Btn("Reset Password berhasil!",
              "Silahkan cek email untuk petunjuk selanjutnya", "ok", context);
        } else {
          dialog1Btn(
              "Reset Password Gagal!", "Periksa Email anda!", "ok", context);
          setState(() {});
        }
      } else {
        dialog1Btn(
            "Reset Password Gagal!", "Periksa Koneksi anda!", "ok", context);
        setState(() {});
      }
    });
  }
}
