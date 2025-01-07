import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:deltanews/screens/widgets/costum_dialog_content.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/screens/widgets/custom_text_form_field.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.loginState != current.loginState,
        listener: (context, state) {
          state.loginState.maybeWhen(
              orElse: () {},
              success: () {
                showCustomDialog(
                    context, 'Berhasil', 'Anda berhasil masuk..', 'Ok', () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                  Navigator.pop(context);
                });
              },
              error: (message) => _showDialog(
                  'Error',
                  message,
                  'Coba Lagi',
                  isError: true,
                  () => Navigator.of(context, rootNavigator: true).pop(true)));
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  hasAuthButton: false,
                  hasBackButton: true,
                  hasSearch: false,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Text(
                    'Masuk',
                    style: GoogleFonts.inter(
                        color: primaryColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      children: [
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: CustomTextFormField(
                            controller: _emailController,
                            title: 'Username',
                            validator: (p0) {
                              if (p0 == '' || p0 == null) {
                                return 'Username tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: CustomTextFormField(
                            controller: _passwordController,
                            title: 'Password',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (p0.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                            isObsecure: true,
                          ),
                        ),
                        SizedBox(height: 60.h),
                        SizedBox(
                          width: double.infinity,
                          height: 35.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                backgroundColor: primaryColor),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _formKey.currentState?.validate();
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(AuthEvent.login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ));
                                }
                              });
                            },
                            child: state.loginState.maybeWhen(
                                orElse: () => Text('Masuk',
                                    style: GoogleFonts.inter(
                                        fontSize: 16.sp, color: Colors.white)),
                                loading: () => SizedBox(
                                      width: 16.h,
                                      height: 16.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        });
  }

  Future<bool> _showDialog(
      String title, String description, String text, void Function() onPressed,
      {bool? isError = false}) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxWithButton(
              title: title,
              description: description,
              confirmTextButton: text,
              onPressed: onPressed,
              isError: isError!,
            );
          },
        ) ??
        false;
  }
}
