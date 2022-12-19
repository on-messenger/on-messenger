import 'package:flutter/material.dart';
import 'package:on_messenger/common/widgets/custom_button.dart';
import 'package:on_messenger/features/auth/screens/login_screen.dart';
import 'package:on_messenger/features/auth/screens/signup_screen.dart';

class LandingScreen extends StatelessWidget {
  static const String routeName = '/landing-screen';
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Bem-vindo ao',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height / 18),
            Image.asset(
              'assets/splash.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: size.height / 100),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: CustomButton(
                  text: 'CONCORDE E CONTINUE',
                  onPressed: () => navigateToLoginScreen(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                child: CustomButton(
                  text: 'CRIAR NOVA CONTA',
                  onPressed: () => navigateToSignUpScreen(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
