import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/utils/utils.dart';
import 'package:on_messenger/features/auth/repository/auth_repository.dart';
import 'package:on_messenger/mobile_layout_screen.dart';
import 'package:on_messenger/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void loginWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e, s) {
      _handleFirebaseLoginWithCredentialsException(e, s, context);
    } on Exception catch (e) {
      e.toString();
      showSnackBar(
          context: context,
          content:
              '$e Houve um erro inesperado, entre em contato: on.messenger.tcc@outlook.com, se possivel anexe a mensagem de erro mostrada.');
    }
  }

  void _handleFirebaseLoginWithCredentialsException(
      Object e, StackTrace s, context) {
    if (e.toString().contains('user-disabled')) {
      showSnackBar(
          context: context, content: 'O usuário informado está desabilitado.');
    } else if (e.toString().contains('user-not-found')) {
      showSnackBar(
          context: context,
          content: 'O usuário informado não está cadastrado.');
    } else if (e.toString().contains('invalid-email')) {
      showSnackBar(
          context: context,
          content: 'O domínio do e-mail informado é inválido.');
    } else if (e.toString().contains('wrong-password')) {
      showSnackBar(
          context: context, content: 'A senha informada está incorreta.');
    } else {
      e.toString();
      showSnackBar(
          context: context,
          content:
              '$e Houve um erro inesperado, entre em contato: on.messenger.tcc@outlook.com, se possivel anexe a mensagem de erro mostrada.');
    }
  }

  void signUpWithEmail(
      BuildContext context, String email, String password) async {
    authRepository.signUpWithEmail(context, email, password);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
