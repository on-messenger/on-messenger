// import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/common/utils/utils.dart';
import 'package:on_messenger/common/widgets/custom_button.dart';
import 'package:on_messenger/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Country? country;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void sendEmail() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (password.isNotEmpty && email.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithEmail(context, email, password);
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your email and password.'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                  'On will need to verify your email and password.'),
              const SizedBox(height: 5),
              Column(
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.3),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendEmail,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
