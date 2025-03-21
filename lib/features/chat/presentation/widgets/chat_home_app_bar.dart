import 'package:flutter/material.dart';
import 'package:taskflow/features/chat/presentation/widgets/bottom_sheet.dart';

class ChatHomeAppBar extends StatelessWidget {
  const ChatHomeAppBar({super.key});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CreateGroupBottomSheet());
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Chats'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'create_group') {
              _showBottomSheet(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'create_group',
              child: Text('Create Group'),
            ),
          ],
        ),
      ],
    );
  }
}
