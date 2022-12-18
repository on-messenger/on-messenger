import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/widgets/loader.dart';
import '../../../common/widgets/todo_item.dart';
import '../../../models/todo.dart';
import '../controller/task_controller.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  late String recieverEmail;
  final ScrollController _todoController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _todoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ToDo>>(
        stream: ref.read(taskControllerProvider).taskStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            controller: _todoController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final taskData = snapshot.data![index];
              return ToDoItem(
                todo: taskData,
                ref: ref,
              );
            },
          );
        });
  }
}
