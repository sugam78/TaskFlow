import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(
      this.remoteDataSource);


  @override
  Future<void> signUp(
      String name, String email, String password) async {
    await remoteDataSource.signUp(name, email, password);
  }

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);

    return User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        token: userModel.token);
  }


}
