import 'package:taskflow/core/services/notification_services.dart';

import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  final NotificationServices notificationServices;
  SignupUseCase(this.repository, this.notificationServices);

  Future<void> execute(String name,String email, String password) async{
    final fcmToken = await notificationServices.getToken();
    return repository.signUp(name, email,password,fcmToken);
  }
}
