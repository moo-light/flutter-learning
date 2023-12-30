// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo_application_repository_pattern/daos/user_repository.dart';
import 'package:todo_application_repository_pattern/dtos/user_model.dart';
import 'package:todo_application_repository_pattern/views/create.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/create': (BuildContext context) => CreateUser(),
        '/update': (BuildContext context) {
          var args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final int id = args['id'];
          return CreateUser.edit(id: id);
        },
      },
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late UserRepository userRepository;

  @override
  void initState() {
    userRepository = UserRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/create").then((result) {
            if (result != null) {
              setState(() {
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<UserModel?>>(
        future: userRepository.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error state
            return Text('Error: ${snapshot.error}');
          } else {
            // Data loaded successfully
            List<UserModel?>? users = snapshot.data;
            return Visibility(
              visible: users!.isNotEmpty,
              replacement: Center(
                child: Text(
                  "Nothing Yet",
                  style: Theme.of(context).primaryTextTheme.headlineMedium,
                ),
              ),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel? user = users[index];
                  return _buildCard(user, userRepository);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Container _buildCard(UserModel? user, UserRepository userRepository) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: ListTile(
        leading: Container(
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 2, color: Colors.black),
              // borderRadius: BorderRadius.all(Radius.circular(1)),
              shape: BoxShape.circle),
          child: Center(
            child: Text(
              user!.id.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white70),
            ),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        // Add more details or actions as needed
        trailing: PopupMenuButton(
          onSelected: (value) async => {
            if (value == 'edit')
              {
                // Edit
                print('/update/${user.id}'),
                Navigator.pushNamed(context, '/update',
                    arguments: {'id': user.id}).then(
                  (value) => setState(() {}),
                ),
              }
            else if (value == 'delete')
              {
                // Do Delete
                await userRepository.removeUser(user.id),
                setState(() {}),
              }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Text('Remove'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
