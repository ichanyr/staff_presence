import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/CutiModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/IzinModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/TambahCutiPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DetailCutiPage.dart';

class CutiController extends GetxController with StateMixin<CutiModel> {
  Rx<int> izinPertahun = 0.obs;
  Rx<CutiModel> cutiData = CutiModel(
      status: false,
      message: '',
      jatahCuti: [],
      sum: Sum(sakit: '0', izin: '0', alpha: '0', cuti: '0'),
      izin: []).obs;
  Rx<String> idstaf = ''.obs;
  late SharedPreferences sp;
  Set<int> setTahun = {};
  Rx<int> tahunPilih = DateTime.now().year.obs;
  RxList<String> bodyIzin = <String>[].obs;
  RxList<String> bodyProses = <String>[].obs;
  Rx<String> cutiPilih = ''.obs;

  Rx<ListIzin> listIzin = new ListIzin([
    IzinModel('all', 'Semua', true),
    IzinModel('s', 'Sakit', false),
    IzinModel('i', 'Izin', false),
    IzinModel('a', 'Alpha', false),
    IzinModel('c', 'Cuti', false)
  ]).obs;
  Rx<ListIzin> listProses = new ListIzin([
    IzinModel('all', 'Semua', true),
    IzinModel('p', 'Proses', false),
    IzinModel('a', 'Diterima', false),
    IzinModel('r', 'Ditolak', false)
  ]).obs;

  loadSP() async {
    sp = await SharedPreferences.getInstance();
    idstaf.value = (await sp.getString('iduser'))!;
    getCuti();
  }

  @override
  void onInit() {
    super.onInit();
    loadSP();
    listingTahun();
  }

  getCuti() async {
    cutiData.value = await ApiService().getCuti(
        id: idstaf.value,
        izin: bodyIzin,
        proses: bodyProses,
        tahun: tahunPilih.value);
    change(cutiData.value, status: RxStatus.loading());

    if (cutiData.value.status == true) {
      if (cutiData.value.izin.length == 0) {
        change(cutiData.value, status: RxStatus.empty());
      } else {
        change(cutiData.value, status: RxStatus.success());
      }
    } else {
      change(cutiData.value, status: RxStatus.error());
    }
  }

  int cekGridCount({required double lebar}) {
    int gridcount = 1;
    if (lebar <= 750) {
      gridcount = 1;
    } else {
      gridcount = 2;
    }
    return gridcount;
  }

  listingTahun() {
    for (int i = 0; i < 12; i++) {
      setTahun.add(tahunPilih.value - i);
    }
  }

  filterChipIzinClicked(IzinModel e) {
    e.isSelected = !e.isSelected;
    if (e.key == 'all' && e.isSelected == true) {
      listIzin.value.listIzinModel.forEach((element) {
        element.isSelected = false;
      });
      e.isSelected = true;
    }
    if (e.key != 'all' && e.isSelected == true) {
      listIzin.value.listIzinModel.forEach((element) {
        if (element.key == 'all') {
          element.isSelected = false;
        }
      });
    }
  }

  filterChipProsesClicked(IzinModel e) {
    e.isSelected = !e.isSelected;
    if (e.key == 'all' && e.isSelected == true) {
      listProses.value.listIzinModel.forEach((element) {
        element.isSelected = false;
      });
      e.isSelected = true;
    }
    if (e.key != 'all' && e.isSelected == true) {
      listProses.value.listIzinModel.forEach((element) {
        if (element.key == 'all') {
          element.isSelected = false;
        }
      });
    }
  }

  fnBtnTerapkan() {
    listIzin.value.listIzinModel.forEach((e) {
      e.isSelected == true ? bodyIzin.add(e.key) : null;
    });
    listProses.value.listIzinModel.forEach((e) {
      e.isSelected == true ? bodyProses.add(e.key) : null;
    });

    getCuti();
    Get.back();
    bodyIzin.clear();
    bodyProses.clear();
  }

  fnBtnUlang() {
    Get.back();
    tahunPilih.value = DateTime.now().year;
    bodyIzin.clear();
    bodyProses.clear();
    listIzin.value.listIzinModel.forEach((e) {
      if (e.key == 'all') {
        e.isSelected = true;
      } else {
        e.isSelected = false;
      }
    });
    listProses.value.listIzinModel.forEach((e) {
      if (e.key == 'all') {
        e.isSelected = true;
      } else {
        e.isSelected = false;
      }
    });
    getCuti();
  }

  fnTambahCuti() {
    Get.to(() => TambahCutiPage(
          dari: DateTime.now(),
          sampai: DateTime.now(),
          ket: '',
          izin: '',
          id: '',
        ));
  }

  fnPindahDetailPage({required String id}) {
    Get.to(() => DetailCutiPage(id: id));
  }
}
