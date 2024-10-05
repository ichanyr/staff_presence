import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/UI/Presensi/model/Presensi.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../assets/ukuran.dart';
import '../../Dashboard/dashboard.dart';
import '../../Element/button.dart';
import '../../Element/dialogBox.dart';
import '../../Riwayat/riwayat.dart';

class PresensiQrController extends GetxController {
  Rx<LatLng> latLong = LatLng(0, 0).obs;
  Rx<Position> posisi = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    altitudeAccuracy: 1,
    heading: 1,
    headingAccuracy: 1,
    speed: 1,
    speedAccuracy: 1,
  ).obs;

  String? iduser, barcode, udid;
  String? errorQr, lat, long;

  @override
  void onInit() async {
    super.onInit();
    await loadUserData();
    await determinePosition();
    await cekHid();
  }

  Future<void> loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    iduser = sp.getString('iduser') ?? '';
    barcode = sp.getString("barcode");
  }

  Future<void> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    posisi.value = await Geolocator.getCurrentPosition();
    latLong.value = LatLng(posisi.value.latitude, posisi.value.longitude);
    lat = posisi.value.latitude.toString();
    long = posisi.value.longitude.toString();
  }

  Future<void> presensiQR() async {
    try {
      ScanResult barcodes2 = await BarcodeScanner.scan();
      barcode = barcodes2.rawContent;
      await pushPresensiQr(barcode!, lat!, long!);
    } on PlatformException catch (error) {
      errorQr = error.code == BarcodeScanner.cameraAccessDenied
          ? 'Izin kamera tidak diizinkan oleh pengguna'
          : 'Error: $error';
    } on Exception catch (e) {
      errorQr = 'Error: $e';
    }
  }

  // Future<void> pushPresensiQr(String qrcode, String lat, String long) async {
  //   bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (isLocationEnabled) {
  //     PresensiQr futurePostPresensiQr = await ApiService().postPresensiQr(
  //       idUser: iduser!,
  //       lat: lat,
  //       long: long,
  //       qrcode: qrcode,
  //     );

  //     if (futurePostPresensiQr.status == true) {
  //       handleSuccessfulAttendance(futurePostPresensiQr);
  //     } else {
  //       handleFailedAttendance(futurePostPresensiQr.message!);
  //     }
  //   } else {
  //     handleGPSDisabled();
  //   }
  // }

  void handleSuccessfulAttendance(PresensiQr futurePostPresensiQr) {
    if (futurePostPresensiQr.statusLembur == true) {
      // Navigate to overtime request page
    } else {
      // Show success dialog
    }
  }

  void handleFailedAttendance(String message) {
    // Show failure dialog with message
  }

  void handleGPSDisabled() {
    // Show dialog for GPS being disabled
  }

  Future<void> cekHid() async {
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
  }

  pushPresensiQr(String qrcode, String lat, String long) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      PresensiQr futurePostPresensiQr = await ApiService().postPresensiQr(
          idUser: iduser!, lat: lat, long: long, qrcode: qrcode);

      if (futurePostPresensiQr.status == true) {
        await getDialog(
            body: Column(
              children: [
                TextFormatting(
                    overflow: TextOverflow.visible,
                    text: '${futurePostPresensiQr.message}.'),
                SizedBox(height: marginDidalamContent),
                ElevatedBtn(
                    isi: 'Ok',
                    isPadding: true,
                    isMargin: false,
                    tekan: () {
                      Get.offAll(() => DashboardPage());
                      Get.to(() => RiwayatPages());
                    }),
              ],
            ),
            title: 'Presensi Berhasil');
      } else {
        await getDialog(
            body: Column(
              children: [
                TextFormatting(
                    overflow: TextOverflow.visible,
                    text: futurePostPresensiQr.message!),
                SizedBox(height: marginDidalamContent),
                ElevatedBtn(
                  isi: 'Ok',
                  isPadding: true,
                  isMargin: false,
                  tekan: () {
                    Get.back();
                  },
                ),
              ],
            ),
            title: 'Error');
      }
    } else {
      await getDialog(
          body: Column(
            children: [
              TextFormatting(
                  overflow: TextOverflow.visible,
                  text:
                      'Layanan lokasi dinonaktifkan, aktifkan terlebih dahulu.'),
              SizedBox(height: marginDidalamContent),
              ElevatedBtn(
                isi: 'Ok',
                isPadding: true,
                isMargin: false,
                tekan: () {
                  Get.back();
                },
              ),
            ],
          ),
          title: 'Error');
    }
  }
}
