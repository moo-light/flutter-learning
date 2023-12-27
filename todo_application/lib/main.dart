// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:todo_application/dtos/todos.dart';
import 'package:todo_application/view/todos/todo_detail.dart';

import 'view/todos/todo_create_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Todo> entries = [Todo('A'), Todo('B'), Todo('C')].toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        Expanded(
          child: SizedBox(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (context, index) => _buildItem(context, index),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push<Todo>(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoCreateUpdate(Todo(""),title: "Create"),
                ));
            setState(() {
              if (result != null) entries.add(result);
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _buildItem(context, index) {
    return MaterialButton(
      onPressed: () async {
        int? result = await Navigator.push<int>(
            context,
            MaterialPageRoute(
              builder: (context) => TodoDetail(
                entry: entries[index],
                index: index,
              ),
            ));
        if (result != null) {
          // Handle the result, which is an int
          entries.removeAt(result);
          print('Received result: $result');
        } else {
          // Handle the case where the user canceled or closed the screen without a result
          print('User canceled or closed without a result');
        }
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Row(children: [
          Checkbox(
            value: entries[index].checked,
            onChanged: (value) {
              entries[index].checked = !entries[index].checked;
              setState(() {});
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                entries[index].todo,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
