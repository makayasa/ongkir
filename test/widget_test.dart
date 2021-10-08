import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  // Uri url = Uri.parse('https://api.rajaongkir.com/starter/cost');
  Uri url = Uri.parse('http://localhost:8080/api/barang/');
  Uri urlDelete = Uri.parse('http://localhost:8080/api/barang/2');
  // Uri url = Uri.parse('http://localhost:8080/api/products');
  // final response = await http.get(
  //   url,
  //   headers: {
  //     "key": "c45d2ea96f60417ac7d9bc04afa33226",
  //   },
  // );

  final post = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(<String, dynamic>{"name": "Fanta", "jenis": "Minuman", "harga": 5000}),
  );

  final delete = await http.delete(urlDelete);

  // final get = await http.get(url);
  // print(get.body);
  print(post.body);
  print(delete.body);
}
