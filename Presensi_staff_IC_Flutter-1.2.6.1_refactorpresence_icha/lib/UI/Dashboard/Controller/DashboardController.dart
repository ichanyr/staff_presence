import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Anggaran/AnggaranPage.dart';
import 'package:presensi_ic_staff/UI/Cuti/CutiPage.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/dialogBox.dart';
import 'package:presensi_ic_staff/UI/Lembur/LemburPage.dart';
import 'package:presensi_ic_staff/UI/Presensi/PresensiQr.dart';
import 'package:presensi_ic_staff/UI/Profil/akun.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';
import 'package:presensi_ic_staff/UI/Riwayat/riwayat.dart';
import '../../Element/Model/ButtonModel.dart';
import '../../Element/Warna.dart';
import '../../Element/button.dart';
import '../../Element/helper.dart';
import '../Model/ResponseSetToken.dart';

class DashboardController extends GetxController
    with StateMixin<DashboardModel> {
  DashboardModel fdash = DashboardModel(
      status: false,
      message: Message(
          id: '0',
          poin: '0',
          lastTglMasuk: '',
          lastJamMasuk: '',
          lastJamKeluar: ''));
  late SharedPref sp = SharedPref();

  /// data
  Rx<String> idstaf = ''.obs;
  Rx<bool> isMockedLocation = false.obs;
  Rx<ProfilModel> profil =
      ProfilModel(status: false, dataProfil: DataProfil(name: '')).obs;
  Rx<PackageInfo> packageInfo =
      PackageInfo(appName: '', packageName: '', version: '', buildNumber: '')
          .obs;
  Rx<bool> versiVisibility = false.obs;
  RxString noVersi = '0'.obs;

  /// state
  RxStatus statusState = RxStatus.loading();

  @override
  Future<void> onInit() async {
    super.onInit();

    change(fdash, status: statusState);

    /// get versi
    packageInfo.value = await PackageInfo.fromPlatform();

    await sp.onInit();
    idstaf.value = sp.getIdstaf();

    /// get poin
    await getPoin();

    /// set firebase
    setIdFirebase();

    /// cek login
    cekToLogin(idstaf.value, Get.context!);

    /// set lokasi
    await determinePosition();

    /// get profil
    await getProfil();

    await fnGetAndSendToken();

    await getPackageInfo();
  }

  Future<void> getPoin() async {
    if (idstaf.value != '') {
      fdash = await ApiService().getPoin(idstaf.value);

      /// berhasil connect
      if (fdash.status == true) {
        /// sukses
        if (fdash.message.id != '') {
          statusState = RxStatus.success();
        }

        /// berhasil connect
        else {
          /// berhasil connect
          statusState = RxStatus.empty();
        }
      }

      /// gagal
      else {
        statusState = RxStatus.error(
            'Terjadi kesalahan dalam menghubungi server!\nCoba lagi nanti!');
      }

      change(fdash, status: statusState);
    }
  }

  void setIdFirebase() {
    /// set id user hanya jika menggunakan mobile device
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseCrashlytics.instance.setUserIdentifier(idstaf.value);
    }
  }

  void cekLogin() {}

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    late Position posisi;

    /// cek apakah pakai Mobile Device
    if (Platform.isAndroid || Platform.isIOS) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      posisi = await Geolocator.getCurrentPosition();

      sp.setLat(posisi.latitude.toString());
      sp.setLong(posisi.longitude.toString());

      if (posisi.isMocked == true) {
        isMockedLocation.value = true;
      }
    }
  }

  Future<void> getProfil() async {
    profil.value = await ApiService().getProfil(idstaf.value);
  }

  Future<void> fnGetAndSendToken() async {
    String? tokenFcm = '';
    String deviceId = '';

    if (Platform.isIOS || Platform.isAndroid) {
      tokenFcm = await FirebaseMessaging.instance.getToken();
      deviceId = await _getIdDevice();

      /// set token fcm
      ResponseSetTokenFcm setTokenFcm = await ApiService().setTokenFcm(
          idstaf: idstaf.value, device: deviceId, token: tokenFcm!);
      setTokenFcm;
    }
  }

  /// get device info
  Future<String> _getIdDevice() async {
    // DeviceInfoPlugin deviceInfos = DeviceInfoPlugin();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model + androidDeviceInfo.brand;
    } else {
      return 'Not mobile device type';
    }
  }

  Future<void> getPackageInfo() async {
    /// init app version
    packageInfo.value = await PackageInfo.fromPlatform();

    if (packageInfo.value ==
        PackageInfo(
            appName: '', packageName: '', version: '', buildNumber: '')) {
      versiVisibility.value = true;
    }
  }

  /// btn qr
  Future<void> fnBtnQr() async {
    /// cek mock location
    if (isMockedLocation.isTrue) {
      await dialogMockLocation();
    }

    /// tidak mock location
    else {
      if (Platform.isAndroid || Platform.isIOS) {
        Get.to(() => PresensiQRPage());
      } else {
        await dialogPlatformTidakDidukung();
      }
    }
  }

  /// btn riwayat
  void fnBtnRiwayat() {
    Get.to(() => RiwayatPages());
  }

  /// btn anggaran
  void fnBtnAnggaran() {
    Get.to(() => AnggaranPage());
  }

  /// btn Cuti
  void fnBtnCuti() {
    Get.to(() => CutiPage());
  }

  void fnBtnAkun() {
    Get.to(() => AkunPage());
  }

  void fnBtnLembur() {
    Get.to(() => LemburPage());
  }

  /// dialog mocked location
  Future<void> dialogMockLocation() async {
    await getDialog(
        body: ElevatedBtn(
          isi: 'OK',
          tekan: () => Get.back(),
          warnaBtn: warnaPrimer,
          warnaTeks: warnaPutih,
          isPadding: true,
          enabled: true,
          isMargin: false,
          bentuk: BentukBtnModel(BentukBtnModels.round),
        ),
        title: 'Device anda menggunakan FAKE GPS !'
            'Aplikasi tidak bisa digunakan untuk presensi!');
  }

  Future<void> dialogPlatformTidakDidukung() async {
    await dialogBox(
        context: Get.context!,
        isi:
            'Platform yang didukung untuk  presensi sementara adalah Android dan IOS!',
        judul: 'Platform tidak didukung!',
        btn1: 'Oke',
        fnBtn1: () => Get.back(),
        warnaBtn1: warnaPrimer,
        warnaTeksBtn1: warnaPutih);
  }
}
