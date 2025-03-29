abstract class ChangePasswordRepository{
  Future<void> changePassword(String currentPassword,String newPassword);
}