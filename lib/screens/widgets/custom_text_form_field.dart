import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.title,
      this.validator,
      this.helperText,
      this.isObsecure = false});

  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final bool? isObsecure;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                previous.isObsecure != current.isObsecure,
            builder: (context, state) {
              return TextFormField(
                controller: controller,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: validator,
                obscureText: isObsecure!
                    ? state.isObsecure
                        ? true
                        : false
                    : false,
                decoration: InputDecoration(
                  helperText: helperText,
                  suffixIcon: isObsecure!
                      ? IconButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEvent.toggleObsecure());
                          },
                          icon: state.isObsecure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off))
                      : null,
                  isDense: true,
                  hintText: 'Masukkan $title Anda',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
