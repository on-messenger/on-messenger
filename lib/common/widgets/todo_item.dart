import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/task/controller/task_controller.dart';
import '../../models/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final WidgetRef ref;

  _deleteToDoItem(String? id, String recieverId) {
    ref.read(taskControllerProvider).deleteTask(id!, recieverId);
  }

  _handleToDoChange(ToDo todo) {
    todo.isDone = !todo.isDone;
    ref.read(taskControllerProvider).updateTask(todo);
  }

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          _handleToDoChange(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.blueAccent,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          todo.recieverEmail,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
              // print('Clicked on delete icon');
              _deleteToDoItem(todo.id, todo.recieverId);
            },
          ),
        ),
      ),
    );
  }
}
