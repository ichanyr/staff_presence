import 'dart:convert';

class RiwayatModel {
  late bool status;
  late String message;
  late List<DataRiwayat> data;
  late int rows;

  RiwayatModel(
      {required this.status,
      required this.data,
      required this.rows,
      required this.message});

  factory RiwayatModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<DataRiwayat> dataList =
        list.map((i) => DataRiwayat.fromJson(i)).toList();
    return RiwayatModel(
        status: parsedJson['status'],
        rows: parsedJson['rows'],
        message: parsedJson['message'],
        data: dataList);
  }
}

class DataRiwayat {
  String? idRiwayat;
  String? idStaff;
  String? poin;
  String? lastTglMasuk;
  String? lastJamMasuk;
  String? lastJamKeluar;
  String? izin;

  DataRiwayat(
      {this.idRiwayat,
      this.idStaff,
      this.poin,
      this.lastTglMasuk,
      this.lastJamMasuk,
      this.lastJamKeluar,
      this.izin});

  factory DataRiwayat.fromJson(Map<String, dynamic> parsedJson) {
    return DataRiwayat(
        idRiwayat: parsedJson['id_riwayat'] ?? '',
        idStaff: parsedJson['id_staff'] ?? '',
        poin: parsedJson['poin'] ?? '0',
        izin: parsedJson['izin'] ?? '',
        lastTglMasuk: parsedJson['last_tgl_masuk'] ?? '[Belum]',
        lastJamMasuk: parsedJson['last_jam_masuk'] ?? '[Belum]',
        lastJamKeluar: parsedJson['last_jam_keluar'] ?? '[Belum]');
  }
}

List<RiwayatModel> msgFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<RiwayatModel>.from(
      data.map((item) => RiwayatModel.fromJson(item)));
}

Future loadRiwayat(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  RiwayatModel riwayat = new RiwayatModel.fromJson(jsonResponse);
}

Future<RiwayatModel> loadRiwayats(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  RiwayatModel riwayat = new RiwayatModel.fromJson(jsonResponse);
  return riwayat;
}
