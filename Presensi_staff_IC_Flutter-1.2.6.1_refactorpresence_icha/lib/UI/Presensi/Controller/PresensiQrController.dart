// import 'dart:async';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_udid/flutter_udid.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../model/Presensi.dart';

// enum CustomConnectivityResult {
//   wifi,
//   mobile,
//   none,
// }

// class CustomConnectivity {
//   // Simulate checking for connectivity status
//   Future<CustomConnectivityResult> checkConnectivity() async {
//     return CustomConnectivityResult.wifi; // Replace with actual implementation
//   }

//   // Simulate monitoring connectivity changes
//   Stream<CustomConnectivityResult> get onConnectivityChanged async* {
//     await Future.delayed(Duration(seconds: 1));
//     yield CustomConnectivityResult.mobile;

//     await Future.delayed(Duration(seconds: 1));
//     yield CustomConnectivityResult.none;

//     await Future.delayed(Duration(seconds: 1));
//     yield CustomConnectivityResult.wifi;
//   }
// }

// class PresensiQrController extends GetxController {
//   Rx<LatLng> latLong = LatLng(0, 0).obs;
//   Rx<Position> posisi = Position(
//     longitude: 0,
//     latitude: 0,
//     timestamp: DateTime.now(),
//     accuracy: 1,
//     altitude: 1,
//     altitudeAccuracy: 1,
//     heading: 1,
//     headingAccuracy: 1,
//     speed: 1,
//     speedAccuracy: 1,
//   ).obs;

//   String? iduser, barcode, udid;
//   String? errorQr, lat, long;
//   RxBool isOnline = false.obs;
//   Rx<DateTime?> offlinePresensiTime = Rx<DateTime?>(null);

//   late StreamSubscription<CustomConnectivityResult> _connectivitySubscription;
//   final CustomConnectivity _connectivity = CustomConnectivity();

//   @override
//   void onInit() async {
//     super.onInit();
//     await loadUserData();
//     await determinePosition();
//     await cekHid();
//     startMonitoringConnectivity();
//   }

//   @override
//   void onClose() {
//     _connectivitySubscription.cancel();
//     super.onClose();
//   }

//   void startMonitoringConnectivity() {
//     _connectivitySubscription = _connectivity.onConnectivityChanged
//         .listen((CustomConnectivityResult result) {
//       isOnline.value = result != CustomConnectivityResult.none;
//       if (isOnline.value) {
//         print("Connected to Internet");
//         sendPendingAttendanceData();
//       } else {
//         print("No Internet Connection");
//       }
//     });
//   }

//   Future<void> loadUserData() async {
//     final sp = await SharedPreferences.getInstance();
//     iduser = sp.getString('iduser') ?? '';
//   }

//   Future<void> determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }

//     posisi.value = await Geolocator.getCurrentPosition();
//     latLong.value = LatLng(posisi.value.latitude, posisi.value.longitude);
//     lat = posisi.value.latitude.toString();
//     long = posisi.value.longitude.toString();
//   }

//   Future<void> presensiQR() async {
//     try {
//       ScanResult barcodes2 = await BarcodeScanner.scan();
//       barcode = barcodes2.rawContent;
//       if (isOnline.value) {
//         await pushPresensiQr(barcode!, lat!, long!);
//       } else {
//         await saveOfflineAttendance(barcode!, lat!, long!);
//         showOfflineDialog();
//       }
//     } on PlatformException catch (error) {
//       errorQr = error.code == BarcodeScanner.cameraAccessDenied
//           ? 'Izin kamera tidak diizinkan oleh pengguna'
//           : 'Error: $error';
//     } on Exception catch (e) {
//       errorQr = 'Error: $e';
//     }
//   }

//   Future<void> cekHid() async {
//     try {
//       udid = await FlutterUdid.udid;
//     } on PlatformException {
//       udid = 'Failed to get UDID.';
//     }
//   }

//   Future<void> pushPresensiQr(String qrcode, String lat, String long) async {
//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//     if (isLocationEnabled) {
//       PresensiQr futurePostPresensiQr = await ApiService().postPresensiQr(
//         idUser: iduser!,
//         lat: lat,
//         long: long,
//         qrcode: qrcode,
//       );

//       if (futurePostPresensiQr.status == true) {
//         print('Presensi Berhasil: ${futurePostPresensiQr.message}');
//       } else {
//         print('Error Presensi: ${futurePostPresensiQr.message}');
//       }
//     } else {
//       print('Layanan lokasi dinonaktifkan, aktifkan terlebih dahulu.');
//     }
//   }

//   Future<void> saveOfflineAttendance(
//       String qrcode, String lat, String long) async {
//     final sp = await SharedPreferences.getInstance();
//     offlinePresensiTime.value = DateTime.now(); // Save the timestamp
//     await sp.setStringList('offline_attendance',
//         [qrcode, lat, long, offlinePresensiTime.value!.toIso8601String()]);
//     print("Data presensi disimpan offline");
//   }

//   void showOfflineDialog() {
//     Get.defaultDialog(
//       title: "Offline Presensi",
//       middleText: "Presensi berhasil disimpan secara offline.",
//       onConfirm: () => Get.back(),
//       textConfirm: "OK",
//     );
//   }

//   void sendPendingAttendanceData() async {
//     final sp = await SharedPreferences.getInstance();
//     List<String>? offlineData = sp.getStringList('offline_attendance');
//     if (offlineData != null && offlineData.isNotEmpty) {
//       String qrcode = offlineData[0];
//       String lat = offlineData[1];
//       String long = offlineData[2];

//       await pushPresensiQr(qrcode, lat, long);

//       // Delete data after sending it to the server
//       sp.remove('offline_attendance');
//       print("Data presensi offline telah dikirim dan dihapus dari penyimpanan");
//     }
//   }
// }
import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Presensi.dart';

enum CustomConnectivityResult {
  wifi,
  mobile,
  none,
}

class CustomConnectivity {
  // Simulate checking for connectivity status
  Future<CustomConnectivityResult> checkConnectivity() async {
    return CustomConnectivityResult.wifi; // Replace with actual implementation
  }

  // Simulate monitoring connectivity changes
  Stream<CustomConnectivityResult> get onConnectivityChanged async* {
    await Future.delayed(Duration(seconds: 1));
    yield CustomConnectivityResult.mobile;

    await Future.delayed(Duration(seconds: 1));
    yield CustomConnectivityResult.none;

    await Future.delayed(Duration(seconds: 1));
    yield CustomConnectivityResult.wifi;
  }
}

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
  RxBool isOnline = false.obs;
  Rx<DateTime?> offlinePresensiTime = Rx<DateTime?>(null);

  late StreamSubscription<CustomConnectivityResult> _connectivitySubscription;
  final CustomConnectivity _connectivity = CustomConnectivity();

  @override
  void onInit() async {
    super.onInit();
    await loadUserData();
    await determinePosition();
    await cekHid();
    startMonitoringConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void startMonitoringConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((CustomConnectivityResult result) {
      isOnline.value = result != CustomConnectivityResult.none;
      if (isOnline.value) {
        print("Connected to Internet");
        sendPendingAttendanceData();
      } else {
        print("No Internet Connection");
      }
    });
  }

  Future<void> loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    iduser = sp.getString('iduser') ?? '';
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

      if (isOnline.value) {
        await pushPresensiQr(barcode!, lat!, long!);
        showSuccessDialog(); // Tampilkan dialog sukses jika online
      } else {
        await saveOfflineAttendance(barcode!, lat!, long!);
        // showOfflineDialog(); // Tampilkan dialog offline
        if (offlinePresensiTime.value != null) {
          showOfflineDialog();
        } else {
          print('Waktu presensi offline belum terisi');
        }
      }
    } on PlatformException catch (error) {
      errorQr = error.code == BarcodeScanner.cameraAccessDenied
          ? 'Izin kamera tidak diizinkan oleh pengguna'
          : 'Error: $error';
    } on Exception catch (e) {
      errorQr = 'Error: $e';
    }
  }

  void showSuccessDialog() {
    Get.defaultDialog(
      title: "Presensi Berhasil",
      middleText: "Presensi berhasil dilakukan.",
      onConfirm: () => Get.back(),
      textConfirm: "OK",
    );
  }

  Future<void> cekHid() async {
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
  }

  Future<void> pushPresensiQr(String qrcode, String lat, String long) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      PresensiQr futurePostPresensiQr = await ApiService().postPresensiQr(
        idUser: iduser!,
        lat: lat,
        long: long,
        qrcode: qrcode,
      );

      if (futurePostPresensiQr.status == true) {
        print('Presensi Berhasil: ${futurePostPresensiQr.message}');
        showSuccessDialog(); // Panggil dialog sukses
      } else {
        print('Error Presensi: ${futurePostPresensiQr.message}');
        Get.defaultDialog(
          title: "Error",
          middleText:
              "Gagal melakukan presensi: ${futurePostPresensiQr.message}",
          onConfirm: () => Get.back(),
          textConfirm: "OK",
        );
      }
    } else {
      print('Layanan lokasi dinonaktifkan, aktifkan terlebih dahulu.');
    }
  }

  Future<void> saveOfflineAttendance(
      String qrcode, String lat, String long) async {
    final sp = await SharedPreferences.getInstance();
    offlinePresensiTime.value = DateTime.now(); // Save the timestamp
    await sp.setStringList('offline_attendance',
        [qrcode, lat, long, offlinePresensiTime.value!.toIso8601String()]);
    print("Data presensi disimpan offline");
  }

  // Ambil waktu presensi offline dari SharedPreferences ketika online
  Future<void> retrieveOfflineAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? offlineTime = prefs.getString('offline_time');
    if (offlineTime != null) {
      offlinePresensiTime.value = DateTime.parse(offlineTime);
    }
  }

  void showOfflineDialog() {
    Get.defaultDialog(
      title: "Presensi Offline",
      middleText:
          "Presensi berhasil disimpan secara offline pada ${offlinePresensiTime.value!.toLocal()}",
      onConfirm: () => Get.back(),
      textConfirm: "OK",
    );
  }

  void sendPendingAttendanceData() async {
    final sp = await SharedPreferences.getInstance();
    List<String>? offlineData = sp.getStringList('offline_attendance');
    if (offlineData != null && offlineData.isNotEmpty) {
      String qrcode = offlineData[0];
      String lat = offlineData[1];
      String long = offlineData[2];
      String presensiTime = offlineData[3];

      await pushPresensiQr(qrcode, lat, long);

      // Tampilkan dialog setelah mengirim data presensi offline
      Get.defaultDialog(
        title: "Presensi Terkirim",
        middleText:
            "Presensi yang dilakukan pada ${DateTime.parse(presensiTime).toLocal()} berhasil dikirim.",
        onConfirm: () => Get.back(),
        textConfirm: "OK",
      );

      // Delete data after sending it to the server
      sp.remove('offline_attendance');
      print("Data presensi offline telah dikirim dan dihapus dari penyimpanan");
    }
  }
}
