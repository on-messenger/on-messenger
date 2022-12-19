import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:on_messenger/common/widgets/error.dart';
import 'package:on_messenger/features/auth/screens/login_screen.dart';
import 'package:on_messenger/features/auth/screens/signup_screen.dart';
import 'package:on_messenger/features/auth/screens/user_information_screen.dart';
import 'package:on_messenger/features/chat/screens/mobile_chat_screen.dart';
import 'package:on_messenger/features/configuration/configuration_page.dart';
import 'package:on_messenger/features/task/screen/task_screen.dart';

import 'features/landing/landing_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case TaskStateScreen.routeName:
      return MaterialPageRoute(builder: (_) => TaskStateScreen());
    case LandingScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LandingScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case Configuration.routeName:
      return MaterialPageRoute(
        builder: (context) => const Configuration(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'Esta página não existe'),
        ),
      );
  }
}
