import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/features/task/widgets/task_list.dart';
import '../widgets/field_task.dart';

// ignore: must_be_immutable
class TaskStateScreen extends ConsumerWidget {
  static const routeName = '/task-screen';
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late ProviderRef ref;

  TaskStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: const [
            Expanded(
              child: TaskList(),
            ),
            BottomTaskField(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
<<<<<<< HEAD
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Tarefas'),
          ]),
=======
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        Text('Tarefas'),
      ]),
>>>>>>> 7df9ffe777a8f77a2162c3587afda30429331abd
    );
  }
}
