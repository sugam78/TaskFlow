import 'package:taskflow/features/security/data/data_sources/change_password_remote_data_source.dart';
import 'package:taskflow/features/security/domain/repositories/change_password_repo.dart';

class ChangePasswordRepositoryImpl extends ChangePasswordRepository{
  final ChangePasswordRemoteDataSource changePasswordRemoteDataSource;

  ChangePasswordRepositoryImpl(this.changePasswordRemoteDataSource);
  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return changePasswordRemoteDataSource.changePassword(currentPassword, newPassword);
  }

}