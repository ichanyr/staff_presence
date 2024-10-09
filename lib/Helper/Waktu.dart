import 'package:intl/intl.dart';

enum TipeWaktus { LongDate, OnlyTimeShort}

class WaktuHelper {
  String dateToString({required String waktu, TipeWaktus? tipeWaktus}) {
    late String formatWaktu;

    switch (tipeWaktus) {
      case TipeWaktus.LongDate:
        formatWaktu = 'dd MMMM yyyy';
        break;

      case TipeWaktus.OnlyTimeShort:
        formatWaktu = 'HH:mm';
        break;
      default:
        formatWaktu = 'dd MMMM yyyy';
        break;
    }

    DateTime dtPM = DateTime.parse(waktu);
    DateFormat formatter = DateFormat(formatWaktu);
    String tglString = formatter.format(dtPM);

    return tglString;
  }
}
