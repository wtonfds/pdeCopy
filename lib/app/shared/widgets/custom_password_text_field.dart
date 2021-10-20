import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String) validator;

  const CustomPasswordTextField({
    Key? key,
    required this.controller,
    required this.validator,
    this.labelText = 'Senha',
    this.hintText = 'Digite sua senha',
  }) : super(key: key);

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.labelText,
      hint: widget.hintText,
      onChanged: (value) {},
      obscureText: !isPasswordVisible,
      controller: widget.controller,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
      ),
    );
  }
}
