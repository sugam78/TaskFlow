import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/resources/dimensions.dart';
import '../manager/auth_bloc.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthSignUpSuccess){
          context.pushNamed('login');
        }
        if(state is AuthFailure){
          CustomSnackBar.show(context, message: state.errorMessage, type: SnackBarType.error);
          context.read<AuthBloc>().add(ResetAuthBloc());
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: "Name",
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  if (value.length < 3) {
                    return "Name must be at least 3 characters long";
                  }
                  return null;
                },
              ),
              SizedBox(height: deviceHeight * 0.02),

              CustomTextField(
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),

              SizedBox(height: deviceHeight * 0.02),

              CustomTextField(
                labelText: "Password",
                isPassword: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              SizedBox(height: deviceHeight * 0.03),


              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    context.read<AuthBloc>().add(SignupRequested(name: name, email: email, password: password));
                  }
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        );
      },
    );
  }
}
