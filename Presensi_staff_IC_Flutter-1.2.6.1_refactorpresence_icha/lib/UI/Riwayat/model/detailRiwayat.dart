import 'dart:convert';

// class DetailRiwayat {
//   bool status;
//   Data datas;
//   String message;
//
//   DetailRiwayat({this.status, this.datas, this.message});
//
//   DetailRiwayat.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     datas = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.datas != null) {
//       data['data'] = this.datas.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String idRiwayat;
//   String idStaff;
//   String jamMasuk;
//   String jamKeluar;
//   String keteranganDatang;
//   String keteranganPulang;
//   String fotoDatang;
//   String fotoPulang;
//   String poin;
//   String totalPoin;
//   String lokasiDatang;
//   String lokasiPulang;
//   String todolist;
//   String izin;
//
//   Data(
//       {this.idRiwayat,
//       this.idStaff,
//       this.jamMasuk,
//       this.jamKeluar,
//       this.keteranganDatang,
//       this.keteranganPulang,
//       this.fotoDatang,
//       this.fotoPulang,
//       this.poin,
//       this.totalPoin,
//       this.lokasiDatang,
//       this.lokasiPulang,
//       this.izin,
//       this.todolist});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     idRiwayat = json['id_riwayat'];
//     idStaff = json['id_staff'];
//     jamMasuk = json['jam_masuk'];
//     jamKeluar = json['jam_keluar'];
//     keteranganDatang = json['keterangan_datang'] ?? "";
//     keteranganPulang = json['keterangan_pulang'] ?? "";
//     fotoDatang = json['foto_datang'] ?? "";
//     fotoPulang = json['foto_pulang'] ?? "";
//     poin = json['poin'];
//     izin = json['izin'] ?? '';
//     totalPoin = json['total_poin'];
//     lokasiDatang = json['lokasi_datang'];
//     lokasiPulang = json['lokasi_pulang'];
//     todolist = json['todolist'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id_riwayat'] = this.idRiwayat;
//     data['id_staff'] = this.idStaff;
//     data['jam_masuk'] = this.jamMasuk;
//     data['izin'] = this.izin;
//     data['jam_keluar'] = this.jamKeluar;
//     data['keterangan_datang'] = this.keteranganDatang;
//     data['keterangan_pulang'] = this.keteranganPulang;
//     data['foto_datang'] = this.fotoDatang;
//     data['foto_pulang'] = this.fotoPulang;
//     data['poin'] = this.poin;
//     data['total_poin'] = this.totalPoin;
//     data['lokasi_datang'] = this.lokasiDatang;
//     data['lokasi_pulang'] = this.lokasiPulang;
//     data['todolist'] = this.todolist;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final detailRiwayat = detailRiwayatFromJson(jsonString);

DetailRiwayat detailRiwayatFromJson(String str) =>
    DetailRiwayat.fromJson(json.decode(str));

String detailRiwayatToJson(DetailRiwayat data) => json.encode(data.toJson());

class DetailRiwayat {
  DetailRiwayat({this.status, this.message, this.listDataDetailRiwayat, this.listTodo});

  final bool? status;
  final String? message;
  final List<DataDetailRiwayat>? listDataDetailRiwayat;
  final List<Todo>? listTodo;

  factory DetailRiwayat.fromJson(Map<String, dynamic> json) => DetailRiwayat(
        status: json["status"],
        message: json["message"],
        listDataDetailRiwayat: List<DataDetailRiwayat>.from(json["data"].map((x) => DataDetailRiwayat.fromJson(x))),
        listTodo: List<Todo>.from(json["todo"].map((x) => Todo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(listDataDetailRiwayat!.map((x) => x.toJson())),
        "todo": List<dynamic>.from(listDataDetailRiwayat!.map((x) => x.toJson())),
      };
}

class DataDetailRiwayat {
  DataDetailRiwayat({
    this.idRiwayat,
    this.idStaff,
    this.jamMasuk,
    this.jamKeluar,
    this.keteranganDatang,
    this.keteranganPulang,
    this.fotoDatang,
    this.fotoPulang,
    this.poin,
    this.qrDatang,
    this.qrPulang,
    this.lokasiDatang,
    this.lokasiPulang,
    this.todolist,
    this.izin,
    this.noteMasuk,
    this.notePulang,
    this.isAktif,
    this.totalPoin,
  });

  final String? idRiwayat;
  final String? idStaff;
  final String? jamMasuk;
  final String? jamKeluar;
  final String? keteranganDatang;
  final String? keteranganPulang;
  final String? fotoDatang;
  final String? fotoPulang;
  final String? poin;
  final String? qrDatang;
  final String? qrPulang;
  final String? lokasiDatang;
  final String? lokasiPulang;
  final String? noteMasuk;
  final String? notePulang;
  final String? todolist;
  final String? totalPoin;
  final String? izin;
  final String? isAktif;

  factory DataDetailRiwayat.fromJson(Map<String, dynamic> json) => DataDetailRiwayat(
        idRiwayat: json["id_riwayat"],
        idStaff: json["id_staff"],
        jamMasuk: json["jam_masuk"] ?? '',
        jamKeluar: json["jam_keluar"] ?? '',
        keteranganDatang: json["keterangan_datang"] ?? '',
        keteranganPulang: json["keterangan_pulang"] ?? '',
        fotoDatang: json["foto_datang"] ?? '',
        fotoPulang: json["foto_pulang"] ?? '',
        poin: json["poin"] ?? '',
        qrDatang: json["qr_datang"] ?? '',
        qrPulang: json["qr_pulang"] ?? '',
        lokasiDatang: json["lokasi_datang"] ?? '',
        lokasiPulang: json["lokasi_pulang"] ?? '',
        noteMasuk: json["note_masuk"] ?? '',
        notePulang: json["note_keluar"] ?? '',
        todolist: json["todolist"] ?? '',
        izin: json["izin"] ?? '',
        totalPoin: json["total_poin"] ?? '',
        isAktif: json["is_aktif"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_riwayat": idRiwayat,
        "id_staff": idStaff,
        "jam_masuk": jamMasuk,
        "jam_keluar": jamKeluar,
        "keterangan_datang": keteranganDatang,
        "keterangan_pulang": keteranganPulang,
        "foto_datang": fotoDatang,
        "foto_pulang": fotoPulang,
        "poin": poin,
        "total_poin": totalPoin,
        "qr_datang": qrDatang,
        "qr_pulang": qrPulang,
        "lokasi_datang": lokasiDatang,
        "lokasi_pulang": lokasiPulang,
        "note_masuk":noteMasuk,
        "note_keluar": notePulang,
        "todolist": todolist,
        "izin": izin,
        "is_aktif": isAktif,
      };
}

class Todo {
  Todo({
    this.id,
    this.idstaf,
    this.todo,
    this.isDone,
    this.createdAt,
    this.updatedAt,
    this.isAktif,
  });

  final String? id;
  final String? idstaf;
  final String? todo;
  final String? isDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? isAktif;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        idstaf: json["idstaf"],
        todo: json["todo"],
        isDone: json["is_done"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isAktif: json["is_aktif"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idstaf": idstaf,
        "todo": todo,
        "is_done": isDone,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "is_aktif": isAktif,
      };
}

Future<DetailRiwayat> loadDetailR(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  DetailRiwayat detailRiwayat = new DetailRiwayat.fromJson(jsonResponse);
  return detailRiwayat;
}
