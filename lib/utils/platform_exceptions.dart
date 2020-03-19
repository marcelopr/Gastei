class PlatformExceptions {
  String errorMessage(String code) {
    switch (code) {
      case 'ERROR_WRONG_PASSWORD':
        {
          return 'A senha está incorreta ou o usuário não possui uma senha';
        }
        break;
      case 'ERROR_INVALID_EMAIL':
        {
          return 'O email informado não é válido';
        }
        break;
      case 'ERROR_USER_NOT_FOUND':
        {
          return 'O usuário informado não está cadastrado ou foi removido';
        }
        break;
      case 'ERROR_USER_DISABLED':
        {
          return 'O usuário informado está desabilitado';
        }
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        {
          return 'Número de tentativas expiradas. Tente novamente mais tarde';
        }
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        {
          return 'Esta operação não é permitida para o usuário informado';
        }
        break;
      case ('ERROR_WEAK_PASSWORD'):
        {
          return 'Crie uma senha mais forte com no mínimo 6 dígitos. De preferência utilize letras maiúsculas, minúsculas e números';
        }
        break;
      case ('ERROR_EMAIL_ALREADY_IN_USE'):
        {
          return 'Já existe uma conta com o email informado';
        }
        break;
      default:
        {
          return 'Erro ao realizar a ação';
        }
    }
  }
}
