import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onkir/app/modules/home/views/widgets/berat.dart';

import '../views/widgets/province.dart';
import '../views/widgets/city.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Provinsi(
            tipe: 'asal',
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => controller.hiddenKotaAsal.isTrue
                ? SizedBox()
                : Kota(
                    tipe: 'asal',
                    provId: controller.provIdAsal.value,
                  ),
          ),
          Obx(() => controller.hiddenProvTujuan.isTrue
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    color: Colors.black,
                  ),
                )),
          Obx(
            () => controller.hiddenProvTujuan.isTrue
                ? SizedBox()
                : Provinsi(
                    tipe: 'tujuan',
                  ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => controller.hiddenKotaTujuan.isTrue
                ? SizedBox()
                : Kota(
                    tipe: 'tujuan',
                    provId: controller.provIdTujuan.value,
                  ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => controller.hiddenBerat.isTrue ? SizedBox() : BeratBarang(),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() => controller.hiddenKurir.isTrue
              ? SizedBox()
              : DropdownSearch<Map<String, dynamic>>(
                  mode: Mode.MENU,
                  label: "Tipe Kurir",
                  hint: "Tipe Kurir",
                  // showSelectedItem: true,
                  showClearButton: true,
                  items: [
                    {
                      "code": "jne",
                      "name": "Jalur Nugraha Ekakurir (JNE)",
                    },
                    {
                      "code": "tiki",
                      "name": "Titipan Kilat (TIKI)",
                    },
                    {
                      "code": "pos",
                      "name": "POS Indonesia",
                    },
                  ],
                  itemAsString: (item) {
                    return "${item['name']}";
                  },
                  popupItemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        "${item['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                  onChanged: (value) {
                    if (value != null) {
                      if (controller.kotaIdAsal != 0 && controller.kotaIdTujuan != 0 && controller.berat > 0) {
                        controller.hiddenButton.value = false;
                        controller.idKurir.value = '${value['code']}';
                      }
                    } else {
                      controller.hiddenButton.value = true;
                    }
                  },
                )),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => controller.hiddenButton.isTrue
                ? SizedBox()
                : ElevatedButton(
                    child: Text('Cek Ongkos Kirim'),
                    onPressed: () {
                      controller.ongkosKirim();
                    },
                  ),
          )
        ],
      ),
    );
  }
}
