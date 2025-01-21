import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/User.dart';

class ApiService {
  final String baseUrl = "https://randomuser.me/api/";

  Future<List<User>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page&results=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> usersData = data['results'];
      return usersData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
