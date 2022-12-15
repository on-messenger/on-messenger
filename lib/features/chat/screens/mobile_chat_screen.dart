import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/common/widgets/loader.dart';
import 'package:on_messenger/features/auth/controller/auth_controller.dart';
import 'package:on_messenger/features/chat/widgets/bottom_chat_field.dart';
import 'package:on_messenger/models/user_model.dart';
import 'package:on_messenger/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 15.0),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(profilePic),
                          ),
                        ),
                        Column(
                          children: [
                            Text(name),
                            Text(
                              snapshot.data!.isOnline ? 'Online' : 'Offline',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
          centerTitle: false,
          // actions: [
          //   IconButton(
          //     onPressed: () => m**a**keCall(ref, context),
          //     icon: const Icon(Icons.video_call),
          //   ),
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.call),
          //   ),
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.more_vert),
          //   ),
          // ],
        ),
      
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
