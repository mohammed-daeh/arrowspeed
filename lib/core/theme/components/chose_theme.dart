import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arrowspeed/core/theme/theme_controller.dart';

class PopMenuTheme extends StatelessWidget {
  const PopMenuTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(Icons.palette),
      onSelected: (String value) {
        if (value == 'system') {
          themeController.setTheme(0); 
        } else if (value == 'light') {
          themeController.setTheme(1); 
        } else if (value == 'dark') {
          themeController.setTheme(2); 
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'system',
          child: Text("System Theme"),
        ),
        PopupMenuItem<String>(
          value: 'light',
          child: Text("Light Theme"),
        ),
        PopupMenuItem<String>(
          value: 'dark',
          child: Text("Dark Theme"),
        ),
      ],
    );
  }
}



