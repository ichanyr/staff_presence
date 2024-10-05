import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences sharedPrefs;

  static String IDSTAF = 'iduser';
  static String LATITUDE = 'lat';
  static String LONGITUDE = 'long';
  static String IDRS = 'idrs';

  Future<void> onInit() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  /// id user
  String getIdstaf() {
    String? data = sharedPrefs.getString(IDSTAF) ?? '';
    return data;
  }

  Future<bool> setIdstaf(String idstaf) async {
    bool isBerhasil = await sharedPrefs.setString(IDSTAF, idstaf);
    return isBerhasil;
  }

  /// lat long
  String getLat() {
    String? data = sharedPrefs.getString(LATITUDE) ?? '';
    return data;
  }

  Future<bool> setLat(String lat) async {
    bool isBerhasil = await sharedPrefs.setString(LATITUDE, lat);
    return isBerhasil;
  }

  String getLong() {
    String? data = sharedPrefs.getString(LONGITUDE) ?? '';
    return data;
  }

  Future<bool> setLong(String long) async {
    bool isBerhasil = await sharedPrefs.setString(LONGITUDE, long);
    return isBerhasil;
  }

  /// IDRS
  List<String> getIdrs(){
    List<String> data = sharedPrefs.getStringList(IDRS) ?? [];
    return data;
  }

  Future<bool> setIdrs(List<String> idrs)async{
    bool isBerhasil = await sharedPrefs.setStringList(IDRS, idrs);
    return isBerhasil;
  }

  Future<bool> delIdrs()async{
    bool isBerhasil = await sharedPrefs.remove(IDRS);
    return isBerhasil;
  }
}
