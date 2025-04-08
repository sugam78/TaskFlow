import 'dart:io';

import 'package:taskflow/features/profile/data/data_sources/my_profile_remote_data_source.dart';
import 'package:taskflow/features/profile/data/data_sources/my_profile_local_data_source.dart';
import 'package:taskflow/features/profile/domain/entities/profile.dart';
import 'package:taskflow/features/profile/domain/repositories/my_profile_repo.dart';

class MyProfileRepositoryImpl extends MyProfileRepository {
  final MyProfileRemoteDataSource myProfileRemoteDataSource;
  final MyProfileLocalDataSource myProfileLocalDataSource;

  MyProfileRepositoryImpl(
      this.myProfileRemoteDataSource,
      this.myProfileLocalDataSource,
      );

  @override
  Future<Profile> getMyProfile() async {
    try {
      final profileModel = await myProfileRemoteDataSource.getMyProfile();

      await myProfileLocalDataSource.saveMyProfile(profileModel);

      return Profile(
        id: profileModel.id,
        name: profileModel.name,
        email: profileModel.email,
      );
    } on SocketException {
      final cachedProfile = await myProfileLocalDataSource.getMyProfile();
      return Profile(
        id: cachedProfile.id,
        name: cachedProfile.name,
        email: cachedProfile.email,
      );
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }
}
