import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> predictDiabetes({
    required int age,
    required double bmi,
    required double glucose,
    required double bp,
  }) async {
    final url = Uri.parse('http://<IP_KOMPUTER>:5000/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'age': age, 'bmi': bmi, 'glucose': glucose, 'bp': bp}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['result'];
    } else {
      throw Exception('Gagal mengambil prediksi');
    }
  }
}
