
import 'package:taskflow/features/chat/domain/repositories/group_actions_repo.dart';

class LeaveGroupUseCase{
  final GroupActionsRepository _groupActionsRepository;

  LeaveGroupUseCase(this._groupActionsRepository);
  Future<void> leaveGroup(String groupId)async{
    await _groupActionsRepository.leaveGroup(groupId);
  }
}