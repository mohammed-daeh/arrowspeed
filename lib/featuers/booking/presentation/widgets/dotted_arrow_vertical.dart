import 'dart:ui';
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashedArrowVirticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.zomp
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    // تحديد ما إذا كانت اللغة عربية أم لا
    final isArabic = Get.locale?.languageCode == 'ar';

    // رسم منحنى متعرج بناءً على اللغة
    path.moveTo(size.width / 3, 0); // البداية
    if (isArabic) {
      // في اللغة العربية نغير الاتجاه
      path.quadraticBezierTo(
        size.width / 1, // نقطة التحكم الأولى
        size.height * 0, // نقطة التحكم الأولى
        size.width / 1, // النهاية
        size.height * 0.5, // النهاية
      );
      path.quadraticBezierTo(
        size.width / 1, // نقطة التحكم الثانية
        size.height * 0.9, // نقطة التحكم الثانية
        size.width * 0.5, // النهاية
        size.height * 1, // النهاية
      );
    } else {
      // في اللغة الإنجليزية، الاتجاه العادي
      path.quadraticBezierTo(
        size.width * -0, // نقطة التحكم الأولى (منتصف العرض باتجاه اليسار)
        size.height * 0.1, // نقطة التحكم الأولى (ربع الارتفاع)
        size.width / -15, // النهاية (منتصف العرض)
        size.height * 0.5, // النهاية (منتصف الارتفاع)
      );
      path.quadraticBezierTo(
        size.width * -0.01, // نقطة التحكم الثانية (أقرب إلى المركز)
        size.height * 0.9, // نقطة التحكم الثانية (3/4 الارتفاع)
        size.width * 0.5, // النهاية (منتصف العرض)
        size.height, // النهاية (أسفل الشكل)
      );
    }

    // رسم الخط المتقطع
    double dashWidth = 6, dashSpace = 5;
    Path dashedPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);

    // رسم الدائرة
    canvas.drawCircle(
      Offset(isArabic ? size.width / 3 : size.width / 1.5,
          0), // تحريكها لليمين عند الإنجليزية
      4, // نصف القطر
      Paint()..color = AppColors.mountainMeadow,
    );

    // رسم السهم بناءً على اتجاه اللغة
    final arrowPath = Path()
      ..moveTo(size.width / 2, size.height - 5)
      ..lineTo(
          isArabic ? size.width / 2 - 10 : size.width / 2 + 10, size.height)
      ..lineTo(isArabic ? size.width / 2 : size.width * 0.5, size.height + 5)
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = AppColors.mountainMeadow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
