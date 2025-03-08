import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskati/core/extentions/extentions.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_style.dart';
import 'package:taskati/feature/profile/psge/profile_screen.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${AppLocalStorage.getCachedData("name")}",
              style: getTitleTextStyle(context, color: AppColors.primaryColor),
            ),
            Text(
              "Have a nice day",
              style: getBodyTextStyle(
                context,
              ),
            ),
          ],
        )),
        GestureDetector(
          onTap: () {
            context.pushTo(const ProfileScreen());
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(
                File(AppLocalStorage.getCachedData(AppLocalStorage.imagKey))),
            backgroundColor: AppColors.darkColor,
          ),
        )
      ],
    );
  }
}
