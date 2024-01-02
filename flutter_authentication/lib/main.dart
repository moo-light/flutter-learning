import 'package:flutter/material.dart';
import 'package:flutter_authentication/repositories/auth_repository.dart';
import 'package:flutter_authentication/screens/home.dart';
import 'package:flutter_authentication/screens/login.dart';
import 'package:flutter_authentication/screens/register.dart';
import 'package:flutter_authentication/screens/user_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: <String, WidgetBuilder>{
          "/login": (context) => const Login(),
          "/home": (context) => const HomePage(),
          "/home/list": (context) => UserListPage(),
          "/register": (context) => const Register(),
        },
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated
    checkAutologin();
  }

  // Function to check if autologin is possible
  void checkAutologin() async {
    bool result = await AuthRepository.tryAutoLogin();

    if (result) {
      // Navigate to the home screen
      navigateToHome();
    } else {
      // If not authenticated, set isLoading to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to navigate to the home screen
  void navigateToHome() {
    setState(() {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Builder(builder: (context) {
        return Container(
          alignment: Alignment.center,
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text("Auto Login"),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login screen
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const Text("Login"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login screen
                        Navigator.pushNamed(context, "/register");
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
