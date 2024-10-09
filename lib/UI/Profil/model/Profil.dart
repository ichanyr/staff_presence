import 'dart:convert';

class ProfilModel {
  late bool status;
  late DataProfil dataProfil;

  ProfilModel({required this.status,required this.dataProfil});

  ProfilModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dataProfil = new DataProfil.fromJson(json['message']) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.dataProfil!.toJson();
      return data;
  }
}

class DataProfil {
  String? idStaff;
  late String name;
  String? phone;
  String? email;
  String? gender;
  String? address;
  String? isAdmin;
  String? isTentor;
  String? namaCabang;

  DataProfil(
      {this.idStaff,
        required this.name,
        this.phone,
        this.email,
        this.gender,
        this.address,
        this.isAdmin,
        this.isTentor,
        this.namaCabang});

  DataProfil.fromJson(Map<String, dynamic> json) {
    idStaff = json['id_staff'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    address = json['address'];
    isAdmin = json['is_admin'];
    isTentor = json['is_tentor'];
    namaCabang = json['nama_cabang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_staff'] = this.idStaff;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['is_admin'] = this.isAdmin;
    data['is_tentor'] = this.isTentor;
    data['nama_cabang'] = this.namaCabang;
    return data;
  }
}

Future<ProfilModel> loadProfil(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  ProfilModel profil = new ProfilModel.fromJson(jsonResponse);
  return profil;
}