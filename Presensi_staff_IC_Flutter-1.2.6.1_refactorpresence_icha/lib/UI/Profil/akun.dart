import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/SharedPrefs.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Profil/Controller/AkunController.dart';
import 'package:presensi_ic_staff/UI/Profil/model/EditProfil.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';
import 'package:presensi_ic_staff/UI/Profil/password.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';

class AkunPage extends StatefulWidget {
  AkunPage({Key? key, this.idUser}) : super(key: key);

  final String? idUser;

  @override
  _AkunPage createState() => _AkunPage();
}

class _AkunPage extends State<AkunPage> {
  late SharedPreferences sp;
  late String iduser, emailString;
  bool isLihat = true;
  var emailCtrl = new TextEditingController();
  var hpCtrl = new TextEditingController();
  var alamatCtrl = new TextEditingController();

  /// Akun controller
  AkunController akunCtrl = AkunController();

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
      emailString = (sp.getString('email') ?? '');
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
        child: ScrollDenganResponsive(
          child: printAkun(),
        ),
      ),
    );
  }

  Widget printAkun() {
    akunCtrl.onInit();

    return akunCtrl.obx(
      (state) => Container(
        padding: const EdgeInsets.all(30),
        margin: EdgeInsets.only(bottom: 100),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: isLihat,
              child: Column(
                children: [
                  wUsername(state!.dataProfil.name ?? ''),
                  wTelpon(state.dataProfil.idStaff ?? ''),
                  wTelpon(state.dataProfil.phone ?? ''),
                  wEmail(state.dataProfil.email ?? ''),
                  wGender(state.dataProfil.gender ?? ''),
                  wAlamat(state.dataProfil.address ?? ''),
                  wCabang(state.dataProfil.namaCabang ?? ''),
                  pass(),
                  btnEdit(),
                  btnLogout()
                ],
              ),
            ),
            editAkun(state.dataProfil.email!, state.dataProfil.phone!,
                state.dataProfil.address!),
          ],
        ),
      ),
      onLoading: Center(child: LoadingIc()),
      onError: (e) => TextFormatting(text: 'Terjadi Error $e'),
    );
  }

  Widget wUsername(String nama) {
    nama == "" ? nama = "[Nama Kosong]" : nama = nama;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imgSeparatorAbu,
        Padding(
            padding: const EdgeInsets.only(top: 10), child: textIsiLeft(nama)),
      ],
    );
  }

  Widget wTelpon(String telp) {
    telp == "" ? telp = "[Nama Kosong]" : telp = telp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10), child: textIsiLeft(telp)),
      ],
    );
  }

  Widget wEmail(String email) {
    email == "" ? email = "[email kosong]" : email = email;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10), child: textIsiLeft(email))
      ],
    );
  }

  Widget wGender(String gender) {
    gender == "" ? gender = "[Gender belum di-setting]" : gender = gender;
    if (gender == "l" || gender == "L") {
      gender = "Laki-Laki";
    } else {
      gender = "Perempuan";
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10), child: textIsiLeft(gender))
      ],
    );
  }

  Widget wAlamat(String alamat) {
    alamat == "" ? alamat = "[alamat kosong]" : alamat = alamat;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: textIsiLeft(alamat)),
      ],
    );
  }

  Widget wCabang(String cabang) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: textIsiLeft(cabang ?? "[Cabang Kosong]")),
      ],
    );
  }

  Widget btnEdit() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 50, bottom: 10),
        child: ElevatedButton(
          onPressed: () => setState(() => isLihat = !isLihat),
          child: Text("Edit".toUpperCase(), style: TextStyle(fontSize: 20)),
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

  Widget btnLogout() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ElevatedButton(
          onPressed: () => dialogLogout("Logout",
              "Apakah anda yakin ingin keluar dari akun ini ?", context),
          child: Text("logout".toUpperCase(), style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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

  Widget editAkun(String email, String hp, String alamat) {
    return Visibility(
      visible: !isLihat,
      child: Column(
        children: [
          inputEmail(email),
          inputHp(hp),
          inputAlamat(alamat),
          btnUbahPass(),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: btnBatal(),
          ),
          btnSimpan()
        ],
      ),
    );
  }

  Widget inputEmail(String email) {
    emailCtrl.text = email;
    return Container(
      // width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                  hintText: 'Masukkan Email Anda',
                  labelText: 'Email',
                  border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 50,
            child: InkWell(
              onTap: () => warningEmail(context),
              child: imgWarning(),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputHp(String hp) {
    hpCtrl.text = hp;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: hpCtrl,
        decoration: InputDecoration(
            hintText: 'Masukkan No Hp Anda',
            labelText: 'Hp',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget inputAlamat(String alamat) {
    alamatCtrl.text = alamat;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: alamatCtrl,
        maxLength: 200,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: 'Masukkan alamat Anda',
            labelText: 'Alamat',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget pass() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: textIsiLeft("***********")),
        Padding(
            padding: const EdgeInsets.only(top: 10), child: imgSeparatorAbu),
      ],
    );
  }

  Widget btnBatal() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 50, bottom: 10),
        child: ElevatedButton(
          onPressed: () => setState(() => isLihat = !isLihat),
          child: Text("Batal".toUpperCase(), style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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

  Widget btnSimpan() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ElevatedButton(
          onPressed: () => simpanPerubahan(
              iduser, emailCtrl.text, hpCtrl.text, alamatCtrl.text, context),
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

  Widget btnUbahPass() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => PassPage())),
          child: Text("Ubah Password".toUpperCase(),
              style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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

  simpanPerubahan(String idUser, String email, String hp, String alamat,
      BuildContext context) {
    Future<ProfilEdit> futureEditProfil =
        ApiService().putProfil(idUser, hp, email, alamat);
    futureEditProfil.then((value) {
      if (value.status == true) {
        dialog1Btn("Ubah Profil", "Ubah Profil berhasil", "ok", context);
        setState(() {
          isLihat = !isLihat;
        });
      } else {
        dialog1Btn("Ubah Profil", "Ubah Profil gagal", "ok", context);
      }
    });
  }

  logout() {
    setState(() {
      SharedPrefUtils.clearSharedPref();
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Widget isiDlgLogout(String judul, String isi, BuildContext context) {
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
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text("batal".toUpperCase(), style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => logout(),
                child: Text("ok".toUpperCase(), style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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

  dialogLogout(String judul, String isi, BuildContext context) async {
    await Future.delayed(Duration(microseconds: 0));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return isiDlgLogout(judul, isi, context);
        });
  }

  warningEmail(BuildContext context) {
    dialog1Btn(
        "Peringatan",
        "Pastikan email aktif, Karena akan digunakan untuk login akun!",
        "ok",
        context);
  }
}
