import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/widgets/custom_snackbar.dart';
import 'package:taskflow/core/common/widgets/custom_text_field.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/security/presentation/manager/change_password_bloc/change_password_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _currentPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _currentPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.05, vertical: deviceHeight * 0.03),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Current Password',
                controller: _currentPasswordController,
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Password doesn\'t match';
                  }
                  return null;
                },
              ),
              SizedBox(height: deviceHeight * 0.02),
              CustomTextField(
                labelText: 'New Password',
                controller: _newPasswordController,
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: deviceHeight * 0.02),
              CustomTextField(
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Password must be at least 6 characters';
                  } else if (val != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: deviceHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ChangePasswordBloc>().add(ChangeMyPassword(_currentPasswordController.text, _newPasswordController.text));
                    }
                  },
                  child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                    listener: (context, state) {
                      if(state is ChangePasswordLoaded){
                        _newPasswordController.clear();
                        _currentPasswordController.clear();
                        _confirmPasswordController.clear();
                        CustomSnackBar.show(context, message: 'Password Changed Successfully', type: SnackBarType.success);
                      }
                      else if(state is ChangePasswordError){
                        CustomSnackBar.show(context, message: state.message, type: SnackBarType.error);
                      }
                    },
                    builder: (context, state) {
                      if(state is ChangePasswordLoading){
                        return CircularProgressIndicator();
                      }
                      return Text('Change Password');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
