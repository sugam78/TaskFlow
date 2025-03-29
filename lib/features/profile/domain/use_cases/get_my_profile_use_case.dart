
import 'package:taskflow/features/profile/domain/entities/profile.dart';
import 'package:taskflow/features/profile/domain/repositories/my_profile_repo.dart';

class GetMyProfileUseCase {
  final MyProfileRepository myProfileRepository;

  GetMyProfileUseCase(this.myProfileRepository);

  Future<Profile> getMyProfile(){
    return myProfileRepository.getMyProfile();
  }
}