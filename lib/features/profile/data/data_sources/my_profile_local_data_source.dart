

import 'package:hive/hive.dart';
import 'package:taskflow/features/profile/data/models/profile_model.dart';

abstract interface class MyProfileLocalDataSource{
  Future<ProfileModel> getMyProfile();
  Future<void> saveMyProfile(ProfileModel profileModel);
}

class MyProfileLocalDataSourceImpl extends MyProfileLocalDataSource {
  static const String _profileBoxName = 'PROFILE';
  static const String _profileKey = 'my_profile';

  @override
  Future<ProfileModel> getMyProfile() async {
    final box = Hive.box(_profileBoxName);
    final profile = box.get(_profileKey);

    if (profile == null) {
      throw "No Internet connection";
    }

    return profile;
  }

  @override
  Future<void> saveMyProfile(ProfileModel profileModel) async {
    final box = Hive.box(_profileBoxName);
    await box.put(_profileKey, profileModel);
  }
}
