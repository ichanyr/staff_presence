import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_ic_staff/ApiServices/ApiService.dart';
import 'package:presensi_ic_staff/Helper/SharedPref.dart';
import 'package:presensi_ic_staff/UI/Element/Model/ButtonModel.dart';
import 'package:presensi_ic_staff/UI/Element/Warna.dart';
import 'package:presensi_ic_staff/UI/Element/button.dart';
import 'package:presensi_ic_staff/UI/Element/inputText.dart';
import 'package:presensi_ic_staff/UI/Element/textView.dart';
import 'package:presensi_ic_staff/UI/Riwayat/Controller/DetailRiwayatController.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/detailRiwayat.dart';
import 'package:presensi_ic_staff/UI/Riwayat/model/todo.dart';

import '../../Element/dialogBox.dart';

class TodoController extends GetxController with StateMixin<TodoAct> {
  Rx<String> inputan = ''.obs;
  Rx<TextEditingController> inputCtrl = TextEditingController().obs;
  Rx<String> idstaf = ''.obs;
  Rx<String> todo = ''.obs;
  Rx<bool> hapusTodo = false.obs;
  Rx<String> sttus = 'n'.obs;
  Rx<String> idtodo = ''.obs;
  Rx<bool> isEdit = false.obs;
  Rx<bool> isHapus = false.obs;
  Rx<Widget> iconAksi = Icon(Icons.check_circle, color: warnaPutih).obs;
  DetailRiwayatController drCtrl = Get.put(DetailRiwayatController());

  Rx<DetailRiwayat> dataDetail =
      DetailRiwayat(status: false, listTodo: [], message: '', listDataDetailRiwayat: []).obs;
  Rx<String> idriwayat = ''.obs;

  /// shared pref
  SharedPref sp = SharedPref();

  onInit() async {
    super.onInit();

    await sp.onInit();
    idstaf.value = sp.getIdstaf();
  }

  insertTodo({required BuildContext ctx, bool isInsert = true}) {
    isInsert == true ? inputCtrl.value.text = '' : inputCtrl = inputCtrl;
    dialogBoxWidget(
        context: ctx,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // inputan todo
            InputSingleText(
              ctrlteks: inputCtrl.value,
              maxLines: 3,
              maxLength: 100,
              label: isInsert == true ? 'Tambah' : 'Ubah aktivitas',
              hint: isInsert == true ? 'Tambah aktivitas' : 'Ubah aktivitas',
              tipeInput: TextInputType.text,
            ),

            // btn action
            Row(
              children: [
                // btn batal
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: ElevatedBtn(
                      isi: 'Batal',
                      bentuk: BentukBtnModel(BentukBtnModels.stadium),
                      isPadding: false,
                      isMargin: false,
                      warnaBtn: warnaPutih,
                      warnaTeks: warnaBiru,
                      tekan: () => Get.back(),
                    ),
                  ),
                ),

                // btn simpan
                Flexible(
                  flex: 1,
                  child: ElevatedBtn(
                    isi: 'Simpan',
                    bentuk: BentukBtnModel(BentukBtnModels.stadium),
                    isPadding: false,
                    isMargin: false,
                    tekan: () async {
                      if (isInsert == true) {
                        await fnInsertTodo();
                      } else {
                        await fnUpdateTodo();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }

  dialogHapusTodo({required BuildContext context, required String isiTodo}) {
    dialogBoxWidget(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title
            Text('Apakah anda yakin untuk menghapus todo "$isiTodo" ?'),

            // btn action
            SizedBox(height: 20),
            Row(
              children: [
                // btn batal
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: ElevatedBtn(
                      isi: 'Tidak, Jangan hapus',
                      bentuk: BentukBtnModel(BentukBtnModels.stadium),
                      isPadding: false,
                      isMargin: false,
                      warnaBtn: warnaPutih,
                      warnaTeks: warnaBiru,
                      tekan: () => Get.back(),
                    ),
                  ),
                ),

                // btn Hapus
                Flexible(
                  flex: 1,
                  child: ElevatedBtn(
                    isi: 'Ya, Hapus',
                    bentuk: BentukBtnModel(BentukBtnModels.stadium),
                    isPadding: false,
                    isMargin: false,
                    warnaBtn: warnaMerah,
                    tekan: () {
                      fnHapusTodo();
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Future<void> fnInsertTodo() async {
    // cek inputan kosong tidak
    if (idstaf.value != '' || inputCtrl.value.text != '') {
      // TodoAct fTodo = await ApiService()
      //     .postTodo_v2(idstaf: idstaf.value, todo: inputCtrl.value.text);
      TodoAct fTodo =
          await fnPisahInsertTodo(todoActPostTypes: TodoActPostTypes.post);
      change(fTodo, status: RxStatus.loading());
      // berhasil insert
      if (fTodo.status == true) {
        change(fTodo, status: RxStatus.success());
        Get.back();
        Get.snackbar('Berhasil', 'Insert todo berhasil',
            duration: Duration(seconds: 2), backgroundColor: warnaBiru);
        inputCtrl.value.text = '';
        drCtrl.loadDetailRiwayat();
      }

      // insert todo gagal
      else {
        change(fTodo, status: RxStatus.error(fTodo.message));
        Get.back();
        Get.snackbar('Gagal', 'Insert todo gagal : ${fTodo.message}',
            backgroundColor: warnaMerah, duration: Duration(seconds: 2));
      }
    }

    // inputan kosong
    else {
      Get.snackbar('Input todo belum diisi', '',
          backgroundColor: warnaMerah, duration: Duration(seconds: 2));
    }
  }

  Future<void> fnUpdateTodo() async {
    // cek inputan kosong tidak
    if (idstaf.value != null ||
        idstaf.value != '' ||
        inputCtrl.value.text != null ||
        inputCtrl.value.text != '') {
      TodoAct fTodo =
          await fnPisahInsertTodo(todoActPostTypes: TodoActPostTypes.put);
      change(fTodo, status: RxStatus.loading());
      // berhasil update
      if (fTodo.status == true) {
        change(fTodo, status: RxStatus.success());
        Get.back();
        Get.snackbar('Berhasil', 'Update todo berhasil',
            duration: Duration(seconds: 2), backgroundColor: warnaBiru);
        inputCtrl.value.text = '';
        drCtrl.loadDetailRiwayat();
      }

      // insert todo gagal
      else {
        change(fTodo, status: RxStatus.error(fTodo.message));
        Get.back();
        Get.snackbar('Gagal', 'Update todo gagal : ${fTodo.message}',
            backgroundColor: warnaMerah, duration: Duration(seconds: 2));
      }
    }

    // inputan kosong
    else {
      Get.snackbar('Input todo belum diisi', '',
          backgroundColor: warnaMerah, duration: Duration(seconds: 2));
    }
  }

  void fnHapusTodo() async {
    // cek inputan kosong tidak
    if (idstaf.value != null ||
        idstaf.value != '' ||
        inputCtrl.value.text != null ||
        inputCtrl.value.text != '') {
      TodoAct fTodo =
          await fnPisahInsertTodo(todoActPostTypes: TodoActPostTypes.delete);
      change(fTodo, status: RxStatus.loading());
      // berhasil update
      if (fTodo.status == true) {
        change(fTodo, status: RxStatus.success());
        Get.back();
        Get.snackbar('Berhasil', 'Hapus todo berhasil',
            duration: Duration(seconds: 2), backgroundColor: warnaBiru);
        inputCtrl.value.text = '';
        isHapus.value = false;
        isEdit.value = false;
        drCtrl.loadDetailRiwayat();
      }

      // insert todo gagal
      else {
        change(fTodo, status: RxStatus.error(fTodo.message));
        Get.back();
        Get.snackbar('Gagal', 'Hapus todo gagal : ${fTodo.message}',
            backgroundColor: warnaMerah, duration: Duration(seconds: 2));
      }
    }

    // inputan kosong
    else {
      Get.snackbar('Hapus todo gagal', '',
          backgroundColor: warnaMerah, duration: Duration(seconds: 2));
    }
  }

  void fnOnTapTodo(
      {String? idtodos,
      String? statusAsal,
      required BuildContext context,
      required String isian}) {
    idtodo.value = idtodos ?? '';

    if (statusAsal == 'y') {
      sttus.value = 'n';
    } else {
      sttus.value = 'y';
    }

    // cek inputan kosong tidak
    if (idstaf.value != '' || idtodos != null || idtodos != '') {
      // cek apakah state edit todo
      if (isEdit.value == true) {
        if (statusAsal == 'n') {
          insertTodo(ctx: context, isInsert: false);
          inputCtrl.value.text = isian;
        } else {
          dialogBox(
              judul: 'Tidak bisa diubah',
              isi:
                  'Aktifitas ini tidak bisa diubah karena telah ditandai selesai. '
                  'Jika ingin mengubah, Silahkan tandai sebagai belum selesai.',
              context: context,
              btn1: 'OK',
              fnBtn1: () => Get.back(),
              warnaBtn1: warnaPrimer,
              warnaTeksBtn1: warnaPutih);
        }
      }

      // cek apakah state hapus todo
      else if (isHapus.value == true) {
        if (statusAsal == 'n') {
          inputCtrl.value.text = '';
          dialogHapusTodo(context: context, isiTodo: isian);
        } else {
          dialogBox(
              judul: 'Tidak bisa dihapus',
              isi:
                  'Aktifitas ini tidak bisa dihapus karena telah ditandai selesai. '
                  'Jika ingin menghapus, Silahkan tandai sebagai belum selesai.',
              context: context,
              btn1: 'OK',
              fnBtn1: () => Get.back(),
              warnaBtn1: warnaPrimer,
              warnaTeksBtn1: warnaPutih);
        }
      }

      // update todo Biasa
      else {
        inputCtrl.value.text = '';
        Future<TodoAct> fTodo =
            fnPisahInsertTodo(todoActPostTypes: TodoActPostTypes.putStatus);
        fTodo.then((value) {
          change(value, status: RxStatus.loading());
          // berhasil update
          if (value.status == true) {
            change(value, status: RxStatus.success());
            // Get.back();
            Get.snackbar('Berhasil', 'Update todo berhasil',
                duration: Duration(seconds: 2), backgroundColor: warnaBiru);
            Get.reloadAll();
          }

          // update gagal
          else {
            change(value, status: RxStatus.error(value.message));
            Get.back();
            Get.snackbar('Gagal', 'Update todo gagal : ${value.message}',
                backgroundColor: warnaMerah, duration: Duration(seconds: 2));
          }
        });
      }
    }

    // inputan kosong
    else {
      Get.snackbar('Input todo belum diisi', '',
          backgroundColor: warnaMerah, duration: Duration(seconds: 2));
    }
  }

  Future<TodoAct> fnPisahInsertTodo({required TodoActPostTypes todoActPostTypes}) async {
    TodoAct fTodo;
    switch (todoActPostTypes) {
      /// post
      case TodoActPostTypes.post:
        fTodo = await ApiService().postTodo_v2(
            idstaf: idstaf.value, todo: inputCtrl.value.text, tipe: 1);
        break;
      // put
      case TodoActPostTypes.put:
        fTodo = await ApiService().postTodo_v2(
            id: idtodo.value, todo: inputCtrl.value.text, tipe: 2, status: 'n', idstaf: idstaf.value);
        break;
      // delete
      case TodoActPostTypes.delete:
        fTodo = await ApiService()
            .postTodo_v2(id: idtodo.value, hapus: true, tipe: 3, idstaf: idstaf.value);
        break;
      // put status
      case TodoActPostTypes.putStatus:
        fTodo = await ApiService()
            .postTodo_v2(id: idtodo.value, status: sttus.value, tipe: 4, idstaf: idstaf.value);
        break;
    }

    return fTodo;
  }

  // ubah state edit
  void fnUbahIsEdit() {
    // bool temp = isEdit.value;
    isEdit.value = !isEdit.value;

    iconTodo();
    update();
  }

  // ubah state hapus
  void fnUbahIsHapus() {
    isHapus.value = !isHapus.value;
    iconTodo();
    // update();
  }

  void iconTodo() {
    // ubah icon
    if (sttus.value == 'n') {
      if (isEdit.value == true) {
        isHapus.value = false;
        iconAksi.value = Icon(Icons.edit, color: warnaBiru);
      }
      if (isHapus.value == true) {
        isEdit.value = false;
        iconAksi.value = Icon(Icons.delete, color: warnaMerah);
      }

      if (isEdit.value == false && isHapus.value == false) {
        isEdit.value = false;
        isHapus.value = false;
        iconAksi.value = Icon(Icons.check, color: warnaPutih);
      }
    }
    Get.reload();
    update();
  }
}
