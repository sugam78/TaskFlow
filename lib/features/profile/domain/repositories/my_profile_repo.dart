import 'package:taskflow/features/profile/domain/entities/profile.dart';

abstract class MyProfileRepository{
  Future<Profile> getMyProfile();
}