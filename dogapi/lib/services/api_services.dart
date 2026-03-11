import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dogapi/models/dog.dart';

class ApiService {
  static const String baseUrl = 'https://dog.ceo/api/breeds';

  Future<Dog> getRandomDogs() async {
    final response = await http.get(Uri.parse('$baseUrl/image/random'));
    final data = json.decode(response.body);
    // return List<Map<String, dynamic>>.from(data['message']);
    return Dog.fromJson(data);
  }
}
