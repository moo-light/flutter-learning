// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:todo_application/dtos/todos.dart';

class TodoCreateUpdate extends StatefulWidget {
  Todo entry;

  String title;

  TodoCreateUpdate(this.entry, {required this.title, super.key});

  @override
  State<TodoCreateUpdate> createState() {
    return _TodoCreateUpdateState();
  }
}

class _TodoCreateUpdateState extends State<TodoCreateUpdate> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current title value
    _controller = TextEditingController(text: widget.entry.todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              autocorrect: true,
              controller: _controller,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Enter Your Todo",
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          if (_controller.text.isEmpty) return;
          widget.entry.todo = _controller.text;
          Navigator.pop(context, widget.entry);
        },
        clipBehavior: Clip.none,
        child: const Icon(Icons.save),
      ),
    );
  }
}
