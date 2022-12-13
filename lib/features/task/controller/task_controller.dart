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

  Stream<List<ToDo>> chatStream() {
    return taskRepository.getTaskStream();
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String senderUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    UserModel? recieverUserData, currentUser;

    if (!isGroupChat) {
      var userDataMap =
      await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      userDataMap =
      await firestore.collection('users').doc(senderUserId).get();
      currentUser = UserModel.fromMap(userDataMap.data()!);
    }

    final message = Message(
      senderId: senderUserId,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
          ? currentUser!.name
          : recieverUserData?.name ?? "",
      repliedMessageType:
      messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
        message.toMap(),
      );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(senderUserId)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toMap(),
      );
      // users -> reciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(senderUserId)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toMap(),
      );
    }
  }

  void sendTextMessage(
      BuildContext context,
      String text,
      String recieverUserId,
      UserModel senderUser,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    var timeSent = DateTime.now();
    var messageId = const Uuid().v1();
    _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        senderUserId: auth.currentUser!.uid,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        isGroupChat: isGroupChat);
    ref.read(userDataAuthProvider).whenData(
          (senderUser) => taskRepository.sendTextMessage(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: senderUser!,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      ),
    );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
      BuildContext context,
      File file,
      String recieverUserId,
      MessageEnum messageEnum,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => taskRepository.sendFileMessage(
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: value!,
        messageEnum: messageEnum,
        ref: ref,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      ),
    );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
      BuildContext context,
      String gifUrl,
      String recieverUserId,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userDataAuthProvider).whenData(
          (value) => taskRepository.sendGIFMessage(
        context: context,
        gifUrl: newgifUrl,
        recieverUserId: recieverUserId,
        senderUser: value!,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      ),
    );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context,
      String recieverUserId,
      String messageId,
      ) {
    taskRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
