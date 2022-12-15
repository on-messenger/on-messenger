import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/enums/message_enum.dart';
import 'package:on_messenger/common/providers/message_reply_provider.dart';
import 'package:on_messenger/features/auth/controller/auth_controller.dart';
import 'package:on_messenger/models/chat_contact.dart';
import 'package:on_messenger/models/group.dart';
import 'package:on_messenger/models/message.dart';
import 'package:on_messenger/models/user_model.dart';
import 'package:uuid/uuid.dart';
import '../../../common/utils/utils.dart';
import '../../../models/todo.dart';
import '../repository/task_repository.dart';

final taskControllerProvider = Provider((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return TaskController(
    taskRepository: taskRepository,
    ref: ref,
  );
});

class TaskController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TaskRepository taskRepository;
  final ProviderRef ref;
  TaskController({
    required this.taskRepository,
    required this.ref,
  });

  Stream<List<ToDo>> taskStream() {
    return taskRepository.getTaskStream();
  }

  void _saveTask({
    required String senderId,
    required String recieverId,
    required DateTime timeSent,
    required String id,
    required String todoText,
    required bool isSeen,
    required bool isDone,
  }) async {
    final todo = ToDo(
      senderId: auth.currentUser!.uid,
      recieverId: recieverId,
      todoText: todoText,
      timeSent: timeSent,
      id: id,
      isSeen: false,
      isDone: false,
    );
    // users -> sender id -> reciever id -> tasks -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('tasks')
        .doc(recieverId)
        .collection('todo')
        .doc(id)
        .set(
      todo.toMap(),
    );
    // users -> reciever id  -> sender id -> tasks -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverId)
        .collection('tasks')
        .doc(auth.currentUser!.uid)
        .collection('todo')
        .doc(id)
        .set(
      todo.toMap(),
    );
  }

  void sendTextTask({
    required BuildContext context,
    required String senderId,
    required String recieverEmail,
    required String todoText,
    required bool isSeen,
    required bool isDone,
  }) async {
    try {
      var userDataMap = await firestore.collection('users').doc(recieverEmail).get();
      UserModel recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var timeSent = DateTime.now();

      var id = const Uuid().v1();

      _saveTask(
        recieverId: recieverUserData.uid,
        todoText: todoText,
        timeSent: timeSent,
        id: id,
        isSeen: isSeen,
        isDone: isDone,
        senderId: senderId,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setTaskSeen(
      BuildContext context,
      String recieverUserId,
      String messageId,
      ) {
    taskRepository.setTaskSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
