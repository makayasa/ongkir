import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse('https://api.rajaongkir.com/starter/cost');
  // final response = await http.get(
  //   url,
  //   headers: {
  //     "key": "c45d2ea96f60417ac7d9bc04afa33226",
  //   },
  // );
  final response = await http.post(url, headers: {
    'content-type': 'application/x-www-form-urlencoded',
    "key": "c45d2ea96f60417ac7d9bc04afa33226",
  }, body: {
    'origin': '501',
    'destination': '114',
    'weight': '1700',
    'courier': 'jne'
  });
  print(response.body);
}
