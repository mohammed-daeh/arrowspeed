// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class DottedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Color(0xff8747688)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // رسم الخط المنقط
    double dashWidth = 6;
    double dashSpace = 7.5;
    double startX = size.width - 3;
    double startY = size.height / 10;
    while (startX > 0) {
      //النهاية عند السهم
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX - dashWidth, startY),
        linePaint,
      );
      startX -= dashWidth + dashSpace;
    }

    // رسم السهم على اليسار
    final Paint arrowPaint = Paint()
      ..color = Color(0xff8747688)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path arrowPath = Path();
    arrowPath.moveTo(0, 0);
    arrowPath.lineTo(7, size.height / 2 - 4); // الخط العلوي
    arrowPath.lineTo(7, size.height / 2 + 4); // الخط السفلي
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);

    // رسم النقطة على اليمين
    final Paint circlePaint = Paint()..color = Color(0xff8747688);
    canvas.drawCircle(Offset(size.width + 0, size.height / 2), 5, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
