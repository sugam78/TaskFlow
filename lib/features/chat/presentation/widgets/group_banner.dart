import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/resources/dimensions.dart';

class GroupBanner extends StatelessWidget {
  final String groupName,groupId;
  const GroupBanner({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: (){
        context.push('/chatGroupDetails',extra: groupId);
      },
      child: Container(
        height: deviceHeight * 0.1,
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04,vertical: deviceHeight * 0.01),
        margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01,vertical: deviceHeight * 0.005),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2)
        ),
        child: Row(
          children: [
            Icon(Icons.groups_outlined),
            SizedBox(width: deviceWidth * 0.1,),
            Text(groupName,style: Theme.of(context).textTheme.titleMedium,maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
      ),
    );
  }
}
