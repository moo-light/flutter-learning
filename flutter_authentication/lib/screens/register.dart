import 'package:flutter/material.dart';
import 'package:flutter_authentication/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: "User Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: "User Password"),
                obscureText: true, // Hide entered text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: "User Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(hintText: "User Role"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Role';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform register logic here
      String email = _emailController.text;
      String password = _passwordController.text;
      String name = _nameController.text;
      String role = _roleController.text;

      // You can use the email and password for authentication

      var result = await AuthRepository.register(email, password, name, role);

      if (result == true) {
        var response = await AuthRepository.login(email, password);
        if (response!.statusCode == 200) {
          var sp =await  SharedPreferences.getInstance();
          sp.setString("token", response.body);
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    }
  }
}
