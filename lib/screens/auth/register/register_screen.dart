import 'package:deltanews/data/models/register_param.dart';
import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:deltanews/screens/widgets/custom_app_bar.dart';
import 'package:deltanews/screens/widgets/custom_text_form_field.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:deltanews/utils/function_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.registerState != current.registerState,
        listener: (context, state) {
          state.registerState.maybeWhen(
              orElse: () {},
              success: () {
                showCustomDialog(
                    context,
                    'Berhasil',
                    'Anda berhasil mendaftar, silahkan menuju halaman login untuk masuk',
                    'Ok', () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                  Navigator.pop(context);
                });
              },
              error: (message) => showCustomDialog(
                  context,
                  'Error',
                  message,
                  'Coba Lagi',
                  isError: true,
                  () => Navigator.of(context, rootNavigator: true).pop(true)));
        },
        buildWhen: (previous, current) =>
            previous.registerState != current.registerState,
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
                    'Daftar',
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
                                  controller: _firstNameController,
                                  title: 'Nama Awal',
                                  validator: (p0) {
                                    if (p0 == '' || p0 == null) {
                                      return 'Nama awal tidak boleh kosong';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: CustomTextFormField(
                                  controller: _lastNameController,
                                  title: 'Nama Akhir',
                                  helperText: 'Dapat Dikosongkan',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: CustomTextFormField(
                                  controller: _usernameController,
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
                                  controller: _emailController,
                                  title: 'Email',
                                  validator: (p0) {
                                    if (p0 == '' || p0 == null) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    if (!isValidEmail(p0)) {
                                      return 'Email tidak valid';
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
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: CustomTextFormField(
                                  controller: _passwordConfirmationController,
                                  title: 'Konfirmasi Password',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Konfirmasi password tidak boleh kosong';
                                    }
                                    if (p0 != _passwordController.text) {
                                      return 'Konfirmasi password tidak sesuai';
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
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      backgroundColor: primaryColor),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _formKey.currentState?.validate();
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<AuthBloc>()
                                            .add(AuthEvent.register(
                                              param: RegisterParam(
                                                firstName:
                                                    _firstNameController.text,
                                                lastName:
                                                    _lastNameController.text,
                                                username: _usernameController
                                                    .text
                                                    .toLowerCase(),
                                                email: _emailController.text
                                                    .toLowerCase(),
                                                password:
                                                    _passwordController.text,
                                              ),
                                            ));
                                      }
                                    });
                                  },
                                  child: state.registerState.maybeWhen(
                                      orElse: () => Text('Daftar',
                                          style: GoogleFonts.inter(
                                              fontSize: 16.sp,
                                              color: Colors.white)),
                                      loading: () => SizedBox(
                                            width: 16.h,
                                            height: 16.h,
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                                ),
                              ),
                              SizedBox(height: 60.h),
                            ],
                          ),
                        ))),
              ],
            ),
          );
        });
  }
}
