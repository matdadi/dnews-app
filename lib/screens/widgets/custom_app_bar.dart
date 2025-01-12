import 'package:deltanews/screens/auth/login/login_screen.dart';
import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:deltanews/screens/auth/register/register_screen.dart';
import 'package:deltanews/screens/search/search_screen.dart';
import 'package:deltanews/screens/widgets/costum_dialog_content.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomAppBar extends StatefulWidget {
  final bool hasBackButton;
  final bool? hasAuthButton;
  final IconData? icon;
  final VoidCallback? onIconPressed;
  final bool? hasSearch;
  const CustomAppBar({
    super.key,
    this.hasBackButton = false,
    this.hasSearch = true,
    this.hasAuthButton = true,
    this.icon,
    this.onIconPressed,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthEvent.getIsLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.hasBackButton
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_outlined))
                    : SizedBox(
                        width: 16.h,
                      ),
                // Text(
                //   'DNEWS',
                //   style: GoogleFonts.inter(
                //       color: primaryColor,
                //       fontSize: 24.sp,
                //       fontWeight: FontWeight.bold),
                // ),
                Image.asset("assets/images/logo.png", height: 60.h),
              ],
            ),
            Row(
              children: [
                widget.hasAuthButton!
                    ? BlocConsumer<AuthBloc, AuthState>(
                        listenWhen: (previous, current) =>
                            previous.logoutState != current.logoutState,
                        listener: (context, state) =>
                            state.logoutState.maybeWhen(
                              orElse: () {
                                return;
                              },
                              success: () {
                                _showDialog('Berhasil!',
                                    "Anda berhasil keluar...", 'Ok', () {
                                  context
                                      .read<AuthBloc>()
                                      .add(const AuthEvent.getIsLoggedIn());
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(true);
                                });

                                return;
                              },
                            ),
                        buildWhen: (previous, current) =>
                            previous.isLoggedIn != current.isLoggedIn ||
                            previous.logoutState != current.logoutState,
                        builder: (context, state) {
                          return state.isLoggedIn
                              ? TextButton(
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(const AuthEvent.logout());
                                  },
                                  child: state.logoutState.maybeWhen(
                                      orElse: () => Text(
                                            'Keluar',
                                            style: GoogleFonts.inter(
                                                color: primaryColor),
                                          ),
                                      loading: () => SizedBox(
                                            width: 8.h,
                                            height: 8.h,
                                            child:
                                                const CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          )))
                              : Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          pushWithNavBar(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()))
                                              .then((_) {
                                            if (context.mounted) {
                                              context.read<AuthBloc>().add(
                                                  const AuthEvent
                                                      .getIsLoggedIn());
                                            }
                                          });
                                        },
                                        child: Text(
                                          'Masuk',
                                          style: GoogleFonts.inter(
                                              color: primaryColor),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          pushWithNavBar(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const RegisterScreen()));
                                        },
                                        child: Text(
                                          'Daftar',
                                          style: GoogleFonts.inter(
                                              color: primaryColor),
                                        )),
                                  ],
                                );
                        })
                    : const SizedBox.shrink(),
                widget.hasSearch!
                    ? IconButton(
                        onPressed: widget.onIconPressed ??
                            () {
                              pushWithoutNavBar(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const SearchScreen(),
                                  ));
                            },
                        icon: widget.icon == null
                            ? SvgPicture.asset('assets/icons/icon_search.svg')
                            : Icon(widget.icon))
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
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
