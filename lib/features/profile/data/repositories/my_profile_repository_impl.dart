
import 'package:taskflow/features/profile/data/data_sources/my_profile_remote_data_source.dart';
import 'package:taskflow/features/profile/domain/entities/profile.dart';
import 'package:taskflow/features/profile/domain/repositories/my_profile_repo.dart';

class MyProfileRepositoryImpl extends MyProfileRepository{
  final MyProfileRemoteDataSource myProfileRemoteDataSource;

  MyProfileRepositoryImpl(this.myProfileRemoteDataSource);
  @override
  Future<Profile> getMyProfile()async {
    final profile = await myProfileRemoteDataSource.getMyProfile();
    return Profile(id: profile.id, name: profile.name, email: profile.email);
  }

}