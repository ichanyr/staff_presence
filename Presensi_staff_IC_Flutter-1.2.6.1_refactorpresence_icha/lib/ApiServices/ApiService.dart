import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:presensi_ic_staff/UI/Anggaran/Model/AnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/DetailAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/GetLaporanModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/KurangAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/SettingAppsMobileModel.dart';
import 'package:presensi_ic_staff/UI/Anggaran/Model/TambahAnggaranModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/CutiModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/DetailCutiModel.dart';
import 'package:presensi_ic_staff/UI/Cuti/Model/InsertCutiModel.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/ResponseSetToken.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/SettingDashModel.dart';
import 'package:presensi_ic_staff/UI/Dashboard/Model/dashboard.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/HapusLemburModel.dart';
import 'package:presensi_ic_staff/UI/Lembur/model/TambahLemburModel.dart';
import 'package:presensi_ic_staff/UI/Login/Model/Login.dart';
import 'package:presensi_ic_staff/UI/Presensi/model/Presensi.dart';
import 'package:presensi_ic_staff/UI/Presensi/model/qr.dart';
import 'package:presensi_ic_staff/UI/Profil/model/EditProfil.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Password.dart';
import 'package:presensi_ic_staff/UI/Profil/model/Profil.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/poinModel.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/riwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/todo.dart';

import '../UI/Cuti/Model/HapusCutiModel.dart';
import '../UI/Lembur/model/LemburModel.dart';

class ApiService {
  var baseUrls = Uri.parse("https://api.indonesiacollege.sch.id/staff");
  http.Client client = http.Client();
  Duration durasiTO = Duration(seconds: 3);

  Future<ResponUpdatePassword> postLupaPass(String email) async {
    var urlLogin = Uri.parse("$baseUrls/reset_pass/");
    var body = {'key': '1d81da29c9c50d57efc99fe9a1956ead', 'email': email};
    final response = await client.put(urlLogin, body: body);

    if (response.statusCode == 200) {
      return responseLupaPass(response.body);
    } else {
      return responseLupaPass(response.body);
      // return null;
    }
  }

  Future<Login> postLogin(String hid, String email, String pass) async {
    var urlLogin = Uri.parse("$baseUrls/login");
    var body = {
      'key': 'd56b699830e77ba53855679cb1d252da',
      'email': email,
      'hid': hid,
      'password': pass
    };
    final response = await client.post(urlLogin, body: body);

    if (response.statusCode == 200) {
      return cekAuth(response.body);
    } else {
      return cekAuth(response.body);
      // return null;
    }
  }

// =============================== Dashboard
  Future<DashboardModel> getPoin(String idUser) async {
    var urlPoin = Uri.parse(
        "$baseUrls/dashboard/?key=dc7161be3dbf2250c8954e560cc35060&id_staff=$idUser");

    final response = await client.get(urlPoin);
    if (response.statusCode == 200) {
      return loadPoin(response.body);
    } else {
      return loadPoin(response.body);
    }
  }

  Future<Qr> getQr(String idUser) async {
    var urlPoin = Uri.parse(
        "$baseUrls/qr/?key=eb430691fe30d16070b5a144c3d3303c&id_staff=$idUser");
    final response = await client.get(urlPoin);
    if (response.statusCode == 200) {
      return loadQr(response.body);
    } else {
      return loadQr(response.body);
      // return null;
    }
  }

  Future<bool> cekServer() async {
    var urlPoin = Uri.parse("$baseUrls/cek_server");

    try {
      final response =
          await client.get(urlPoin).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (_) {
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<SettingDashboard> getSettingDash() async {
    var urlPoin = Uri.parse(
        "$baseUrls/set_dashboard/?key=bc4b680e582cd8169600ebb96cc5ff4a");
    final response = await client.get(urlPoin);
    if (response.statusCode == 200) {
      return loadSettingDash(response.body);
    } else {
      return loadSettingDash(response.body);
      // return null;
    }
  }

  Future<ResponseSetTokenFcm> setTokenFcm(
      {required String idstaf,
      required String token,
      required String device}) async {
    var urlPoin = Uri.parse("$baseUrls/notifikasi/set_token/");

    Map<String, String> body = {
      'idstaf': idstaf,
      'token_fcm': token,
      'device': device,
      'key': 'f41676f3897612d953e2e3c25c0e1bf3'
    };
    final response = await client.post(urlPoin, body: body);

    if (response.statusCode == 200) {
      return ResponseSetTokenFcm.fromRawJson(response.body);
    } else {
      return ResponseSetTokenFcm.fromRawJson(response.body);
      // return null;
    }
  }

  // =============================== Presensi
  Future<PresensiQr> postPresensiQr(
      {required String idUser,
      required String lat,
      required String long,
      required String qrcode}) async {
    var urlPoin = Uri.parse("$baseUrls/presensi/qr_1_5/");
    var body = {
      'key': 'eb430691fe30d16070b5a144c3d3303c',
      'idstaf': idUser,
      "lat": lat,
      "long": long,
      "qrcode": qrcode
    };
    final response = await client.post(urlPoin, body: body);
    if (response.statusCode == 200) {
      return loadResponPresensi(response.body);
    } else {
      return loadResponPresensi(response.body);
      // return null;
    }
  }

  Future<PresensiQr> postPresensiLuar(
      String img, String idUser, String ket, String long, String lat) async {
    var urlPLuar = Uri.parse("$baseUrls/presensi/presensi_luar2_1_mock/");
    var body = {
      'key': '47688dabde1eff4dc3739c24b0913223',
      'file': img,
      'id_staff': idUser,
      'keterangan': ket,
      'lat': lat,
      'long': long
    };
    final response = await client.post(urlPLuar, body: body);
    if (response.statusCode == 200) {
      return loadResponPresensi(response.body);
    } else {
      return loadResponPresensi(response.body);
      // return null;
    }
  }

  // =============================== Profil
  Future<ProfilEdit> putProfil(
      String idUser, String hp, String email, String alamat) async {
    var urlProfil = Uri.parse("$baseUrls/edit_profil/");
    var body = {
      'key': '8a8941a6b63d62a7379ef939538f853f',
      'id_staff': idUser,
      'phone': hp,
      'email': email,
      'address': alamat
    };
    final response = await client.put(urlProfil, body: body);
    if (response.statusCode == 200) {
      return loadRspnsProfil(response.body);
    } else {
      return loadRspnsProfil(response.body);
    }
  }

  Future<ProfilModel> getProfil(String idUser) async {
    if (idUser != '') {
      var urlPoin = Uri.parse(
          "$baseUrls/profil/?key=9ee23ca07e7df06b92897c49e26bdc3f&id_staff=$idUser");
      final response = await client.get(urlPoin);
      if (response.statusCode == 200) {
        return loadProfil(response.body);
      } else {
        return loadProfil(response.body);
      }
    } else {
      return ProfilModel(status: false, dataProfil: DataProfil(name: ''));
    }
  }

  Future<ResponUpdatePassword> putPassword(
      String pass1, String pass2, String iduser) async {
    var urlPass = Uri.parse("$baseUrls/edit_pass");
    var body = {
      'key': '1b735dfde67b37b6f156c49de5fc55bf',
      'old_pass': pass1,
      'new_pass': pass2,
      'id_staff': iduser
    };
    final response = await client.put(urlPass, body: body);

    if (response.statusCode == 200) {
      return responsePutPass(response.body);
    } else {
      return responsePutPass(response.body);
      // return null;
    }
  }

// =============================== Riwayat
  Future<RiwayatModel> getRiwayats(String idUser) async {
    var urlRiwayat = Uri.parse(
        "$baseUrls/riwayats/riwayat/?key=03ef883ea41c6dfad48eabb6039651da&id_staff=$idUser&limit=10&offset=10");
    final response = await client.get(urlRiwayat);
    if (response.statusCode == 200) {
      // return msgFromJson(response.body);
      return loadRiwayats(response.body);
      // return msgFromJson(response.body);
    } else {
      return loadRiwayats(response.body);
    }
  }

  Future<RiwayatModel> getRiwayatFilter(
      String idUser, String tahun, String bulan) async {
    var urlRiwayat = Uri.parse(
        "$baseUrls/riwayats/riwayat/?key=03ef883ea41c6dfad48eabb6039651da&id_staff=$idUser&tahun=$tahun&bulan=$bulan");
    final response = await client.get(urlRiwayat);
    if (response.statusCode == 200) {
      // return msgFromJson(response.body);
      return loadRiwayats(response.body);
      // return msgFromJson(response.body);
    } else {
      return loadRiwayats(response.body);
    }
  }

  Future<DetailRiwayat> getDetailR(String idRiwayat, String idUser) async {
    var urlDetailR = Uri.parse(
        "$baseUrls/riwayats/detail_riwayat/?key=ff6127f5600b8b53ea96eef61d475e03&id_riwayat=$idRiwayat&id_staff=$idUser");
    final response = await client.get(urlDetailR);
    if (response.statusCode == 200) {
      return loadDetailR(response.body);
    } else {
      return loadDetailR(response.body);
    }
  }

  Future<TodoAct> postTodo(String idPresensi, String isi) async {
    var urlTodo = Uri.parse("$baseUrls/todolist/");
    var body = {
      'key': '086bec6f119951c2a07358deb5991a3e',
      'id_presensi': idPresensi,
      'todolist': isi
    };
    final response = await client.post(urlTodo, body: body);

    if (response.statusCode == 200) {
      return loadTodo(response.body);
    } else {
      return loadTodo(response.body);
    }
  }

  Future<DetailAnggaran> getDetailAnggaran(String id) async {
    Uri urlDetail = Uri.parse(
        "$baseUrls/detail_anggaran/?key=8a864ead3eaa394c457a5c7825fc4856&id=$id");
    final response = await client.get(urlDetail);

    if (response.statusCode == 200) {
      return loadDetailAnggaran(response.body);
    } else {
      return loadDetailAnggaran(response.body);
    }
  }

  Future<SettingAppsMobile> getSetting() async {
    Uri urlSetting = Uri.parse(
        "$baseUrls/setting_apps_mobile/?key=256fcadbaa44b4ee848a1ecfaa29e738&id=1");
    final response = await client.get(urlSetting);

    if (response.statusCode == 200) {
      return loadSetting(response.body);
    } else {
      return loadSetting(response.body);
    }
  }

  /// [[Post]] idstaf, todo
  ///
  /// [[Put]] id, todo, (Opsi) status
  ///
  /// [[Delete]] id, hapus(true)
  ///
  /// [[Put]] id, status(y/n)
  ///
  /// tipe [1 = insert, 2 = update, 3 = hapus, 4 = update status]
  Future<TodoAct> postTodo_v2(
      {String? id,
      required String idstaf,
      String? todo,
      String? status,
      required int tipe,
      bool? hapus}) async {
    Uri urlInsert = Uri.parse("$baseUrls/riwayats/detail_riwayat/");

    Map body;
    switch (tipe) {
      /// 1 = insert
      case 1:
        body = {
          'key': 'ff6127f5600b8b53ea96eef61d475e03',
          'idstaf': idstaf,
          'todo': todo
        };
        break;

      /// 2 = update
      case 2:
        body = {
          'key': 'ff6127f5600b8b53ea96eef61d475e03',
          'id': id,
          'todo': todo,
          'status': status
        };
        break;

      /// 3 = hapus
      case 3:
        body = {
          'key': 'ff6127f5600b8b53ea96eef61d475e03',
          'id': id,
          'hapus': hapus.toString()
        };
        break;

      /// 4 = update status
      case 4:
        body = {
          'key': 'ff6127f5600b8b53ea96eef61d475e03',
          'id': id,
          'status': status
        };
        break;

      default:
        body = {
          'key': 'ff6127f5600b8b53ea96eef61d475e03',
          'idstaf': idstaf,
          'todo': todo
        };
        break;
    }

    // Map body = {
    //   'key': 'ff6127f5600b8b53ea96eef61d475e03',
    //   'id': id ?? '',
    //   'idstaf': idstaf ?? '',
    //   'todo': todo ?? '',
    //   'status': status ?? '',
    //   'hapus': hapus ?? 'false'
    // };

    try {
      final response = await client.post(urlInsert, body: body);

      if (response.statusCode == 200) {
        return loadTodo(response.body);
      } else {
        return loadTodo(response.body);
      }
    } on TimeoutException catch (e) {
      return loadTodo(TodoAct(status: false, message: 'Waktu tunggu habis!')
          .toJson()
          .toString());
    } on SocketException catch (e) {
      return loadTodo(TodoAct(status: false, message: 'Cek Koneksi Anda!')
          .toJson()
          .toString());
    } on Exception catch (e) {
      return loadTodo(TodoAct(status: false, message: 'Terjadi Kesalahan $e !')
          .toJson()
          .toString());
    }
  }

  /// get Poin
  Future<PoinModel> getPoinV2(
      {required String idstaf,
      String? bulan,
      String? tahun,
      bool? isTotal,
      int? lastData,
      String? idPresensi}) async {
    Uri urlPoin = Uri.parse(
        "$baseUrls/riwayats/poin/detail_poin?key=c6b7011c12d7991efe41d2ddf363ca09&idstaf=$idstaf&id_presensi=$idPresensi&last_data=$lastData&is_total=$isTotal&bulan=$bulan&tahun=$tahun");

    /// data kosongan
    PoinModel poinModel = PoinModel(
        message: '',
        status: false,
        data: [],
        count: 0,
        tm: 0,
        sm: 0,
        tk: 0,
        total: 0);

    final response = await client.get(urlPoin);

    poinModel = PoinModel.fromJson(jsonDecode(response.body));

    return poinModel;
  }

// =============================== Anggaran
  Future<Anggaran> getAnggaran(
      String idstaf, String bulan, String tahun) async {
    Uri urlAnggaran = Uri.parse(
        "$baseUrls/req_anggaran/?key=7cdc1c3bad272d795ec509652ff3e85b&idstaf=$idstaf&bulan=$bulan&tahun=$tahun");
    final response = await client.get(urlAnggaran);

    if (response.statusCode == 200) {
      return loadAnggaran(response.body);
    } else {
      return loadAnggaran(response.body);
    }
  }

  Future<TambahAnggaranModel> postAnggaran(
      String idstaf, String judul, String nominal, String ket) async {
    Uri urlTambah = Uri.parse("$baseUrls/add_anggaran/");
    var body = {
      'key': 'd1a3e316c8d7ddd42c24284992074137',
      'idstaf': idstaf,
      'judul': judul,
      'nominal': nominal,
      'ket': ket
    };
    final response = await client.post(urlTambah, body: body);

    if (response.statusCode == 200) {
      return loadTambahAnggaran(response.body);
    } else {
      return loadTambahAnggaran(response.body);
    }
  }

  Future<KurangAnggaranModel> deleteAnggaran(String id, String idstaf) async {
    Uri urlTambah = Uri.parse("$baseUrls/del_anggaran/");
    var headers = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'idstaf': idstaf,
      'id': id
    };
    final response =
        await client.delete(urlTambah, body: body, headers: headers);

    if (response.statusCode == 200) {
      return loadKurangAnggaran(response.body);
    } else {
      return loadKurangAnggaran(response.body);
    }
  }

  Future<TambahAnggaranModel> putAnggaran({
    required String id,
    required String idStaf,
    required String judul,
    required String ket,
    required int nominal,
  }) async {
    Uri urlPut = Uri.parse("$baseUrls/req_anggaran/");
    var headers = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {
      'key': '7cdc1c3bad272d795ec509652ff3e85b',
      'idstaf': idStaf,
      'id': id,
      'judul': judul,
      'ket': ket,
      'nominal': nominal.toString()
    };
    final response = await client.put(urlPut, body: body, headers: headers);

    if (response.statusCode == 200) {
      return loadTambahAnggaran(response.body);
    } else {
      return loadTambahAnggaran(response.body);
    }
  }

// =============================== Laporan Anggaran
  Future<LaporanAnggaran> getLaporan(String id) async {
    Uri urlget = Uri.parse(
        "$baseUrls/lap_anggaran/?key=0fa0ef0a9239a0e2d606d5392b38d225&id=$id");

    final response = await client.get(urlget);
    if (response.statusCode == 200) {
      return loadGetAnggaran(response.body);
    } else {
      return loadGetAnggaran(response.body);
    }
  }

  Future<TambahAnggaranModel> hapusLaporan(
      {required String id, required String idstaf}) async {
    Uri urlHapus = Uri.parse("$baseUrls/lap_anggaran/");

    var headers = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'key': '0fa0ef0a9239a0e2d606d5392b38d225',
      'id': id,
      'idstaf': idstaf
    };

    final response =
        await client.delete(urlHapus, headers: headers, body: body);
    if (response.statusCode == 200) {
      return loadTambahAnggaran(response.body);
    } else {
      return loadTambahAnggaran(response.body);
    }
  }

  Future<TambahAnggaranModel> postLaporan(
      {required int id,
      required String idstaf,
      required int idReq,
      required String item,
      required int nominal,
      required String catatan,
      required DateTime waktu,
      required String xfile}) async {
    Uri urlInsert = Uri.parse("$baseUrls/lap_anggaran/");

    var headers = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'key': '0fa0ef0a9239a0e2d606d5392b38d225',
      'id': id.toString(),
      'idstaf': idstaf,
      'idreq': idReq.toString(),
      'item': item,
      'nominal': nominal.toString(),
      'catatan': catatan,
      'waktu': waktu.toString(),
      'file': xfile
    };

    var request = http.MultipartRequest('POST', urlInsert);
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath("file", xfile));
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    // final responsedData = loadTambahAnggaran(responsed.body);

    if (response.statusCode == 200) {
      return loadTambahAnggaran(responsed.body);
    } else {
      return loadTambahAnggaran(responsed.body);
    }
  }

// =============================== Cuti
  Future<CutiModel> getCuti(
      {required String id,
      required List<String> izin,
      required List<String> proses,
      required int tahun}) async {
    String izins = izin.join(',');
    String prosess = proses.join(',');
    izins == 'all' ? izins = '' : izins = izins;
    prosess == 'all' ? prosess = '' : prosess = prosess;

    Uri urlget = Uri.parse(
        "$baseUrls/cuti/cuti?key=cddba63410e382edd112b4b936142142&idstaf=$id&izin=$izins&status=$prosess&tahun=$tahun");

    final response = await client.get(urlget).timeout(durasiTO);

    try {
      if (response.statusCode == 200) {
        return loadGetCuti(response.body);
      } else {
        return loadGetCuti(response.body);
      }
    } on TimeoutException catch (e) {
      return loadGetCuti(cutiModelToJson(CutiModel(
          status: false,
          message: e.toString(),
          jatahCuti: [],
          sum: Sum(alpha: 'n/a', izin: 'n/a', sakit: 'n/a', cuti: 'n/a'),
          izin: [])));
    } on SocketException catch (e) {
      return loadGetCuti(cutiModelToJson(CutiModel(
          status: false,
          message: e.toString(),
          jatahCuti: [],
          sum: Sum(alpha: 'n/a', izin: 'n/a', sakit: 'n/a', cuti: 'n/a'),
          izin: [])));
    } on Exception catch (e) {
      return loadGetCuti(cutiModelToJson(CutiModel(
          status: false,
          message: e.toString(),
          jatahCuti: [],
          sum: Sum(alpha: 'n/a', izin: 'n/a', sakit: 'n/a', cuti: 'n/a'),
          izin: [])));
    }
  }

  Future<InsertCutiModel> postCuti(
      {required String idstaf,
      required String dari,
      required String sampai,
      required String izin,
      required String ket,
      required String xfile,
      required String id}) async {
    Uri urlInsert = Uri.parse("$baseUrls/cuti/cuti/");

    var headers = {
      'key': '5795f9efa6e89940017e3f9bcb531c87',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'key': 'cddba63410e382edd112b4b936142142',
      'idstaf': idstaf,
      'dari': dari,
      'sampai': sampai,
      'izin': izin,
      'ket': ket,
      'file': xfile,
      'id': id
    };

    try {
      if (xfile != null && xfile != '') {
        var request = http.MultipartRequest('POST', urlInsert);
        request.files.add(await http.MultipartFile.fromPath("file", xfile));
        request.fields.addAll(body);
        request.headers.addAll(headers);
        var response;
        var responsed;
        response = await request.send();
        responsed = await http.Response.fromStream(response);

        // final responsedData = loadTambahAnggaran(responsed.body);

        if (response.statusCode == 200) {
          return loadPostCuti(responsed.body);
        } else {
          return loadPostCuti(responsed.body);
        }
      } else {
        final response =
            await client.post(urlInsert, body: body, headers: headers);
        if (response.statusCode == 200) {
          return loadPostCuti(response.body);
        } else {
          return loadPostCuti(response.body);
        }
      }
    } on TimeoutException catch (e) {
      return loadPostCuti(insertCutiModelToJson(InsertCutiModel(
          status: false,
          jumlahCuti: JumlahCuti(
              jumlahCuti: 0, bolehCuti: false, tahun: '', jatahCuti: 0),
          message: 'Waktu Tunggu Habis!',
          jatahCuti: [])));
    } on SocketException catch (e) {
      return loadPostCuti(insertCutiModelToJson(InsertCutiModel(
          status: false,
          jumlahCuti: JumlahCuti(
              jumlahCuti: 0, bolehCuti: false, tahun: '', jatahCuti: 0),
          message: 'Periksa Jaringan internet anda!',
          jatahCuti: [])));
    } on Exception catch (e) {
      return loadPostCuti(insertCutiModelToJson(InsertCutiModel(
          status: false,
          jumlahCuti: JumlahCuti(
              jumlahCuti: 0, bolehCuti: false, tahun: '', jatahCuti: 0),
          message: 'Terjadi error = $e',
          jatahCuti: [])));
    }
  }

  Future<DetailCutiModel> getDetailCuti({required String id}) async {
    Uri urlget = Uri.parse(
        "$baseUrls/cuti/detail_cuti?key=cddba63410e382edd112b4b936142142&id=$id");

    final response = await client.get(urlget).timeout(durasiTO);

    try {
      if (response.statusCode == 200) {
        return loadDetailCuti(response.body);
      } else {
        return loadDetailCuti(response.body);
      }
    } on TimeoutException catch (e) {
      return loadDetailCuti(detailCutiModelToJson(DetailCutiModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!',
          data: [])));
    } on SocketException catch (e) {
      return loadDetailCuti(detailCutiModelToJson(DetailCutiModel(
          status: false,
          message: 'Gagal mendapatkan data, Cek koneksi internet anda!',
          data: [])));
    } on Exception catch (e) {
      return loadDetailCuti(detailCutiModelToJson(DetailCutiModel(
          status: false,
          message: 'Gagal mendapatkan data karena = $e!',
          data: [])));
    }
  }

  Future<HapusCutiModel> delCuti({required String id}) async {
    Uri urlPost = Uri.parse("$baseUrls/cuti/del_cuti");

    var body = {'id': id, 'key': 'cddba63410e382edd112b4b936142142'};

    final response = await client.post(urlPost, body: body).timeout(durasiTO);

    try {
      if (response.statusCode == 200) {
        return loadDelCuti(response.body);
      } else {
        return loadDelCuti(response.body);
      }
    } on TimeoutException catch (e) {
      return loadDelCuti(hapusCutiModelToJson(HapusCutiModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    } on SocketException catch (e) {
      return loadDelCuti(hapusCutiModelToJson(HapusCutiModel(
          status: false,
          message: 'Gagal mendapatkan data, Cek koneksi dan wifi anda!')));
    } on Exception catch (e) {
      return loadDelCuti(hapusCutiModelToJson(HapusCutiModel(
          status: false,
          message: 'Gagal mendapatkan data karena terjadi eror : $e!')));
    }
  }

// =============================== Lembur
  Future<LemburModel> getLembur(
      {required String idstaf,
      required String bulan,
      required String tahun}) async {
    Uri urlget = Uri.parse(
        "$baseUrls/presensi/lembur/lembur?key=9da93580e0de9fd71291af38df22b5da&idstaf=$idstaf&bulan=$bulan&tahun=$tahun");

    try {
      final response = await client.get(urlget).timeout(durasiTO);
      if (response.statusCode == 200) {
        return loadLembur(response.body);
      } else {
        return loadLembur(response.body);
      }
    } on TimeoutException catch (e) {
      return loadLembur(lemburModelToJson(LemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!',
          data: [],
          count: 0)));
    } on SocketException catch (e) {
      return loadLembur(lemburModelToJson(LemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!',
          data: [],
          count: 0)));
    } on Exception catch (e) {
      return loadLembur(lemburModelToJson(LemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!',
          data: [],
          count: 0)));
    }
  }

  Future<TambahLemburModel> postLembur(
      {required String idstaf,
      required String mulai,
      required String idlembur,
      required String ket,
      required String selesai}) async {
    Uri urlPost = Uri.parse("$baseUrls/presensi/lembur/lembur");

    Map<String, String> body = {
      'key': '9da93580e0de9fd71291af38df22b5da',
      'id_lembur': idlembur,
      'id_staf': idstaf,
      'mulai': mulai,
      'ket': ket,
      'selesai': selesai
    };

    final response = await client.post(urlPost, body: body).timeout(durasiTO);

    try {
      if (response.statusCode == 200) {
        return loadTambahLembur(response.body);
      } else {
        return loadTambahLembur(response.body);
      }
    } on TimeoutException catch (e) {
      return loadTambahLembur(tambahLemburModelToJson(TambahLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    } on SocketException catch (e) {
      return loadTambahLembur(tambahLemburModelToJson(TambahLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    } on Exception catch (e) {
      return loadTambahLembur(tambahLemburModelToJson(TambahLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    }
  }

  Future<HapusLemburModel> delLembur(
      {required String idlembur, required String idstaf}) async {
    Uri urldel = Uri.parse("$baseUrls/presensi/lembur/lembur");

    Map<String, String> body = {
      'key': '9da93580e0de9fd71291af38df22b5da',
      'id': idlembur,
      'idstaf': idstaf
    };

    final response = await client.delete(urldel, body: body).timeout(durasiTO);

    try {
      if (response.statusCode == 200) {
        return loadHapusLembur(response.body);
      } else {
        return loadHapusLembur(response.body);
      }
    } on TimeoutException catch (e) {
      return loadHapusLembur(hapusLemburModelToJson(HapusLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    } on SocketException catch (e) {
      return loadHapusLembur(hapusLemburModelToJson(HapusLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    } on Exception catch (e) {
      return loadHapusLembur(hapusLemburModelToJson(HapusLemburModel(
          status: false,
          message: 'Gagal mendapatkan data karena waktu tunggu habis!')));
    }
  }
}
