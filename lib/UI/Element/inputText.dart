import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Warna.dart';

// input teks single line
class InputSingleText extends StatefulWidget {
  final TextEditingController? ctrlteks;
  final String? label, hint;
  final TextInputType? tipeInput;
  final int? maxLength;
  final double? size;
  final bool? enable;
  final int? maxLines;

  const InputSingleText(
      {Key? key,
      this.ctrlteks,
      this.label,
      this.tipeInput,
      this.maxLength,
      this.size,
      this.enable,
      this.hint,
      this.maxLines})
      : super(key: key);

  @override
  State<InputSingleText> createState() => _InputSingleTextState();
}

class _InputSingleTextState extends State<InputSingleText> {
  TextEditingController ctrlteks = new TextEditingController();
  late String label, hint;
  late TextInputType tipeInput;
  late int maxLength;
  late int maxLines;
  late double size;
  late bool enable;

  @override
  Widget build(BuildContext context) {
    ctrlteks = widget.ctrlteks ?? new TextEditingController();
    label = widget.label ?? "";
    tipeInput = widget.tipeInput ?? TextInputType.text;
    maxLength = widget.maxLength ?? 100;
    maxLines = widget.maxLines ?? 1;
    size = widget.size ?? 24;
    enable = widget.enable ?? true;
    hint = widget.hint ?? '';

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        enabled: enable,
        controller: ctrlteks,
        maxLines: maxLines,
        keyboardType: tipeInput,
        maxLength: maxLength,
        style: TextStyle(fontSize: size),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

// input teks multi line
class InputMultiText extends StatefulWidget {
  final TextEditingController? ctrlteks;
  final String? label;
  final String? hint;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? enabled;

  const InputMultiText(
      {Key? key,
      this.ctrlteks,
      this.label,
      this.maxLines,
      this.minLines,
      this.maxLength,
      this.enabled,
      this.hint})
      : super(key: key);

  @override
  State<InputMultiText> createState() => _InputMultiTextState();
}

class _InputMultiTextState extends State<InputMultiText> {
  late TextEditingController ctrlteks;
  late String label;
  late String hint;
  late int maxLines;
  late int minLines;
  late int maxLength;
  late bool enabled;

  @override
  Widget build(BuildContext context) {
    ctrlteks = widget.ctrlteks ?? new TextEditingController();
    label = widget.label ?? "";
    hint = widget.hint ?? "";
    maxLines = widget.maxLines ?? 1;
    minLines = widget.minLines ?? 2;
    maxLength = widget.maxLength ?? 100;
    enabled = widget.enabled ?? true;

    minLines >= maxLines ? maxLines = minLines : maxLines = maxLines;

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrlteks,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class InputRupiah extends StatefulWidget {
  final TextEditingController? ctrlteks;
  final String? label;
  final int? maxLength;
  final double? size;
  final bool? enable;

  const InputRupiah(
      {Key? key,
      this.ctrlteks,
      this.label,
      this.maxLength,
      this.size,
      this.enable})
      : super(key: key);

  @override
  State<InputRupiah> createState() => _InputRupiahState();
}

class _InputRupiahState extends State<InputRupiah> {
  late TextEditingController ctrlteks;
  late String label;
  late int maxLength;
  late double size;
  late bool enabled;

  static const _locale = 'id';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    ctrlteks = widget.ctrlteks ?? new TextEditingController();
    label = widget.label ?? "";
    maxLength = widget.maxLength ?? 14;
    size = widget.size ?? 24;
    enabled = widget.enable ?? true;

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        enabled: enabled,
        inputFormatters: [
          // CurrencyTextInputFormatter(
          //   locale: _locale,
          //   decimalDigits: 0,
          //   name: 'Rp ',
          // )
        ],
        controller: ctrlteks,
        maxLength: maxLength,
        style: TextStyle(fontSize: size),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          // prefixText: "Rp ",
          labelText: label,
          border: OutlineInputBorder(),
        ),
        // onChanged: (string) {
        //   string = '${_formatNumber(string.replaceAll(',', ''))}';
        //   // _controller.value = TextEditingValue(
        //   //   text: string,
        //   //   selection: TextSelection.collapsed(offset: string.length),
        //   // );
        // },
      ),
    );
  }
}
