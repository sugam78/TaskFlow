
import 'package:taskflow/features/security/domain/repositories/change_password_repo.dart';

class ChangePasswordUseCase{

  final ChangePasswordRepository changePasswordRepository;

  ChangePasswordUseCase(this.changePasswordRepository);

  Future<void> changePassword(String currentPassword,String newPassword){
    return changePasswordRepository.changePassword(currentPassword, newPassword);
  }
}