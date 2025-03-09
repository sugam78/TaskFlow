
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/auth/presentation/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              SizedBox(height: deviceHeight * 0.15),
              Text('Hey',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 28
              ),),
              Text('Lets create a account',style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 20
              ),),
              SizedBox(height: deviceHeight * 0.1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignUpForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Already have an account?'),
                      TextButton(onPressed: (){
                        context.go('/login');
                      }, child: Text('login'))
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