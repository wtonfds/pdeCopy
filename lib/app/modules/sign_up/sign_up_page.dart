import 'package:app_pde/app/modules/login/widgets/login_page_header.dart';
import 'package:app_pde/app/modules/sign_up/sign_up_form.dart';
import 'package:app_pde/app/modules/sign_up/sign_up_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ModularState<SignUpPage, SignUpStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  const LoginPageHeader(title: 'Criar uma conta'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SignUpForm(),
                  ),
                ],
              ),
              const BackButton(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
