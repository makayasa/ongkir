import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controllers/home_controller.dart';
import '../../../../data/models/province_model.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
    required this.tipe,
  }) : super(key: key);

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Province>(
      label: tipe == 'asal' ? 'Provinsi Asal' : 'Provinsi Tujuan',
      hint: 'Provinsi',
      showClearButton: true,
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        hintText: 'Cari Provinsi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      popupItemBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            '${item.province}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
      itemAsString: (Province? item) {
        if (item == null) {
          return '';
        }
        return item.province!;
      },
      onFind: (String? filter) async {
        Uri url = Uri.parse('https://api.rajaongkir.com/starter/province');

        try {
          final response = await http.get(
            url,
            headers: {
              "key": "c45d2ea96f60417ac7d9bc04afa33226",
            },
          );

          var data = json.decode(response.body) as Map<String, dynamic>;

          var statusCode = data['rajaongkir']['status']['code'];

          if (statusCode != 200) {
            throw data['rajaonkir']['status']['description'];
          }

          var listAllProvince = data['rajaongkir']['results'] as List<dynamic>;

          var models = Province.fromJsonList(listAllProvince);
          return models;
        } catch (err) {
          print(err);
          return List<Province>.empty();
        }
      },
      onChanged: (Province? prov) {
        if (prov != null) {
          if (tipe == 'asal') {
            controller.hiddenKotaAsal.value = false;
            controller.provIdAsal.value = int.parse(prov.provinceId!);
          } else {
            controller.hiddenKotaTujuan.value = false;
            controller.provIdTujuan.value = int.parse(prov.provinceId!);
          }
        } else {
          if (tipe == 'asal') {
            print('Tidak memilih provinsi asal apapun');
            controller.hiddenKotaAsal.value = true;
            controller.hiddenProvTujuan.value = true;
            controller.hiddenKotaTujuan.value = true;
            controller.hiddenBerat.value = true;
            controller.hiddenKurir.value = true;
            controller.hiddenButton.value = true;
            controller.provIdAsal.value = 0;
            controller.provIdTujuan.value = 0;
          } else {
            print('Tidak memilih provinsi tujuan apapun');
            controller.hiddenBerat.value = true;
            controller.hiddenKurir.value = true;
            controller.hiddenButton.value = true;
            controller.hiddenKotaTujuan.value = true;
            controller.provIdTujuan.value = 0;
          }
        }
      },
    );
  }
}
