// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
// import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
// import 'package:presensi_ic_staff/UI/Element//button.dart';
// import 'package:presensi_ic_staff/UI/Element/SharedPrefs.dart';
// import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
// import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
// import 'package:presensi_ic_staff/UI/Element/inputText.dart';
// import 'package:presensi_ic_staff/UI/Element/textView.dart';
// import 'package:presensi_ic_staff/UI/Login/Model/Login.dart';
// import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
// import 'package:presensi_ic_staff/UI/Element/Warna.dart';
// import 'package:presensi_ic_staff/UI/Login/lupaPass.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({Key? key, this.btnLogin}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final ElevatedButton? btnLogin;

//   @override
//   _LoginPage createState() => _LoginPage();
// }

// class _LoginPage extends State<LoginPage> {
//   int _counter = 0;
//   TextEditingController emailCtrl = new TextEditingController();
//   TextEditingController passCtrl = new TextEditingController();
//   late SharedPreferences sp;
//   bool _isHidePassword = true;

//   /// refresh controller
//   RefreshController refreshController = RefreshController();

//   @override
//   Widget build(BuildContext context) {
//     loadSP();
//     return Scaffold(
//       body: ScrollDenganReload(
//           refreshController: refreshController,
//           onRefresh: () {},
//           child: bodyPage()),
//     );
//   }

//   Widget bodyPage() {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           // gambar
//           SizedBox(
//             width: double.infinity,
//             child: Stack(alignment: Alignment.center, children: <Widget>[
//               // bg wave
//               imgBgWave1,

//               // logo
//               Container(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[imgIconLogo, txtPresensi, txtStaff]),
//               ),
//             ]),
//           ),

//           // input
//           Padding(
//             padding: const EdgeInsets.only(left: 50, right: 50),
//             child: Column(children: <Widget>[
//               inputEmail(),
//               inputPass(),
//               btnLogin(),
//               btnLupaPass()
//             ]),
//           )
//         ],
//       ),
//     );
//   }

//   Widget btnLogin() {
//     return SizedBox(
//       width: double.infinity,
//       child: Container(
//         margin: const EdgeInsets.only(top: 30, bottom: 10),
//         child: ElevatedButton(
//           onPressed: () {
//             login();
//           },
//           child: Text("Login".toUpperCase(), style: TextStyle(fontSize: 20)),
//           style: ButtonStyle(
//             padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
//             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//             backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget btnLupaPass() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 100),
//       child: SizedBox(
//         width: double.infinity,
//         child: InkWell(
//           child: Center(child: txtLupaPass),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => LupaPassPage()));
//           },
//         ),
//       ),
//     );
//   }

//   Widget inputEmail() {
//     return Container(
//       child: TextField(
//         controller: emailCtrl,
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//             hintText: 'Masukkan Email Anda',
//             labelText: 'Email',
//             border: OutlineInputBorder()),
//       ),
//     );
//   }

//   Widget inputPass() {
//     return Container(
//       child: Container(
//         margin: const EdgeInsets.only(top: 20),
//         child: TextField(
//           obscureText: _isHidePassword,
//           enableSuggestions: false,
//           autocorrect: false,
//           controller: passCtrl,
//           keyboardType: TextInputType.visiblePassword,
//           decoration: InputDecoration(
//             hintText: 'Masukkan Password Anda',
//             labelText: 'Password',
//             border: OutlineInputBorder(),
//             suffixIcon: GestureDetector(
//               onTap: () => _togglePasswordVisibility(),
//               child: Icon(
//                 _isHidePassword ? Icons.visibility_off : Icons.visibility,
//                 color: _isHidePassword ? Colors.grey : Colors.blue,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isHidePassword = !_isHidePassword;
//     });
//   }

//   login() {
//     // Log input email dan password (jika diperlukan, pastikan tidak mencetak password di produksi)
//     print(
//         "Login attempt: email = ${emailCtrl.text}, password = ${passCtrl.text}");

//     Future<Login> futureTodo =
//         ApiService().postLogin("a", emailCtrl.text, passCtrl.text);

//     futureTodo.then((value) {
//       // Log respon dari API
//       print("API Response: ${value.toString()}");

//       if (value.status == true) {
//         print("Login successful: idStaff = ${value.idStaff}");

//         sp.setString("iduser", value.idStaff!);
//         SharedPrefUtils.saveStr("iduser", value.idStaff!);
//         dialog1BtnLogin("Login Berhasil", "ok", context);
//       } else {
//         print("Login failed: Incorrect email or password");

//         dialog1Btn(
//             "Login gagal", "Periksa Email dan Password anda!", "ok", context);
//       }
//     }).catchError((error) {
//       // Log jika terjadi error saat proses login
//       print("Error saat login: $error");

//       dialog1Btn("Login gagal", "Terjadi kesalahan: $error", "ok", context);
//     });
//   }

//   loadSP() async {
//     sp = await SharedPreferences.getInstance();
//   }

//   Widget isiDialogLoginBerhasil(String isi, String ok, BuildContext context) {
//     Future futureTodo;
//     return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 1000,
//         child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 textIsiLeft(isi),
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => DashboardPage())),
//                     // moveDashboard(context),
//                     child:
//                         Text(ok.toUpperCase(), style: TextStyle(fontSize: 20)),
//                     style: ButtonStyle(
//                       padding: MaterialStateProperty.all<EdgeInsets>(
//                           EdgeInsets.all(15)),
//                       foregroundColor:
//                           MaterialStateProperty.all<Color>(Colors.white),
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.green),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )));
//   }

//   dialog1BtnLogin(String isi, String ok, BuildContext context) async {
//     await Future.delayed(Duration(microseconds: 0));
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return isiDialogLoginBerhasil(isi, ok, context);
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/SharedPrefs.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Login/Model/Login.dart';
import 'package:presensi_ic_staff/UI/Login/lupaPass.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.btnLogin}) : super(key: key);

  final ElevatedButton? btnLogin;

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();
  late SharedPreferences sp;
  bool _isHidePassword = true;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    cekLogin(); // Panggil cekLogin saat halaman dimuat
  }

  void cekLogin() async {
    sp = await SharedPreferences.getInstance();
    String? idUser = sp.getString("iduser");

    if (idUser != null && idUser.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DashboardPage()), // Ganti dengan halaman Dashboard yang sesuai
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollDenganReload(
        refreshController: refreshController,
        onRefresh: () {},
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              imgBgWave1,
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[imgIconLogo, txtPresensi, txtStaff]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(children: <Widget>[
              inputEmail(),
              inputPass(),
              btnLogin(),
              btnLupaPass()
            ]),
          ),
        ],
      ),
    );
  }

  Widget btnLogin() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 10),
        child: ElevatedButton(
          onPressed: () {
            login();
          },
          child: Text("Login".toUpperCase(), style: TextStyle(fontSize: 20)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
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
    );
  }

  Widget btnLupaPass() {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          child: Center(child: txtLupaPass),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LupaPassPage()));
          },
        ),
      ),
    );
  }

  Widget inputEmail() {
    return Container(
      child: TextField(
        controller: emailCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Masukkan Email Anda',
            labelText: 'Email',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget inputPass() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: TextField(
          obscureText: _isHidePassword,
          enableSuggestions: false,
          autocorrect: false,
          controller: passCtrl,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Masukkan Password Anda',
            labelText: 'Password',
            border: OutlineInputBorder(),
            suffixIcon: GestureDetector(
              onTap: () => _togglePasswordVisibility(),
              child: Icon(
                _isHidePassword ? Icons.visibility_off : Icons.visibility,
                color: _isHidePassword ? Colors.grey : Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void login() {
    print(
        "Login attempt: email = ${emailCtrl.text}, password = ${passCtrl.text}");

    Future<Login> futureTodo =
        ApiService().postLogin("a", emailCtrl.text, passCtrl.text);

    print("Calling API...");

    futureTodo.then((value) {
      print("API Response: ${value.toString()}");

      if (value.status == true) {
        print("Login successful: idStaff = ${value.idStaff}");

        sp.setString("iduser", value.idStaff!);
        SharedPrefUtils.saveStr("iduser", value.idStaff!);

        print("Displaying success dialog and navigating to dashboard...");

        dialog1BtnLogin("Login Berhasil", "ok", context);
      } else {
        print("Login failed: Incorrect email or password");

        dialog1Btn(
            "Login gagal", "Periksa Email dan Password anda!", "ok", context);
      }
    }).catchError((error) {
      print("Error during login: $error");

      dialog1Btn("Login gagal", "Terjadi kesalahan: $error", "ok", context);
    });
  }

  Widget isiDialogLoginBerhasil(String isi, String ok, BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 1000,
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textIsiLeft(isi),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Navigating to Dashboard...");
                      moveDashboard(context);
                    },
                    child:
                        Text(ok.toUpperCase(), style: TextStyle(fontSize: 20)),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
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
            )));
  }

  dialog1BtnLogin(String isi, String ok, BuildContext context) async {
    await Future.delayed(Duration(microseconds: 0));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return isiDialogLoginBerhasil(isi, ok, context);
        });
  }
}
