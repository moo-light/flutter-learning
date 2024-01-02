import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_authentication/models/userDto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  static Future<List> getAll() async {
    var sp = await SharedPreferences.getInstance();

    var token = sp.getString("token");

    final Uri apiUrl = Uri.parse('https://localhost:5000/Users');
    var response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sp.getString("token")}'
    });
    if (response.statusCode == 200) {
      var userList = (json.decode(response.body) as List)
          .map((i) => User.fromJson(i))
          .toList();
      return userList;
    }
    if(response.statusCode == 401){
      throw ErrorDescription("Token Expired!");
    }
    return [];
  }
}
