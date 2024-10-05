import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:presensi_ic_staff/Helper/FilterString.dart';
import 'package:presensi_ic_staff/assets/ukuran.dart';
import '../UI/Element/Warna.dart';

enum FormatTeks { Title, Subtitle, H1, H2, H3, H4, H5, H6, paragraph }

class FormatTek {
  final FormatTeks formatTek;

  FormatTek(this.formatTek);
}

class TextCustom extends StatefulWidget {
  final Color? color;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const TextCustom(
      {Key? key,
      this.color,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.overflow})
      : super(key: key);

  @override
  State<TextCustom> createState() => _TextCustomState();
}

class _TextCustomState extends State<TextCustom> {
  late Color color;
  late String text;
  late double fontSize;
  late FontWeight fontWeight;
  late TextAlign textAlign;
  late TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    color = widget.color ?? warnaHitamTxt;
    text = widget.text ?? '';
    fontSize = widget.fontSize ?? fontDefaultSize;
    fontWeight = widget.fontWeight ?? FontWeight.normal;
    textAlign = widget.textAlign ?? TextAlign.start;
    overflow = widget.overflow ?? TextOverflow.visible;

    return Container(
      child: Text(text,
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
            fontFamily: 'Nunito-sans',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          )),
    );
  }
}

class TextFormatting extends StatefulWidget {
  final TextAlign? textAlign;
  final String text;
  final TextOverflow? overflow;
  final FormatTeks? formatTek;
  final Color? color;
  final FontWeight? fontWeight;

  const TextFormatting(
      {Key? key,
      this.textAlign,
      required this.text,
      this.overflow,
      this.formatTek,
      this.color,
      this.fontWeight})
      : super(key: key);

  @override
  State<TextFormatting> createState() => _TextFormattingState();
}

class _TextFormattingState extends State<TextFormatting> {
  late TextAlign textAlign;
  late String text;
  late TextOverflow overflow;
  late double fontSize;
  late FontWeight fontWeight;
  late FormatTeks formatTek;
  late Color color;

  /// Filter String
  FilterString filterString = FilterString();

  @override
  Widget build(BuildContext context) {
    textAlign = widget.textAlign ?? TextAlign.start;
    text = widget.text ?? '';
    overflow = widget.overflow ?? TextOverflow.ellipsis;
    formatTek = widget.formatTek ?? FormatTeks.H5;
    fontSize = DefineFormatTeks.fontSize(formatTek: formatTek).fontSize;
    fontWeight = widget.fontWeight ??
        DefineFormatTeks.fontWeight(formatTek: formatTek).fontWeight;
    color = widget.color ?? warnaHitam;

    /// cek warna filterString
    color = filterString.filterStringColor(
        typeFilterStrings: TypeFilterStrings.KurungSiku,
        string: text,
        warnaAsli: color);

    return Text(text,
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
            fontFamily: 'Nunito-sans',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ));
  }
}

class DefineFormatTeks {
  late double fontSize;
  late FontWeight fontWeight;
  late final FormatTeks formatTek;

  DefineFormatTeks({required this.formatTek});

  DefineFormatTeks.fontSize({required this.formatTek}) {
    // FormatTek formatTek;
    switch (formatTek) {
      case FormatTeks.Title:
        fontSize = 32;
        break;
      case FormatTeks.Subtitle:
        fontSize = 30;
        break;
      case FormatTeks.H1:
        fontSize = 26;
        break;
      case FormatTeks.H2:
        fontSize = 24;
        break;
      case FormatTeks.H3:
        fontSize = 22;
        break;
      case FormatTeks.H4:
        fontSize = 20;
        break;
      case FormatTeks.H5:
        fontSize = 18;
        break;
      case FormatTeks.H6:
        fontSize = 16;
        break;
      case FormatTeks.paragraph:
        fontSize = 20;
        break;

      default:
        fontSize = 18;
        break;
    }
  }

  DefineFormatTeks.fontWeight({required this.formatTek}) {
    // FormatTek formatTek;
    switch (formatTek) {
      case FormatTeks.Title:
        fontWeight = FontWeight.bold;
        break;
      case FormatTeks.Subtitle:
        fontWeight = FontWeight.bold;
        break;
      case FormatTeks.H1:
        fontWeight = FontWeight.bold;
        break;
      case FormatTeks.H2:
        fontWeight = FontWeight.w800;
        break;
      case FormatTeks.H3:
        fontWeight = FontWeight.w700;
        break;
      case FormatTeks.H4:
        fontWeight = FontWeight.w600;
        break;
      case FormatTeks.H5:
        fontWeight = FontWeight.w500;
        break;
      case FormatTeks.H6:
        fontWeight = FontWeight.w400;
        break;
      case FormatTeks.paragraph:
        fontWeight = FontWeight.normal;
        break;

      default:
        fontWeight = FontWeight.normal;
        break;
    }
  }
}
