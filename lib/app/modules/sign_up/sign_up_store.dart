import 'package:app_pde/app/shared/controllers/auth_controller.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/utlis/mask_map.dart';
import 'package:app_pde/app/shared/utlis/validators.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'sign_up_store.g.dart';

class SignUpStore = _SignUpStoreBase with _$SignUpStore;

abstract class _SignUpStoreBase extends BaseStore with Store {
  final AuthController _authController;

  _SignUpStoreBase(this._authController);

  @observable
  bool aceitouTermos = false;

  @observable
  bool isProfessor = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController ctrlEmail = TextEditingController();

  TextEditingController ctrlSenha = TextEditingController();

  TextEditingController ctrlConfirmaSenha = TextEditingController();

  TextEditingController ctrlTelefone = TextEditingController();

  void aceitarTermos(bool value) => aceitouTermos = value;

  String? validaEmail(String texto) => Validators.validarEmail(texto);

  String? validaSenha(String texto) => Validators.validarSenha(ctrlSenha.text);

  String? validaConfirmaSenha(String texto) =>
      Validators.validarConfirmaSenha(ctrlSenha.text, ctrlConfirmaSenha.text);

  String? validaTelefone(String texto) =>
      Validators.validarTelefone(ctrlTelefone.text);

  @action
  Future<void> submit() async {
    int claim = 0;
    if(isProfessor == true){
      claim = 1;
    }else{
      claim = 0;
    }

    makeAsyncRequest(() async {
      return await _authController.createUser(
          claim,
          ctrlEmail.text.trim(),
          ctrlSenha.text.trim(),
          masks['cel']!.unmaskText(ctrlTelefone.text).trim(),
          aceitouTermos);
    });
  }

  void addIsProfessor(bool value) => isProfessor = value;
}
