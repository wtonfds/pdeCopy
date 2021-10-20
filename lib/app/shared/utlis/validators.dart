import 'package:app_pde/app/shared/utlis/constants.dart';

class Validators {
  static String? validarEmail(String input) {
    if (input.isEmpty) {
      return "Digite o Login";
    }
  }

  static String? validarSenha(String input) {
    if (input.isEmpty || input.length < 6) {
      return "Digite a Senha com no minimo 6 digitos";
    }
  }

  static String? validarTelefone(String input) {
    if (input.isEmpty) return 'Campo obrigatório';
    if (!Constants.telefoneRegex.hasMatch(input)) {
      return 'Telefone inválido';
    }
  }

  static String? validarConfirmaSenha(String firstInput, String secondInput) {
    if (firstInput != secondInput) return 'Senhas não conferem';
  }

  static String? validarApelido(String input) {
    if (Constants.numberRegex.hasMatch(input)) {
      return 'Campo inválido';
    }
  }

  static String? validarCpf(String input) {
    if (input.isEmpty) return 'Campo obrigatório';
    if (!Constants.cpfRegex.hasMatch(input)) {
      return 'CPF inválido';
    }
  }

  static String? validarBanco(String input) {
    if (Constants.numberRegex.hasMatch(input)) {
      return 'Banco inválido';
    }
  }

  static String? validarAgencia(String input) {
    if (!Constants.bankDataRegex.hasMatch(input) && input.isNotEmpty) {
      return 'Agência inválida';
    }
  }

  static String? validarConta(String input) {
    if (!Constants.bankDataRegex.hasMatch(input) && input.isNotEmpty) {
      return 'Conta inválida';
    }
  }

  static String? validarResetEmail(String input) {
    if (input.isEmpty) {
      return "Digite seu e-mail";
    }
  }

  static String? validarDataConsulta(String texto) {
    if (texto.isEmpty) {
      return "Data obrigatória";
    }
  }

  static String? validarHoraInicio(String texto) {
    if (texto.isEmpty) {
      return "Necessário adicionar horário de início";
    }
  }

  static String? validarHoraFinal(String texto) {
    if (texto.isEmpty) {
      return "Necessário adicionar horário de fim";
    }
  }

  static String? validarObs(String texto) {
    if (texto.isEmpty) {
      return "As observações são obrigatórias.";
    }
  }

  static String? validarReply(String texto) {
    if (texto.isEmpty) {
      return "Digite o texto para enviar.";
    }
  }

  static String? validaSoftwareResposta(String texto){
    if(texto.isEmpty){
      return "Você optou por um software de resolução";
    }
  }
}
