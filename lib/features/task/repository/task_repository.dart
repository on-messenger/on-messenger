import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
// import 'package:on_messenger/common/repositories/common_firebase_storage_repository.dart';
import 'package:on_messenger/common/utils/utils.dart';
import '../../../models/todo.dart';

final taskRepositoryProvider = Provider(
  (ref) => TaskRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class TaskRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  TaskRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ToDo>> getTaskStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('tasks')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<ToDo> todos = [];
      for (var document in event.docs) {
        todos.add(ToDo.fromMap(document.data()));
      }
      return todos;
    });
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
    required String recieverId,
    required DateTime timeSent,
    required String id,
    required String todoText,
    required bool isSeen,
    required bool isDone,
  }) async {
    try {
      var timeSent = DateTime.now();

      var id = const Uuid().v1();

      _saveTask(
        recieverId: recieverId,
        todoText: todoText,
        timeSent: timeSent,
        id: id,
        isSeen: isSeen,
        isDone: isDone,
        senderId: '',
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setTaskSeen(
    BuildContext context,
    String recieverUserId,
    String id,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .doc(recieverUserId)
          .collection('todo')
          .doc(id)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('tasks')
          .doc(auth.currentUser!.uid)
          .collection('todo')
          .doc(id)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
