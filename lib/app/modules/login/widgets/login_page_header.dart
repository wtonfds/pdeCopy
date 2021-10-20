import 'package:flutter/material.dart';

import 'package:app_pde/app/shared/utlis/app_colors.dart';

import 'custom_clipper_widget.dart';

class LoginPageHeader extends StatelessWidget {
  final String title;

  const LoginPageHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ClipperCurva(),
      child: Container(
        color: AppColors.primaryDark,
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 300),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
