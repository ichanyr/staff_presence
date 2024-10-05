// Using the Camera package

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// import 'package:image_utils_class/image_utils_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/imgVector.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Lembur/LemburPage.dart';
import 'package:presensi_ic_staff/UI/Lembur/TambahLembur.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'dart:io' as Io;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/ukuran.dart';
import '../Dashboard/dashboard.dart';
import 'model/Presensi.dart';

const List<String> listAlasan = <String>[
  'Tugas diluar',
  'QR Bermasalah',
  'Ponsel Rusak',
  'Lainnya'
];

class PresensiAlternatif extends StatefulWidget {
  const PresensiAlternatif({Key? key}) : super(key: key);

  @override
  State<PresensiAlternatif> createState() => _PresensiAlternatifState();
}

class _PresensiAlternatifState extends State<PresensiAlternatif> {
  late CameraController controller0;
  int selectedCamera = 1;
  late XFile imagePath;
  late SharedPreferences sp;
  late String iduser, lat, long;
  late List<CameraDescription> cameras;

  /// wait camera to load
  late Future loadCam;

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      iduser = (sp.getString('iduser') ?? '');
      lat = (sp.getString('lat') ?? '');
      long = (sp.getString('long') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    Future loadPage = loadSP();
    loadPage.then((value) {
      cekToLogin(iduser, context);
    });
    loadCam = waitCam();
  }

  Future<void> waitCam() async {
    await callCamera();
    controller0 = await CameraController(cameras[1], ResolutionPreset.medium);
    controller0.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) async {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            await getDialog(
                body: ElevatedBtn(
                  isi: 'Ok',
                  tekan: () {
                    Get.offAll(DashboardPage());
                  },
                ),
                title: 'Ande belum mengizinkan akses kamera!'
                    '\nSilahkan ubah perizinan camera di pengaturan.');
            break;
          default:
            // Handle other errors here.
            await getDialog(
                body: ElevatedBtn(
                  isi: 'Ok',
                  tekan: () {
                    Get.offAll(DashboardPage());
                  },
                ),
                title: 'Terjadi error : ${e.description}');
            break;
        }
      }
    });
    setState(() {});
  }

  Future<List<CameraDescription>> callCamera() async {
    cameras = await availableCameras();
    // cameras = availableCameras() as List<CameraDescription>;
    return cameras;
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(360 / 360),
      child: Scaffold(
        appBar: AppBar(
          title: textIsi("Presensi Alternatif"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.maxFinite,
          child: FutureBuilder(
            future: loadCam,
            builder: (context, snapshot) {
              /// cek jika load cam berhasil
              ConnectionState conState = snapshot.connectionState;
              if (conState == ConnectionState.done) {
                return CameraPreview(controller0);
              } else if (snapshot.hasError) {
                return TextFormatting(text: 'terjadi error');
              } else {
                return Column(
                  children: [
                    TextFormatting(text: 'Loading Camera!'),
                    SizedBox(height: marginDidalamContent),
                    CircularProgressIndicator()
                  ],
                );
              }
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            margin:
                const EdgeInsets.only(right: 50, left: 50, top: 0, bottom: 20),
            child: btnFoto(),
          ),
        ),
      ),
    );
  }

  Widget btnFoto() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          onCaptureButtonPressed();
        },
        child: Text("Foto".toUpperCase(), style: TextStyle(fontSize: 20)),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  void onCaptureButtonPressed() async {
    // //on camera button press
    // try {
    String file;
    if (Platform.isAndroid) {
      file = (await getExternalStorageDirectory())!.path;
    } else {
      file = (await getApplicationDocumentsDirectory()).path;
    }

    await controller0.takePicture().then((file) async {
      if (mounted) {
        setState(() {
          imagePath = file;
        });
        if (file != null)
          await Navigator.of(context).push(
            MaterialPageRoute(
                // builder: (context) => DisplayPictureScreen(
                //   // Pass the automatically generated path to
                //   // the DisplayPictureScreen widget.
                //   xfile: file,
                //   imagePath: file.path,
                //   idstaff: iduser,
                //   lat: lat,
                //   long: long,
                // ),
                builder: (context) => TampilkanHasil(
                    imagePath: file.path,
                    xfile: file,
                    idstaff: iduser,
                    lat: lat,
                    long: long)),
          );
      }
    });
  }

  @override
  void dispose() {
    controller0.dispose();
    super.dispose();
  }
}

class TampilkanHasil extends StatefulWidget {
  TampilkanHasil(
      {Key? key,
      required this.imagePath,
      required this.xfile,
      required this.idstaff,
      required this.lat,
      required this.long})
      : super(key: key);

  final String imagePath;
  final XFile xfile;
  final String idstaff;
  final String lat;
  final String long;

  @override
  State<TampilkanHasil> createState() => _TampilkanHasilState();
}

class _TampilkanHasilState extends State<TampilkanHasil> {
  late String imagePath;
  late XFile xfile;
  late String idstaff;
  late String lat;
  late String long;

  String dropdownValue = listAlasan.first;

  @override
  Widget build(BuildContext context) {
    imagePath = widget.imagePath;
    xfile = widget.xfile;
    idstaff = widget.idstaff;
    lat = widget.lat;
    long = widget.long;

    String imgEncode = imgToBase64(File(xfile.path));
    var textCtrl = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: textIsi("Presensi Alternatif"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              /// gambar
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.file(File(imagePath)),
                ),
              ),

              /// alasan
              Container(
                  child: dropdownKet(),
                  margin: EdgeInsets.only(top: 20, bottom: 20)),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 200,
                controller: textCtrl,
                decoration: InputDecoration(
                    hintText: 'Masukkan Keterangan Presensi',
                    labelText: 'Keterangan',
                    border: OutlineInputBorder()),
              ),

              /// btn aksi
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () => pushPresensiLuar(
                        imgEncode, idstaff, textCtrl.text, lat, long, context),
                    child: textIsiWhite("Simpan"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  width: double.infinity,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String imgToBase64(File file) {
    final bytes = Io.File(file.path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    return img64;
  }

  pushPresensiLuar(String img, String idStaf, String ket, String lat,
      String long, BuildContext context) async {
    /// cek gps
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    /// lokasi aktif
    if (isLocationEnabled == true) {
      await getDialogLoading();

      Future<PresensiQr> futurePostPresensiLuar = ApiService()
          .postPresensiLuar(img, idStaf, '$dropdownValue -- $ket', long, lat);
      futurePostPresensiLuar.then((value) async {
        /// presensi berhasil
        if (value.status == true) {
          /// presensi ada lembur
          if (value.statusLembur == true) {
            await getDialog(
                body: Column(
                  children: [
                    TextFormatting(text: value.message.toString(),
                      overflow: TextOverflow.visible,),
                    SizedBox(height: marginDidalamContent),

                    /// terdeteksi lembur
                    TextFormatting(
                      overflow: TextOverflow.visible,
                        text: 'Apakah anda ingin mengajukan lembur sekarang ?'),
                    SizedBox(height: marginDidalamContent),

                    /// btn ajukan sekarang
                    ElevatedBtn(
                        isi: 'Ya, ajukan sekarang',
                        isMargin: false,
                        isPadding: true,
                        tekan: () {
                          Get.offAll(() => DashboardPage());
                          Get.to(() => LemburPage());
                          Get.to(() => TambahLemburPage(
                                mulai: DateTime.now(),
                                selesai: DateTime.now(),
                              ));
                        }),
                    SizedBox(height: marginDidalamContent/2),

                    /// btn ajukan nanti
                    ElevatedBtn(
                        isi: 'Tidak, ajukan nanti',
                        isMargin: false,
                        isPadding: true,
                        warnaBtn: warnaPutih,
                        warnaTeks: warnaPrimer,
                        tekan: () {
                          Get.offAll(() => DashboardPage());
                          Get.to(() => RiwayatPages());
                        }),
                  ],
                ),
                title: 'Presensi berhasil!');
          }

          /// presensi berhasil
          else {
            await getDialog(
                body: Column(
                  children: [
                    TextFormatting(text: value.message.toString()),
                    SizedBox(height: marginDidalamContent),

                    /// btn
                    ElevatedBtn(
                        isi: 'Ok',
                        isMargin: false,
                        isPadding: true,
                        tekan: () {
                          Get.offAll(() => DashboardPage());
                          Get.to(() => RiwayatPages());
                        }),
                  ],
                ),
                title: 'Presensi berhasil!');
          }
          // dialog1BtnAction("Presensi Berhasil!", "ok", context);
        }

        /// Presensi gagal
        else {
          dialog1Btn(
              "Presensi gagal!",
              "Cek QR atau Koneksi Anda " + value.message.toString(),
              "ok",
              context);
        }
      });
    }

    /// lokasi tidak aktif
    else {
      dialogBoxWidget(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextIsi2(isi: "Presensi gagal!"),
            SizedBox(height: 20),
            TextIsi2(
              isi:
                  'Untuk melakukan presensi silahkan hidupkan GPS, kemudian lakukan presensi kembali',
              textOverflow: TextOverflow.visible,
            ),
            SizedBox(height: 30),
            Container(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => DashboardPage()),
                child: TextIsi2(
                  isi: 'Ok',
                  warna: Colors.white,
                  ukuran: 26,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget isiDlgBtnIsiAction(String judul, String ok, BuildContext context) {
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => Get.off(() => RiwayatPages()),
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

  dialog1BtnAction(String judul, String ok, BuildContext context) async {
    await Future.delayed(Duration(microseconds: 0));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return isiDlgBtnIsiAction(judul, ok, context);
        });
  }

  Widget dropdownKet() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: listAlasan.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
