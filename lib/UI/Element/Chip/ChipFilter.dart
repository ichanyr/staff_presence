import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/ButtonModel.dart';
import '../Warna.dart';
import '../button.dart';
import '../textView.dart';

class ListChip extends StatefulWidget {
  ListChip(
      {Key? key,
      required this.valueTerpilih,
      required this.pilihan,
      required this.onTap})
      : super(key: key);

  final List<dynamic> pilihan;
  String valueTerpilih;
  final Function(String value) onTap;

  @override
  State<ListChip> createState() => _ListChipState();
}

class _ListChipState extends State<ListChip> {
  int tahunSekarang = DateTime.now().year;

  // Set<int> pilihanTahun = <int>{2022, 2021, 2020, 2019};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.pilihan
          .map(
            (e) => Container(
              margin: EdgeInsets.all(10),
              child: ChoiceChip(
                backgroundColor: warnaPutih,
                elevation: 2,
                pressElevation: 5,
                selectedColor: warnaBiru,
                padding: EdgeInsets.all(15),
                label: TextIsi2(
                  isi: e.toString(),
                  warna: warnaHitam,
                ),
                selected: widget.valueTerpilih == e.toString(),
                onSelected: (_) {
                  setState(() => widget.valueTerpilih = e.toString());
                  widget.onTap(e.toString());
                },
              ),
            ),
          )
          .toList(),
      spacing: 5,
    );
  }
}
