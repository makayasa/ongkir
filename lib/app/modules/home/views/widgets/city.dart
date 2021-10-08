import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controllers/home_controller.dart';
import '../../../../data/models/city_model.dart';

class Kota extends GetView<HomeController> {
  const Kota({Key? key, required this.provId, required this.tipe}) : super(key: key);

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<City>(
      label: tipe == 'asal' ? 'Kota/Kabupaten asal' : 'Kota/Kabupaen tujuan',
      hint: 'Kota/Kabupaten',
      showClearButton: true,
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        hintText: 'Cari Kota/Kabupaten',
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
            '${item.type} ${item.cityName}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
      itemAsString: (City? item) {
        if (item == null) {
          return '';
        }
        return '${item.type} ${item.cityName}';
      },
      onFind: (String? filter) async {
        Uri url = Uri.parse('https://api.rajaongkir.com/starter/city?province=$provId');

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

          var listAllCity = data['rajaongkir']['results'] as List<dynamic>;

          var models = City.fromJsonList(listAllCity);
          return models;
        } catch (err) {
          print(err);
          return List<City>.empty();
        }
      },
      onChanged: (City? kota) {
        if (kota != null) {
          if (tipe == 'asal') {
            controller.kotaIdAsal.value = int.parse(kota.cityId!);
            controller.hiddenProvTujuan.value = false;
            print('id kota asal adalah ${controller.kotaIdAsal.value}');
          } else {
            controller.kotaIdTujuan.value = int.parse(kota.cityId!);
            controller.hiddenBerat.value = false;
            print('id kota tujuan adalah ${controller.kotaIdTujuan.value}');
            // controller.hiddenProvTujuan.value = true;
          }
        } else {
          if (tipe == 'asal') {
            print('TIdak memilih kota/kabupaten asal apapun');
            controller.hiddenKotaTujuan.value = true;
            controller.hiddenProvTujuan.value = true;
            controller.hiddenBerat.value = true;
            controller.hiddenKurir.value = true;
            controller.hiddenButton.value = true;
            controller.kotaIdAsal.value = 0;
          } else {
            print('Tidak memilih kota/kabupaten tujuan apapun');
            controller.hiddenBerat.value = true;
            controller.hiddenKurir.value = true;
            controller.hiddenButton.value = true;
            controller.hiddenKotaTujuan.value = false;
            controller.kotaIdTujuan.value = 0;
          }
        }
      },
    );
  }
}
