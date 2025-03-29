import 'package:flutter/material.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/profile/presentation/widgets/change_password_button.dart';
import 'package:taskflow/features/profile/presentation/widgets/logout_button.dart';
import 'package:taskflow/features/profile/presentation/widgets/profile_details.dart';
import 'package:taskflow/features/profile/presentation/widgets/theme_toggle_button.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05,vertical: deviceHeight * 0.03),
        child: Column(
          children: [
            ProfileDetails(),
            SizedBox(height: deviceHeight * 0.05,),
            ChangePasswordButton(),
            SizedBox(height: deviceHeight * 0.02,),
            ThemeToggleButton(),
            SizedBox(height: deviceHeight * 0.02,),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
