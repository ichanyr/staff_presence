class PoinModel {
  PoinModel({
    required this.status,
    required this.message,
    required this.data,
    required this.tm,
    required this.sm,
    required this.tk,
    required this.total,
    required this.count,
  });

  late final bool status;
  late final String message;
  late final List<Data> data;
  late final int tm;
  late final int sm;
  late final int tk;
  late final int total;
  late final int count;

  PoinModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    tm = json['tm'] ?? 0;
    sm = json['sm'] ?? 0;
    tk = json['tk'] ?? 0;
    total = json['total'] ?? 0;
    count = json['count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['tm'] = tm;
    _data['sm'] = sm;
    _data['tk'] = tk;
    _data['total'] = total;
    _data['count'] = count;
    return _data;
  }
}

class Data {
  Data({
    required this.idPresensiStaff,
    required this.presentMasuk,
    this.presentKeluar,
    required this.poinMasuk,
    required this.poinKeluar,
    required this.tipePoint,
    required this.kategoriPoint,
    required this.valuePoint,
    required this.keteranganPoint,
    required this.createdAt,
    required this.createdBy,
  });

  late final String idPresensiStaff;
  late final String presentMasuk;
  late final String? presentKeluar;
  late final String poinMasuk;
  late final String poinKeluar;
  late final String tipePoint;
  late final String kategoriPoint;
  late final String valuePoint;
  late final String keteranganPoint;
  late final String createdAt;
  late final String createdBy;

  Data.fromJson(Map<String, dynamic> json) {
    idPresensiStaff = json['id_presensi_staff'];
    presentMasuk = json['present_masuk'];
    presentKeluar = json['present_keluar'] ?? '';
    poinMasuk = json['poin_masuk'];
    poinKeluar = json['poin_keluar'];
    tipePoint = json['tipe_point'] ?? 'negatif';
    kategoriPoint = json['kategori_point'] ?? 'telat';
    valuePoint = json['value_point'] ?? '0';
    keteranganPoint = json['keterangan_point'] ?? '';
    createdAt = json['created_at'] ?? '';
    createdBy = json['created_by'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_presensi_staff'] = idPresensiStaff;
    _data['present_masuk'] = presentMasuk;
    _data['present_keluar'] = presentKeluar;
    _data['poin_masuk'] = poinMasuk;
    _data['poin_keluar'] = poinKeluar;
    _data['tipe_point'] = tipePoint;
    _data['kategori_point'] = kategoriPoint;
    _data['value_point'] = valuePoint;
    _data['keterangan_point'] = keteranganPoint;
    _data['created_at'] = createdAt;
    _data['created_by'] = createdBy;
    return _data;
  }
}
