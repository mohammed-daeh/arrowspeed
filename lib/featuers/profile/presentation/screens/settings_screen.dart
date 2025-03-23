import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/components/pop_menu_translation.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            title: Utils.localize('Settings'),
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            decoration: BoxDecoration(color: AppColors.white, boxShadow: [
              BoxShadow(
                color: AppColors.greyHintForm,
                blurRadius: 10,
              )
            ]),
            child: Row(
              children: [
                Text(
                  Utils.localize('Chooselanguage'),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                PopMenuTranslation()
              ],
            ),
          ),
        
          SizedBox(
            height: 20,
          ),
       
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
