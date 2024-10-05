import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_ic_staff/UI/Dashboard/dashboard.dart';
import 'package:presensi_ic_staff/UI/Element/ScrollAndResponsive.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Presensi/Controller/PresensiQrController.dart';
import 'package:presensi_ic_staff/UI/Presensi/PresensiLuar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Element/textView.dart';

class PresensiQRPage extends StatefulWidget {
  PresensiQRPage({Key? key}) : super(key: key);

  @override
  _PresensiQRPage createState() => _PresensiQRPage();
}

class _PresensiQRPage extends State<PresensiQRPage> {
  final PresensiQrController pqrCtrl = Get.put(PresensiQrController());
  RefreshController refreshctrl = RefreshController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.remove(myInterceptor);
    pqrCtrl.determinePosition().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            textIsi2(isi: "Presensi", warna: warnaHitam, fw: FontWeight.bold),
        backgroundColor: warnaPutih,
        foregroundColor: warnaHitam,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: warnaHitam),
          onPressed: () {
            Get.to(() => DashboardPage());
          },
        ),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return ScrollDenganReload(
      refreshController: refreshctrl,
      onRefresh: () async {
        await pqrCtrl.determinePosition();
        refreshctrl.refreshCompleted();
      },
      child: Container(
        constraints: BoxConstraints.loose(Size(600, 600)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[mapsView(), btnQrPage(), btnLuarPage()],
          ),
        ),
      ),
    );
  }

  Widget mapsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.maxFinite,
          height: 300,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Obx(() => FlutterMap(
                    options: MapOptions(
                      initialCenter: pqrCtrl.latLong.value,
                      initialZoom: 18,
                      maxZoom: 20,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: pqrCtrl.latLong.value,
                            child: Icon(
                              Icons.gps_fixed_outlined,
                              color: warnaMerah,
                              size: 40,
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
        ),
      ],
    );
  }

  Widget btnQrPage() {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 16, left: 30, right: 30),
        child: ElevatedButton(
          onPressed: () => pqrCtrl.presensiQR(),
          child: textIsiWhite("Presensi QR"),
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

  Widget btnLuarPage() {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 16, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () => Get.to(() => PresensiAlternatif()),
                child: textIsi2(isi: "Presensi Alternatif *"),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
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
            SizedBox(height: 16),
            textIsi2(
              isi: '*Dapat digunakan ketika sedang bertugas diluar kantor atau '
                  'ketika terjadi kendala dengan Presensi QR.',
            ),
          ],
        ),
      ),
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Get.to(() => DashboardPage());
    return true;
  }
}
