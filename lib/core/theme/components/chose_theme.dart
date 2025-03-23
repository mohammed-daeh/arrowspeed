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




// import 'package:arrowspeed/core/app_colors/app_colors.dart';
// import 'package:arrowspeed/core/theme/theme_controller.dart';
// import 'package:arrowspeed/core/theme_controller.dart';
// import 'package:arrowspeed/core/translation/translation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PopMenuTheme extends StatelessWidget {
//   const PopMenuTheme({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       color: AppColors.white,
//       icon: Icon(Icons.color_lens),
//       onSelected: (String themeChoice) {
//         // تغيير الثيم بناءً على الاختيار
//         if (themeChoice == 'light') {
//           Get.find<ThemeController>().setTheme(ThemeMode.light);
//         } else if (themeChoice == 'dark') {
//           Get.find<ThemeController>().setTheme(ThemeMode.dark);
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//         PopupMenuItem<String>(
//           onTap: () {
//             Get.find<ThemeController>().setTheme(ThemeMode.light); // تعيين الثيم الفاتح
//           },
//           value: 'light',
//           child: Text(Utils.localize('Light Theme')),
//         ),
//         PopupMenuItem<String>(
//           onTap: () {
//             Get.find<ThemeController>().setTheme(ThemeMode.dark); // تعيين الثيم الداكن
//           },
//           value: 'dark',
//           child: Text(Utils.localize('Dark Theme')),
//         ),
//       ],
//     );
//   }
// }


// import 'package:arrowspeed/core/theme/theme_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChoseTheme extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find();
// // return PopupMenuButton(itemBuilder: itemBuilder)
//     return Scaffold(
//       body: Card(
//         margin: EdgeInsets.all(20),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: ListTile(
//           leading: Icon(Icons.color_lens),
//           title: Text("تغيير الثيم"),
//           trailing: Icon(Icons.arrow_drop_down),
//           onTap: () => _showThemeSelection(context, themeController),
//         ),
//       ),
//     );
//   }

//   /// **عرض القائمة المنبثقة لاختيار الثيم**
//   void _showThemeSelection(BuildContext context, ThemeController themeController) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("اختر الثيم", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 16),
//               _buildThemeOption(
//                 context,
//                 title: "ثيم فاتح",
//                 icon: Icons.wb_sunny,
//                 isSelected: !themeController.isDarkMode.value,
//                 onTap: () {
//                   themeController.setLightTheme();
//                   Get.back(); // إغلاق القائمة
//                 },
//               ),
//               SizedBox(height: 10),
//               _buildThemeOption(
//                 context,
//                 title: "ثيم داكن",
//                 icon: Icons.nightlight_round,
//                 isSelected: themeController.isDarkMode.value,
//                 onTap: () {
//                   themeController.setDarkTheme();
//                   Get.back(); // إغلاق القائمة
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// **عنصر زر اختيار الثيم**
//   Widget _buildThemeOption(BuildContext context, {required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
//       title: Text(title, style: TextStyle(fontSize: 16)),
//       trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
//       onTap: onTap,
//     );
//   }
// }
