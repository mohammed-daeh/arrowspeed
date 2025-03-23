// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DottedLineWithIcons extends StatelessWidget {
  final String middleIconPath;

  const DottedLineWithIcons({super.key, required this.middleIconPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.greyback, 
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              CustomPaint(
                painter: DashedLinePainter(),
                size: Size(80, 3),
              ),
              SvgPicture.asset(
                Get.locale?.languageCode == 'en'
                    ? 'assets/icons/arrow-right.svg' 
                    : 'assets/icons/arrow-left.svg', 
                width: 12,
                height: 12,
                color: AppColors.greyback,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: SvgPicture.asset(
            middleIconPath,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.greyback
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashWidth = 6;
    const dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
