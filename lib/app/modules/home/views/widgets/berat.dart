import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class BeratBarang extends GetView<HomeController> {
  const BeratBarang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autocorrect: false,
            controller: controller.beratC,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Berat Barang',
              hintText: 'Berat Barang',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              controller.ubahBerat(value);
              controller.hiddenKurir.value = false;
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 150,
          child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            label: "Satuan",
            // hint: "Satuan",
            showSelectedItem: true,
            showSearchBox: true,
            searchBoxDecoration: InputDecoration(
              hintText: 'Cari satuan berat',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: ['gram', 'kg'],
            popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: (String? berat) {
              if (berat != null) {
                controller.ubahSatuan(berat);
              }
            },
            selectedItem: "gram",
          ),
        )
      ],
    );
  }
}
