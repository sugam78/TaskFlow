
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/common/cubit/password_visibility/password_visibility_cubit.dart';
import 'package:taskflow/core/resources/app_colors.dart';


class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.controller,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: BlocBuilder<PasswordVisibilityCubit, bool>(
        builder: (context, isObscured) {
          return TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            obscureText: isPassword ? isObscured : false,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  context.read<PasswordVisibilityCubit>().toggleVisibility();
                },
              )
                  : null,
            ),
            validator: validator,
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
