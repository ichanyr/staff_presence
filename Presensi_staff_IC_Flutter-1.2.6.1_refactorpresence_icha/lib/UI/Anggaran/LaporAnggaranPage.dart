import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/Laporan/HapusLaporanController.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/Laporan/LapAnggaranCtrl.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Controller/Laporan/TambahLaporan.dart';
import 'package:presensi_ic_staff/UI/Anggaran/DetailAnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/GetLaporanModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Element/Gif.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Element/helper.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/pack.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaporAnggaranPage extends StatefulWidget {
  final int idAnggaran;
  final String judul;
  final String status;

  const LaporAnggaranPage(
      {Key? key,
      required this.idAnggaran,
      required this.judul,
      required this.status})
      : super(key: key);

  @override
  State<LaporAnggaranPage> createState() => _LaporAnggaranPageState();
}

class _LaporAnggaranPageState extends State<LaporAnggaranPage> {
  final ImagePicker _picker = ImagePicker();
  late XFile xFile;
  DateTime tanggal = DateTime.now();
  late DateTime tanggalDipilih;
  List<bool> lIsKlik = [];
  late File file;
  late String judul;

  // list
  int idAnggaran = 0;
  int widgetCount = 0;
  List lwLaporan = [];
  List<int> lId = [];
  List<XFile> lXFile = [];
  List<DateTime> lTanggal = [];
  List<TextEditingController> lJudulCtrl = [],
      lUangCtrl = [],
      lCatatanCtrl = [];

  // controller
  LapAnggaranCtrl lapCtrl = Get.put(LapAnggaranCtrl());
  HapusLaporanAnggaranController hapusLapCtrl =
      Get.put(HapusLaporanAnggaranController());

  // controller simpan laporan
  TambahLaporanController tambahLaporanCtrl =
      Get.put(TambahLaporanController());

  // data untuk shared preference
  late SharedPreferences sp;
  late String idstaf;

  bool isCanEdit = false;
  String status = "pending";

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      idstaf = (sp.getString('iduser') ?? '');
      hapusLapCtrl.idstaf.value = idstaf;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // load from widget
    judul = widget.judul;
    status = widget.status;

    //load shared preference
    loadSP();

    // load ctrl
    idAnggaran = widget.idAnggaran;
    lapCtrl.id.value = idAnggaran.toString();
    Future fLaporan = lapCtrl.getAnggaran();
    fLaporan.then((value) {
      tambahWidgetCtrl(lapCtrl.lapAnggaranData.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    isCanEdit = isDataLaporanCanEdit(status);

    return Scaffold(
      appBar: AppBar(
        title: textIsi2(
            isi: "Pelaporan $judul", warna: warnaHitam, fw: FontWeight.bold),
        backgroundColor: warnaPutih,
        foregroundColor: warnaHitam,
        iconTheme: IconThemeData(color: warnaHitam),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: isiPage(),
      ),
      bottomSheet: Visibility(
        visible: isCanEdit,
        child: ElevatedBtn(
          tekan: () => simpanLaporan(),
          isi: "Simpan",
        ),
      ),
    );
  }

  // isi page
  Widget isiPage() {
    return Container(
      // padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 100),
      child: Column(
        children: <Widget>[
          //top bar uang
          lapCtrl.obx((s) {
            return TopBarAnggaran(
                anggaran: lapCtrl.lapAnggaranData.value.uang[0].anggaran,
                dibelanjakan:
                    lapCtrl.lapAnggaranData.value.uang[0].dibelanjakan);
          },
              onEmpty: TopBarAnggaran(anggaran: "0", dibelanjakan: '0'),
              onError: (e) => TopBarAnggaran(anggaran: "0", dibelanjakan: '0')),

          // separator
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: 5,
            color: warnaPutihAbu3,
          ),

          // list laporan + btn tambah
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                // list view
                lapCtrl.obx((state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lwLaporan.length,
                    itemBuilder: (BuildContext context, int index) {
                      int idLap = 0;
                      index >= lapCtrl.lapAnggaranData.value.data.length
                          ? idLap = 0
                          : idLap = int.parse(
                              lapCtrl.lapAnggaranData.value.data[index].id);

                      return CardLaporan(
                        isLihat: lIsKlik[index],
                        tanggal: lTanggal[index],
                        judulCtrl: lJudulCtrl[index],
                        uangCtrl: lUangCtrl[index],
                        catatanCtrl: lCatatanCtrl[index],
                        fnGaleri: () => ambilBerkas(index),
                        fnKamera: () => ambilGambar(index),
                        fnHapus: () =>
                            dialogHapusWidget(lapId: idLap, widgetId: index),
                        xFile: lXFile[index],
                        fnImage: () => clickImage(index),
                        fnTanggal: () => showDTPicker(index),
                        fnHapusImg: () => deleteFile(index),
                        iscanEdit: isCanEdit,
                      );
                    },
                  );
                },
                    onLoading: LoadingIc(),
                    onError: (e) => TextIsi2(
                          isi: "error : $e",
                        ),
                    onEmpty: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lwLaporan.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardLaporan(
                          isLihat: lIsKlik[index],
                          tanggal: lTanggal[index],
                          judulCtrl: lJudulCtrl[index],
                          uangCtrl: lUangCtrl[index],
                          catatanCtrl: lCatatanCtrl[index],
                          fnGaleri: () => ambilBerkas(index),
                          fnKamera: () => ambilGambar(index),
                          fnHapus: () =>
                              dialogHapusWidget(widgetId: index, lapId: 0),
                          xFile: lXFile[index],
                          fnImage: () => clickImage(index),
                          fnTanggal: () => showDTPicker(index),
                          fnHapusImg: () => deleteFile(index),
                          iscanEdit: false,
                        );
                      },
                    )),

                // tambah list
                Visibility(
                  visible: isCanEdit,
                  child: ElevatedBtn(
                    tekan: () {
                      tambahWidget(
                          id: 0,
                          judul: '',
                          catatan: '',
                          image: '',
                          uang: '',
                          waktu: DateTime.now());
                    },
                    isi: "Tambah",
                    // isPadding: false,
                    warnaTeks: warnaPrimer,
                    warnaBtn: warnaPutih,
                    enabled: isCanEdit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ambilGambar(int index) async {
    // init value
    Directory tempDir = await getTemporaryDirectory();
    String directory = tempDir.path;
    XFile xFileKompress;

    // Xfile
    lXFile[index] = (await _picker.pickImage(source: ImageSource.camera))!;
    File fileFromXfile = File(lXFile[index].path);
    String fileTemp = directory +
        "/" +
        idstaf +
        "_" +
        DateTime.now().toString() +
        "_Temp.jpg";

    // proses kompres
    String pathFileKompres = await kompresGambar(fileFromXfile, fileTemp);
    xFileKompress = new XFile(pathFileKompres);
    lXFile[index] = xFileKompress;

    setState(() {});
  }

  ambilBerkas(int index) async {
    // init value
    Directory tempDir = await getTemporaryDirectory();
    String directory = tempDir.path;
    XFile xFileKompress;

    lXFile[index] = (await _picker.pickImage(source: ImageSource.gallery))!;
    File fileFromXfile = File(lXFile[index].path);
    String fileTemp = directory +
        "/" +
        idstaf +
        "_" +
        DateTime.now().toString() +
        "_Temp.jpg";

    // proses kompres
    String pathFileKompres = await kompresGambar(fileFromXfile, fileTemp);
    xFileKompress = new XFile(pathFileKompres);
    lXFile[index] = xFileKompress;

    setState(() {});
  }

  tambahWidget(
      {required int id,
      required DateTime waktu,
      required String judul,
      required String catatan,
      required String uang,
      required String image}) async {
    // init controller
    TextEditingController judultxtCtrl = TextEditingController();
    TextEditingController uangtxtCtrl = TextEditingController();
    TextEditingController catatantxtCtrl = TextEditingController();

    DateTime tgl;
    Directory tempDir = await getTemporaryDirectory();
    String directory = tempDir.path;
    String pathFile;

    String fDownload = await downloadFile(image, directory);
    pathFile = fDownload;

    // cek download gagal
    pathFile.contains("Error code: ") ||
            pathFile.contains("Can not fetch url : ")
        ? xFile = xFile
        : xFile = new XFile(pathFile);

    tgl = waktu;
    judul == ""
        ? judultxtCtrl = TextEditingController()
        : judultxtCtrl.text = judul;
    uang == ""
        ? uangtxtCtrl = TextEditingController()
        : uangtxtCtrl.text = uang;
    catatan == ""
        ? catatantxtCtrl = TextEditingController()
        : catatantxtCtrl.text = catatan;

    // untuk widget kosongan/ data lokal
    if (judul == "") {
      lwLaporan.add(lwLaporan.length + 1);
      lId.add(id);
      lTanggal.add(tgl);
      lJudulCtrl.add(judultxtCtrl);
      lUangCtrl.add(uangtxtCtrl);
      lCatatanCtrl.add(catatantxtCtrl);
      lXFile.add(XFile(''));
      lIsKlik.add(false);
      setState(() {});
    }

    // untuk load data dari DB
    else {
      lwLaporan.add(lwLaporan.length + 1);
      lId.add(id);
      lTanggal.add(tgl);
      lJudulCtrl.add(judultxtCtrl);
      lUangCtrl.add(uangtxtCtrl);
      lCatatanCtrl.add(catatantxtCtrl);
      lXFile.add(xFile);
      lIsKlik.add(false);
      setState(() {});
    }
  }

  // hapus list widget pelaporan
  hapusWidget(int index) {

    lTanggal.removeAt(index);
    lJudulCtrl.removeAt(index);
    lUangCtrl.removeAt(index);
    lwLaporan.removeAt(index);
    lXFile.removeAt(index);
    lIsKlik.removeAt(index);

    setState(() {});
  }

  // fungsi untuk button simpan
  simpanLaporan() async {
    if (lwLaporan.length > 0) {
      String nominalTemp = "";

      tambahLaporanCtrl.idstaf.value = idstaf;
      tambahLaporanCtrl.idReq.value = idAnggaran;

      for (int i = 0; i < lwLaporan.length; i++) {
        nominalTemp = lUangCtrl[i].text;
        nominalTemp = nominalTemp.replaceAll(new RegExp(r'[^0-9]'), '');
        nominalTemp == '' || nominalTemp == null
            ? nominalTemp = "0"
            : nominalTemp = nominalTemp;

        bool cekItem =
            cekTxtCtrlBerisi(teksCtrl: lJudulCtrl[i], namaCtrl: "Item");
        bool cekPengeluaran =
            cekTxtCtrlBerisi(teksCtrl: lUangCtrl[i], namaCtrl: "Pengeluaran");
        bool cekFoto = cekFotorCtrlBerisi(xFile: lXFile[i], namaCtrl: "Foto");

        // cek untuk ctrl kosong atau tidak
        if (cekItem == true) {
          tambahLaporanCtrl.item.value = lJudulCtrl[i].text;
        }
        if (cekPengeluaran == true) {
          tambahLaporanCtrl.nominal.value = int.parse(nominalTemp);
        }
        tambahLaporanCtrl.catatan.value = lCatatanCtrl[i].text ?? "";
        if (cekFoto == true) {
          tambahLaporanCtrl.xfile.value = lXFile[i].path;
        }

        tambahLaporanCtrl.waktu.value = lTanggal[i];
        tambahLaporanCtrl.id.value = lId[i];

        if (cekItem == true && cekPengeluaran == true && cekFoto == true) {
          // TambahAnggaranModel ctrlTambahLap =
          //     await tambahLaporanCtrl.postAnggaran();
          if (tambahLaporanCtrl.responseTambahLaporan.value.status == false) {
            Get.snackbar(
                "Gagal", tambahLaporanCtrl.responseTambahLaporan.value.message,
                backgroundColor: warnaMerah, colorText: warnaPutih);
          } else {
            Get.to(() =>
                DetailAnggaranPage(tipePage: 1, id: idAnggaran.toString()));
            Get.snackbar("Berhasil",
                tambahLaporanCtrl.responseTambahLaporan.value.message,
                backgroundColor: warnaPrimer, colorText: warnaPutih);
          }
        }
      }
    }
  }

  // cek teks kosong atau ada isinya
  bool cekTxtCtrlBerisi({required TextEditingController teksCtrl, required String namaCtrl}) {
    if ( teksCtrl.text == "") {
      Get.snackbar("Input Kosong", "$namaCtrl tidak boleh kosong!",
          backgroundColor: warnaMerah);
      return false;
    } else {
      return true;
    }
  }

  // cek untuk isi kontroller
  bool cekFotorCtrlBerisi({required XFile xFile, required String namaCtrl}) {
    if ( xFile.path == '') {
      Get.snackbar("Input Kosong", "Foto tidak boleh kosong!",
          backgroundColor: warnaMerah);
      return false;
    } else {
      return true;
    }
  }

// menampilkan datetime picker
  DateTime showDTPicker(int index) {

    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(initialDate.year - 1);
    DateTime lastDate = initialDate;
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate)
        .then((value) {
      setState(() {
        lTanggal[index] = value!;
      });
    });

    return lTanggal[index];
  }

// ketika gambar diklik
  clickImage(int index) {
    setState(() {
      lIsKlik[index] = !lIsKlik[index];
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          lIsKlik[index] = false;
        });
      });
    });
  }

// hapus file gambar
  Future<int> deleteFile(int index) async {
    file = File(lXFile[index].path);
    try {
      await file.delete();
      setState(() {
        xFile = XFile('');
        lXFile[index] = xFile;
      });
    } catch (e) {
      return 0;
    }

    return 0;
  }

// tambah widget menggunakan data dari api
  tambahWidgetCtrl(LaporanAnggaran lap) {
    lap.data.forEach((e) {
      tambahWidget(
          id: int.parse(e.id),
          uang: e.nominal,
          waktu: e.waktu,
          judul: e.item,
          catatan: e.catatan,
          image: e.bukti);
    });
  }

// dialog box untuk menghapus widget
  dialogHapusWidget({required int widgetId, required int lapId}) {

    //hapus widget dengan data dari DB
    if (lapId != 0 && widgetId != '' && lapId != '') {
      dialogBox(
          judul: "Hapus Laporan",
          isi: "Apakah anda yakin untuk menghapus laporan ?",
          btn1: "Ya, Hapus",
          fnBtn1: () {
            Navigator.pop(context);
            hapusLapCtrl.id.value = lapId.toString();
            Future<void> fHapus = hapusLapCtrl.hapusLaporan();
            fHapus.then((value) {
              hapusWidget(widgetId);
              tampilPesanHapus(
                  isBerhasil: hapusLapCtrl.laporanData.value.status,
                  pesan: hapusLapCtrl.laporanData.value.message);
            });
          },
          warnaBtn1: warnaMerah,
          warnaTeksBtn1: warnaPutih,
          btn2: "Tidak, Edit lagi",
          fnBtn2: () => Navigator.pop(context),
          warnaBtn2: warnaPutih,
          warnaTeksBtn2: warnaPrimer,
          context: context);
    }
    // hapus widget data lokal
    else if ((widgetId != '' && lapId == '') ||
        (widgetId != '' && lapId == 0)) {
      dialogBox(
          judul: "Hapus Laporan",
          isi: "Apakah anda yakin untuk menghapus laporan ?",
          btn1: "Ya, Hapus",
          fnBtn1: () {
            hapusWidget(widgetId);
            Navigator.pop(context);
          },
          warnaBtn1: warnaMerah,
          warnaTeksBtn1: warnaPutih,
          btn2: "Tidak, Edit lagi",
          fnBtn2: () => print("btn2"),
          warnaBtn2: warnaPutih,
          warnaTeksBtn2: warnaPrimer,
          context: context);
    }
  }

  // tampilkan dialog box untuk hapus
  tampilPesanHapus({required bool isBerhasil, required String  pesan}) {
    String judul, isi;
    isBerhasil == true ? judul = "Berhasil Hapus" : judul = "Gagal Hapus";
    isBerhasil == true
        ? isi = "Berhasil Hapus Laporan"
        : isi = "Gagal Hapus Laporan";

    dialogBox(
        context: context,
        judul: judul,
        isi: isi,
        btn1: "Oke",
        warnaBtn1: warnaPrimer,
        warnaTeksBtn1: warnaPutih,
        fnBtn1: () {
          Navigator.pop(context);
          lapCtrl.getAnggaran();
          // setState(() {});
          // Get.replace(()=>LaporAnggaranPage(idLaporan: idLaporan));
          // Get.to((LaporAnggaranPage(idLaporan: idLaporan)));
        });
  }
}
