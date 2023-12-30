// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'package:flutter/material.dart';
import 'package:todo_application_repository_pattern/daos/user_repository.dart';
import 'package:todo_application_repository_pattern/dtos/user_model.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<UpdateUser> {
  String? _name;

  String? _email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _id;

  @override
  Widget build(BuildContext context) {
    var userRepository = UserRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User '),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your Id',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Id';
                }
                try {
                  var id = int.parse(value);
                } catch (e) {
                  return 'Id must be a number';
                }
                return null;
              },
              onSaved: (value) {
                try {
                  _id = int.parse(value!);
                } catch (e) {}
              },
              controller: TextEditingController(
                text: _name
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            var user = UserModel(_id!, _name!, _email!);
            try {
              await userRepository.createUser(user);
              Navigator.pop(context);
            } catch (e) {
              print(e);
            }
          }
          ;
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
