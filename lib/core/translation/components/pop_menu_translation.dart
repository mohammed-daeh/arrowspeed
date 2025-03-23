// ignore_for_file: prefer_const_constructors

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';

class PopMenuTranslation extends StatelessWidget {
  const PopMenuTranslation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: 0),
        color: AppColors.white,
        icon: Icon(
          Icons.language,
          size: 20,
        ),
        onSelected: (String languageCode) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            onTap: () {
              Utils.changeLanguage('en');
            },
            value: 'en',
            child: Text(Utils.localize('English')),
          ),
          PopupMenuItem<String>(
            onTap: () {
              Utils.changeLanguage('ar');
            },
            value: 'ar',
            child: Text(Utils.localize('Arabic')),
          ),
        ],
      ),
    );
  }
}
