import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onkir/app/data/models/courier_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  var hiddenKotaAsal = true.obs;
  var provIdAsal = 0.obs;
  var kotaIdAsal = 0.obs;

  var hiddenProvTujuan = true.obs;
  var hiddenKotaTujuan = true.obs;
  var provIdTujuan = 0.obs;
  var kotaIdTujuan = 0.obs;

  var hiddenBerat = true.obs;

  var hiddenKurir = true.obs;
  var idKurir = ''.obs;

  var hiddenButton = true.obs;

  double berat = 0.0;
  String satuan = 'gram';
  late TextEditingController beratC;

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekStauan = satuan;
    switch (cekStauan) {
      case 'ton':
        berat = berat * 1000000;
        break;
      case 'kwintal':
        berat = berat * 100000;
        break;
      case 'ons':
        berat = berat * 100;
        break;
      case 'gram':
        berat = berat;
        break;
      case 'kg':
        berat = berat * 1000;
        break;
      default:
        berat = berat;
    }
    print('$berat gram');
  }

  void ubahSatuan(String value) {
    berat = double.tryParse(beratC.text) ?? 0.0;

    switch (value) {
      case 'ton':
        berat = berat * 1000000;
        break;
      case 'kwintal':
        berat = berat * 100000;
        break;
      case 'ons':
        berat = berat * 100;
        break;
      case 'gram':
        berat = berat;
        break;
      case 'kg':
        berat = berat * 1000;
        break;
      default:
        berat = berat;
    }
    satuan = value;
    print('$berat gram');
  }

  void ongkosKirim() async {
    Uri url = Uri.parse('https://api.rajaongkir.com/starter/cost');
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/x-www-form-urlencoded',
          "key": "c45d2ea96f60417ac7d9bc04afa33226",
        },
        body: {
          'origin': '$kotaIdAsal',
          'destination': '$kotaIdTujuan',
          'weight': '$berat',
          'courier': '$idKurir',
        },
      );
      var data = json.decode(response.body) as Map<String, dynamic>;
      var result = data['rajaongkir']['results'] as List<dynamic>;

      var listAllCourier = Courier.fromJsonList(result);
      var courier = listAllCourier[0];
      // print(data);
      print(listAllCourier[0]);

      Get.defaultDialog(
        title: courier.name!,
        content: Column(
          children: courier.costs!
              .map((e) => ListTile(
                    title: Text('${e.service}'),
                    subtitle: Text('${e.cost![0].value}'),
                    trailing: Text(courier.code == "pos" ? '${e.cost![0].etd}' : '${e.cost![0].etd} hari'),
                  ))
              .toList(),
        ),
      );
    } catch (err) {
      print(err);
      Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: err.toString(),
      );
    }
  }

  @override
  void onInit() {
    beratC = TextEditingController(text: '${berat}');
    super.onInit();
  }

  @override
  void onClose() {
    beratC.dispose();
    super.onClose();
  }
}
