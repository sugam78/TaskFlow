

import 'package:taskflow/features/chat/data/data_sources/remote/group_actions_remote_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/group_actions_repo.dart';

class GroupActionsRepositoryImpl extends GroupActionsRepository{
  final GroupActionsRemoteDataSource _groupActionsRemoteDataSource;

  GroupActionsRepositoryImpl(this._groupActionsRemoteDataSource);
  @override
  Future<void> leaveGroup(String groupId) {
    return _groupActionsRemoteDataSource.leaveGroup(groupId);
  }

}