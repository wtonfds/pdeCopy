String? strError(String str) {
  try {
    String count = str.substring(1, str.indexOf(']'));
    return mapError['${count.replaceAll(RegExp(r'firebase_auth/'), '')}'];
  } catch (e) {
    return null;
  }
}

Map<String, String> mapError = {
  'app-deleted': 'O banco de dados não foi localizado.',
  'expired-action-code': 'O código da ação o ou link expirou.',
  'invalid-action-code':
      'O código da ação é inválido. Isso pode acontecer se o código estiver malformado ou já tiver sido usado.',
  'user-disabled':
      'Conta suspensa temporariamente',
  'user-not-found': 'O usuário não correponde à nenhuma credencial.',
  'weak-password': 'A senha é muito fraca.',
  'email-already-in-use':
      'Já existi uma conta com o endereço de email fornecido.',
  'invalid-email': 'O endereço de e-mail não é válido.',
  'operation-not-allowed':
      'O tipo de conta correspondente à esta credencial, ainda não encontra-se ativada.',
  'account-exists-with-different-credential':
      'E-mail já associado a outra conta.',
  'auth-domain-config-required':
      'A configuração para autenticação não foi fornecida.',
  'credential-already-in-use': 'Já existe uma conta para esta credencial.',
  'operation-not-supported-in-this-environment':
      'Esta operação não é suportada no ambiente que está sendo executada. Verifique se deve ser http ou https.',
  'timeout':
      'Excedido o tempo de resposta. O domínio pode não estar autorizado para realizar operações.',
  'missing-android-pkg-name':
      'Deve ser fornecido um nome de pacote para instalação do aplicativo Android.',
  'missing-continue-uri': 'A próxima URL deve ser fornecida na solicitação.',
  'missing-ios-bundle-id':
      'Deve ser fornecido um nome de pacote para instalação do aplicativo iOS.',
  'invalid-continue-uri': 'A próxima URL fornecida na solicitação é inválida.',
  'unauthorized-continue-uri':
      'O domínio da próxima URL não está na lista de autorizações.',
  'invalid-dynamic-link-domain':
      'O domínio de link dinâmico fornecido, não está autorizado ou configurado no projeto atual.',
  'argument-error': 'Verifique a configuração de link para o aplicativo.',
  'invalid-persistence-type':
      'O tipo especificado para a persistência dos dados é inválido.',
  'unsupported-persistence-type':
      'O ambiente atual não suportar o tipo especificado para persistência dos dados.',
  'invalid-credential': 'A credencial expirou ou está mal formada.',
  'wrong-password': 'Senha incorreta.',
  'invalid-verification-code':
      'O código de verificação da credencial não é válido.',
  'invalid-verification-id': 'O ID de verificação da credencial não é válido.',
  'custom-token-mismatch': 'O token está diferente do padrão solicitado.',
  'invalid-custom-token': 'O token fornecido não é válido.',
  'captcha-check-failed':
      'O token de resposta do reCAPTCHA não é válido, expirou ou o domínio não é permitido.',
  'invalid-phone-number':
      'O número de telefone está em um formato inválido (padrão E.164).',
  'missing-phone-number': 'O número de telefone é requerido.',
  'quota-exceeded': 'A cota de SMS foi excedida.',
  'cancelled-popup-request':
      'Somente uma solicitação de janela pop-up é permitida de uma só vez.',
  'popup-blocked': 'A janela pop-up foi bloqueado pelo navegador.',
  'popup-closed-by-user':
      'A janela pop-up foi fechada pelo usuário sem concluir o login no provedor.',
  'unauthorized-domain':
      'O domínio do aplicativo não está autorizado para realizar operações.',
  'invalid-user-token': 'O usuário atual não foi identificado.',
  'user-token-expired': 'O token do usuário atual expirou.',
  'null-user': 'O usuário atual é nulo.',
  'app-not-authorized':
      'Aplicação não autorizada para autenticar com a chave informada.',
  'invalid-api-key': 'A chave da API fornecida é inválida.',
  'network-request-failed': 'Falha de conexão com a rede.',
  'requires-recent-login':
      'O último horário de acesso do usuário não atende ao limite de segurança.',
  'too-many-requests':
      'As solicitações foram bloqueadas devido a atividades incomuns. Tente novamente depois que algum tempo.',
  'web-storage-unsupported':
      'O navegador não suporta armazenamento ou se o usuário desativou este recurso.',
  'invalid-claims': 'Os atributos de cadastro personalizado são inválidos.',
  'claims-too-large':
      'O tamanho da requisição excede o tamanho máximo permitido de 1 Megabyte.',
  'id-token-expired': 'O token informado expirou.',
  'id-token-revoked': 'O token informado perdeu a validade.',
  'invalid-argument': 'Um argumento inválido foi fornecido a um método.',
  'invalid-creation-time':
      'O horário da criação precisa ser uma data UTC válida.',
  'invalid-disabled-field':
      'A propriedade para usuário desabilitado é inválida.',
  'invalid-display-name': 'O nome do usuário é inválido.',
  'invalid-email-verified': 'O e-mail é inválido.',
  'invalid-hash-algorithm':
      'O algoritmo de HASH não é uma criptografia compatível.',
  'invalid-hash-block-size': 'O tamanho do bloco de HASH não é válido.',
  'invalid-hash-derived-key-length':
      'O tamanho da chave derivada do HASH não é válido.',
  'invalid-hash-key': 'A chave de HASH precisa ter um buffer de byte válido.',
  'invalid-hash-memory-cost': 'O custo da memória HASH não é válido.',
  'invalid-hash-parallelization':
      'O carregamento em paralelo do HASH não é válido.',
  'invalid-hash-rounds': 'O arredondamento de HASH não é válido.',
  'invalid-hash-salt-separator':
      'O campo do separador de SALT do algoritmo de geração de HASH precisa ser um buffer de byte válido.',
  'invalid-id-token': 'O código do token informado não é válido.',
  'invalid-last-sign-in-time':
      'O último horário de login precisa ser uma data UTC válida.',
  'invalid-page-token': 'A próxima URL fornecida na solicitação é inválida.',
  'invalid-password':
      'A senha é inválida, precisa ter pelo menos 6 caracteres.',
  'invalid-password-hash': 'O HASH da senha não é válida.',
  'invalid-password-salt': 'O SALT da senha não é válido.',
  'invalid-photo-url': 'A URL da foto de usuário é inválido.',
  'invalid-provider-id': 'O identificador de provedor não é compatível.',
  'invalid-session-cookie-duration':
      'A duração do COOKIE da sessão precisa ser um número válido em milissegundos, entre 5 minutos e 2 semanas.',
  'invalid-uid': 'O identificador fornecido deve ter no máximo 128 caracteres.',
  'invalid-user-import': 'O registro do usuário a ser importado não é válido.',
  'invalid-provider-data': 'O provedor de dados não é válido.',
  'maximum-user-count-exceeded':
      'O número máximo permitido de usuários a serem importados foi excedido.',
  'missing-hash-algorithm':
      'É necessário fornecer o algoritmo de geração de HASH e seus parâmetros para importar usuários.',
  'missing-uid': 'Um identificador é necessário para a operação atual.',
  'reserved-claims':
      'Uma ou mais propriedades personalizadas fornecidas usaram palavras reservadas.',
  'session-cookie-revoked': 'O COOKIE da sessão perdeu a validade.',
  'uid-alread-exists': 'O indentificador fornecido já está em uso.',
  'email-already-exists': 'O e-mail fornecido já está em uso.',
  'phone-number-already-exists': 'O telefone fornecido já está em uso.',
  'project-not-found': 'Nenhum projeto foi encontrado.',
  'insufficient-permission':
      'A credencial utilizada não tem permissão para acessar o recurso solicitado.',
  'internal-error':
      'O servidor de autenticação encontrou um erro inesperado ao tentar processar a solicitação.',
};

Map<String, String> mapErrorFunction = {
  'ABORTED':
      'A operação foi abortada, devido a um problema de simultaneidade etc.',
  'ALREADY_EXISTS': 'Algum Usuário já existe na nossa base de dados.',
  'CANCELED': 'A operação foi cancelada.',
  'DATA_LOSS': 'Perda ou corrupção de dados irrecuperáveis.',
  'DEADLINE_EXCEEDED': 'Tempo limite da transação excedido.',
  'FAILED_PRECONDITION':
      'A operação foi rejeitada, sistema indísponivel para execução essa operação.',
  'INTERNAL': 'Erros internos, Usuário já existe na nossa base de dados.',
  'INVALID_ARGUMENT': 'Argumento inválido verifique.',
  'NOT_FOUND': 'Arquivo não encontrado.',
  'OK': 'A operação concluida com sucesso.',
  'OUT_OF_RANGE': 'A operação foi tentada além do intervalo válido.',
  'PERMISSION_DENIED':
      'O usuaŕio sem permissão para executar a operação especificada.',
  'RESOURCE_EXHAUSTED': 'Recurso se esgotou.',
  'UNAUTHENTICATED':
      'A solicitação não possui credenciais de autenticação válidas para a operação.',
  'UNAVAILABLE': 'O serviço não está disponível no momento.',
  'UNIMPLEMENTED':
      'A operação não foi implementada ou não é suportada / habilitada.',
  'UNKNOWN': 'Erro desconhecido ou um erro de um domínio de erro diferente.'
};
