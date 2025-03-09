import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> signUp(String name,String email, String password,String fcmToken);
  Future<User> login(String email, String password);
}
