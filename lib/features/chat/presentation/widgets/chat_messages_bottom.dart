import 'package:flutter/material.dart';
import 'package:taskflow/core/common/widgets/custom_text_field.dart';
import 'package:taskflow/core/resources/dimensions.dart';

class ChatMessagesBottom extends StatelessWidget {
  final TextEditingController controller;
  const ChatMessagesBottom({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton(
            icon: Icon(Icons.add, size: 28),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  // Handle selecting an image
                },
                child: Row(
                  children: [
                    Icon(Icons.image, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Select Image'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  // Handle creating a task
                },
                child: Row(
                  children: [
                    Icon(Icons.add_task, color: Colors.green),
                    SizedBox(width: 10),
                    Text('Create Task'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: deviceWidth * 0.02),
          Expanded(
            child: CustomTextField(labelText: 'Type a message....',controller: controller,),
          ),
          SizedBox(width: deviceWidth * 0.02,),
          ElevatedButton(
            onPressed: () {},
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
