
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/features/auth/presentation/widgets/login_form.dart';

import '../../../../core/resources/dimensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth *0.05,vertical: deviceHeight * 0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight * 0.2),
              Text('Welcome',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 28
              ),),
              Text('Lets login',style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 20
              ),),
              SizedBox(height: deviceHeight * 0.1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(onPressed: (){
                        context.pushNamed('signup');
                      }, child: Text('create one'))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
