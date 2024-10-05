import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/UI/Element/Chip/ChipFilter.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/assets/TextCustom.dart';

import '../ScrollAndResponsive.dart';
import '../Warna.dart';

class DialogFilter extends StatefulWidget {
  DialogFilter(
      {Key? key,
      required this.tahunTerpilih,
      required this.listTahun,
      required this.listFilter,
      required this.terpilihFilter,
      this.listFilter2,
      this.terpilihFilter2,
      this.isBtnAksiVisible,
      required this.onTapTahun,
      required this.onTapFilter,
       this.onTapFilter2})
      : super(key: key);

  /// chip tahun
  final List<int> listTahun;
  String tahunTerpilih;
  final Function(String value) onTapTahun;

  /// chip filter
  final List<String>? listFilter;
  final Function(String value) onTapFilter;
  String terpilihFilter;

  /// chip filter 2
  List<String>? listFilter2;
  Function(String value)? onTapFilter2;
  String? terpilihFilter2;

  /// aksi
  bool? isBtnAksiVisible;
   VoidCallback? onTapReset = null;
   VoidCallback? onTapTerapkan = null;

  @override
  State<DialogFilter> createState() => _DialogFilterState();
}

class _DialogFilterState extends State<DialogFilter> {
  @override
  Widget build(BuildContext context) {
    return ScrollDenganResponsive(
      child: Container(
        child: Column(
          children: [
            /// Filter
            TextFormatting(
              text: 'Filter',
            ),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip tahun
            ListChip(
              pilihan: widget.listTahun,
              valueTerpilih: widget.tahunTerpilih,
              onTap: (String value) {
                widget.onTapTahun(value);
              },
            ),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip cuti
            ListChip(
              pilihan: widget.listFilter ?? [],
              valueTerpilih: widget.terpilihFilter,
              onTap: (String value) {
                widget.onTapFilter(value);
              },
            ),
            Divider(thickness: 1, height: 30, color: warnaAbu),

            /// chip Filter 2
            Visibility(
              visible:
                  widget.listFilter2 != null && widget.terpilihFilter2 != null,
              child: Column(
                children: [
                  ListChip(
                    pilihan: widget.listFilter2 ?? [''],
                    valueTerpilih: widget.terpilihFilter2 ?? '',
                    onTap: (String value) {
                      widget.onTapFilter2??(value);
                    },
                  ),
                  Divider(thickness: 1, height: 30, color: warnaAbu),
                ],
              ),
            ),

            /// btn Filter
            Visibility(
              visible: widget.isBtnAksiVisible!,
              replacement: ElevatedBtn(
                isPadding: true,
                warnaBtn: warnaPutih,
                warnaTeks: warnaPrimer,
                tekan: () => Get.back(),
                isi: 'Tutup',
              ),
              child: BtnFilterDialog(
                onTapReset: () {
                  widget.onTapReset ?? null;
                },
                onTapTerapkan: () {
                  widget.onTapTerapkan ?? null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
