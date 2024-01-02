import 'package:flutter/material.dart';
import 'package:flutter_authentication/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
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
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                ),
                onTap: () => setState(() {
                  _rememberMe = !_rememberMe;
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  _login();
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform login logic here
      String email = _emailController.text;
      String password = _passwordController.text;

      // You can use the email and password for authentication
      print('Email: $email, Password: $password, Remember: $_rememberMe');

      var result = await AuthRepository.login(email, password);

      if (result?.statusCode == 200) {
        var sp = await SharedPreferences.getInstance();
        if (_rememberMe) {
          sp.setBool("auto_login", true);
        } else {
          sp.setBool("auto_login", false);
        }

        sp.setString("token", result!.body);
        Navigator.pushReplacementNamed(context, "/home");
      }
      // If using a state management solution, you might notify the state about the login action
      // Example using Provider:
      // context.read<AuthState>().login(email, password);
    }
  }
}
