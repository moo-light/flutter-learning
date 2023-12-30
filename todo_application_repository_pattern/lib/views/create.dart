// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'package:flutter/material.dart';
import 'package:todo_application_repository_pattern/daos/user_repository.dart';
import 'package:todo_application_repository_pattern/dtos/user_model.dart';

class CreateUser extends StatefulWidget {
  int? id;

  CreateUser({super.key});
  CreateUser.edit({super.key, required this.id});
  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEdit = false;
  late UserRepository userRepository;
  late TextEditingController _id;
  late TextEditingController _name;
  late TextEditingController _email;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    _id = TextEditingController();
    _name = TextEditingController();
    _email = TextEditingController();
    if (widget.id != null) {
      isEdit = true;
      userRepository.getUserByID(widget.id!).then((user) {
        if (user == null) throw ErrorDescription("Edit User Not found!");
        setState(() {
          _id.text = user.id.toString();
          _name.text = user.name;
          _email.text = user.email;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${!isEdit ? 'Create' : 'Update'} User'),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _id,
              decoration: const InputDecoration(
                labelText: 'Enter your Id',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Id';
                }
                try {
                  int.parse(value);
                } catch (e) {
                  return 'Id must be a number';
                }
                return null;
              },
              readOnly: isEdit,
              onSaved: (value) {
                try {
                  int.parse(value!);
                  _id.text = value;
                } catch (e) {}
              },
            ),
            TextFormField(
              controller: _name,
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
                _name.text = value!;
              },
            ),
            TextFormField(
              controller: _email,
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
                _email.text = value!;
              },
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            var user =
                UserModel(int.parse(_id.text), _name.text!, _email.text!);
            try {
              if (isEdit) {
                userRepository
                    .updateUser(widget.id!, user)
                    .then((value) => Navigator.pop(context));
              } else {
                userRepository
                    .createUser(user)
                    .then((value) => Navigator.pop(context));
              }
            } catch (e) {}
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
