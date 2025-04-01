import 'package:taskflow/core/services/notification_services.dart';

import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<void> execute(String name,String email, String password) async{
    return repository.signUp(name, email,password);
  }
}
