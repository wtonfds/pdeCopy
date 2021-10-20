import 'package:app_pde/app/models/checkbox_model.dart';
import 'package:app_pde/app/modules/sign_up/sign_up_store.dart';
import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:app_pde/app/shared/utlis/mask_map.dart';
import 'package:app_pde/app/shared/widgets/custom_load_button.dart';
import 'package:app_pde/app/shared/widgets/custom_password_text_field.dart';
import 'package:app_pde/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends ModularState<SignUpForm, SignUpStore> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            onChanged: (value) {},
            controller: controller.ctrlEmail,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validaEmail,
          ),
          CustomPasswordTextField(
            controller: controller.ctrlSenha,
            validator: controller.validaSenha,
          ),
          CustomPasswordTextField(
            controller: controller.ctrlConfirmaSenha,
            validator: controller.validaConfirmaSenha,
            labelText: 'Confirme a senha',
            hintText: 'Digite sua senha',
          ),
          CustomTextField(
            label: 'Telefone',
            hint: '+XX (XX) XXXXX-XXXX',
            onChanged: (value) {},
            controller: controller.ctrlTelefone,
            validator: controller.validaTelefone,
            maskFormatter: masks['cel'],
          ),
          const SizedBox(height: 30),
          _buildCheckboxProfessor(),
          const SizedBox(height: 30),
          _buildTermsOfUse(),
          const SizedBox(height: 30),
          _buildSubmitButton(),
          const SizedBox(height: 30),
          _buildStatus(),
        ],
      ),
    );
  }

  Observer _buildStatus() {
    return Observer(builder: (_) {
      return controller.hasError
          ? Text(
              controller.errorMessage!,
              maxLines: 2,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            )
          : Container();
    });
  }

  Widget _buildSubmitButton() {
    return Observer(
      builder: (context) => CustomLoadButton(
        title: 'Cadastrar',
        loading: controller.loading,
        onPressed: () {
          if (controller.formKey.currentState!.validate() &&
              controller.aceitouTermos) {
            controller.submit();
          }
        },
      ),
    );
  }

  Widget _buildTermsOfUse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Observer(builder: (_) {
          return Checkbox(
            value: controller.aceitouTermos,
            onChanged: (value) => controller.aceitarTermos(value!),
          );
        }),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                  text: 'Eu li e aceito os ',
                  style: TextStyle(color: AppColors.darkGrey)),
              TextSpan(
                text: 'TERMOS DE USO',
                style: const TextStyle(color: AppColors.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Modular.to.pushNamed('/sign-up/terms-of-use'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxProfessor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Observer(builder: (_) {
          return Checkbox(
            value: controller.isProfessor,
            onChanged: (value) => controller.addIsProfessor(value!),
          );
        }),
        RichText(
          text: const TextSpan(
            children: [
              const TextSpan(
                  text: 'Quero ser um Professor',
                  style: TextStyle(color: AppColors.darkGrey)
              ),
            ],
          ),
        ),
      ],
    );
  }
}
