// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_messenger/common/widgets/loader.dart';
// import '../../../common/widgets/todo_item.dart';
// import '../../../models/todo.dart';
// import '../controller/task_controller.dart';
//
// class TaskList extends ConsumerStatefulWidget {
//   final String? userSearchEmail;
//   const TaskList({Key? key, required this.userSearchEmail}) : super(key: key);
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _TaskListState();
// }
//
// class _TaskListState extends ConsumerState<TaskList> {
//   final ScrollController _todoController = ScrollController();
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _todoController.dispose();
//   }
//
//   _deleteToDoItem(String id) {
//
//   }
//
//   _handleToDoChange(ToDo todo) {
//     todo.isDone = !todo.isDone;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<ToDo>>(
//         stream: ref.read(taskControllerProvider).taskStream(widget.userSearchEmail),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Loader();
//           }
//           return ListView.builder(
//             controller: _todoController,
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final taskData = snapshot.data![index];
//               return ToDoItem(
//                 onToDoChanged: _handleToDoChange(taskData),
//                 onDeleteItem:
//                 _deleteToDoItem(taskData.id as String),
//                 todo: taskData,
//               );
//             },
//           );
//         });
//   }
// }
