// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import '../dtos/user_model.dart' show UserModel;

class UserRepository {
  late List<UserModel?> users = [];
  late String filename;

  // Factory constructor for asynchronous initialization
  factory UserRepository() {
    return UserRepository._();
  }

  UserRepository._() {
    filename = 'assets/users.json';
    File(filename).exists().then((value) => print(value));
    _initializeUsers();
  }

  // Initialization method
  Future<void> _initializeUsers() async {
    users = await readUsersFromFile(filename);
  }

  Future<List<UserModel?>> getAllUsers() async {
    users = await readUsersFromFile(filename);
    return users;
  }

  Future<UserModel?> getUserByID(int id) async {
    users = await readUsersFromFile(filename);
    return users.cast<UserModel?>().firstWhere((user) => user?.id == id,orElse: () => null,);
  }

  Future<void> createUser(UserModel user) async {
    var curUser = await getUserByID(user.id);
    if (curUser != null) throw ArgumentError("Id Exist!");
    users.add(user);
    await saveUsersToFile(filename, users);
    print("Create Success");
  }

  Future<void> updateUser(int id, UserModel user) async {
    var curUser = await getUserByID(id);
    if (curUser != null) {
      curUser.email = user.email;
      curUser.name = user.name;
      await saveUsersToFile(filename, users);
    }
  }

  Future<void> removeUser(int id) async {
    var curUser = await getUserByID(id);
    if (curUser != null) {
      users.remove(curUser);
      await saveUsersToFile(filename, users);
    }
  }

  Future<List<UserModel?>> readUsersFromFile(String filename) async {
    try {
      File file = File(filename);
      String contents = await file.readAsString();
      List<dynamic> jsonList = json.decode(contents);

      List<UserModel> users =
          jsonList.map((json) => UserModel.fromJson(json)).toList();
      return users;
    } catch (e) {
      // Handle read file error, e.g., file not found or invalid format
      print("Error reading file: $e");
      return [];
    }
  }

  Future<void> saveUsersToFile(String filename, List<UserModel?> users) async {
    try {
      File file = File(filename);
      List<Map<String, dynamic>> jsonList =
          users.map((user) => user!.toJson()).toList();
      String jsonString = json.encode(jsonList);

      await file.writeAsString(jsonString);
    } catch (e) {
      // Handle save file error, e.g., permission issues
      print("Error saving file: $e");
    }
  }
}
