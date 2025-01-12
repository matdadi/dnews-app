import 'package:deltanews/providers/home/home_provider.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class KategoriButton extends StatelessWidget {
  final String title;
  final bool isActive;
  const KategoriButton({super.key, this.isActive = false, required this.title});

  @override
  Widget build(BuildContext context) {
    // final NotificationHelper notificationHelper = NotificationHelper();

    return ElevatedButton(
      style: isActive
          ? ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              overlayColor: Colors.grey,
            )
          : ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(
                width: 2.0,
                color: primaryColor,
              ),
            ),
      onPressed: () async {
        // Ubah kategori di provider dan muat data baru
        context.read<HomeProvider>().setCategory(title);
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12.sp, color: isActive ? Colors.white : primaryColor),
      ),
    );
  }
}
