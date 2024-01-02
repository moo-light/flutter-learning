// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static Future<Response?> login(String email, String password) async {
    final Uri apiUrl = Uri.parse(
        'https://localhost:5000/Login?email=$email&password=$password');
    try {
      final response = await http.get(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successful login
        print('Login successful');
        print('Response: ${response.body}');
        return response;
      } else {
        // Handle errors, e.g., show an error message
        print('Login failed. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        return response;
      }
    } catch (error) {
      // Handle other errors, e.g., connection issues
      print('Error: $error');
    }
    return null;
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final Uri apiUrl = Uri.parse('https://localhost:5000/Authenticated');
    var sp = await SharedPreferences.getInstance();
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sp.getString("token")}'
      },
    );

    if (response.statusCode == 200) {
      // Successful login
      try {
        var user = jsonDecode(response.body);
        return user;
      } catch (error) {
        print(error);
        throw Error();
      }
    } else if (response.statusCode == 401) {
      // Handle unauthorized access (e.g., token expired)
      // You can navigate to the login screen or take appropriate action
      throw Error();
    } else {
      // Handle other error cases
      throw Error();
    }
  }

  static Future<dynamic> tryAutoLogin() async {
    // await Future.delayed(Duration(seconds: 5), () {
    //   // This function will be called after 5 seconds
    //   print('Performing action after 5 seconds');
    //   // Add your desired action here
    // });
    var sp = await SharedPreferences.getInstance();
    if (sp.getBool("auto_login") == true) {
      final Uri apiUrl = Uri.parse('https://localhost:5000/Authenticated');
      final response = await http.get(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sp.getString("token")}'
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 401) {
        return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> register(
      String email, String password, String name, String role) async {
    final Uri apiUrl = Uri.parse('https://localhost:5000/register');
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'role': role,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
