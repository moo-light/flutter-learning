// ignore_for_file: avoid_print, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:todo_application/dtos/todos.dart';
import 'package:todo_application/view/todos/todo_create_update.dart';

class _TodoDetailState extends State<TodoDetail> {
  @override
  Widget build(BuildContext context) {
    print(widget.entry);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              const Text("Detail"),
              SizedBox(
                width: 10.0,
              ),
              Icon(widget.entry.checked ? Icons.check : Icons.not_interested)
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Handle search icon press
              _showDeleteConfirmationDialog(context).then((confirmed) {
                if (confirmed != null && confirmed) {
                  // User confirmed deletion, you can perform additional actions
                  print('Item deleted. Additional actions can be performed.');
                  Navigator.pop<int>(context, widget.index);
                } else {
                  // User canceled deletion or closed the dialog
                  print('Deletion canceled.');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Handle settings icon press
              print('Edit icon pressed');

              var result = await Navigator.push<Todo?>(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoCreateUpdate(
                    widget.entry,
                    title: "Update",
                  ),
                ),
              );
              if (result == null) return;
              print(result);
              setState(() {
                widget.entry.todo = result.todo;
                widget.entry.checked = result.checked;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.entry.todo,
              style: const TextStyle(fontSize: 30.0),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Dialog is not dismissible by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform the delete operation
              // Add your delete logic here
              print('Item deleted');
              Navigator.of(context).pop(true); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

class TodoDetail extends StatefulWidget {
  Todo entry;

  int index;

  TodoDetail({required this.index, required this.entry, super.key});

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}
