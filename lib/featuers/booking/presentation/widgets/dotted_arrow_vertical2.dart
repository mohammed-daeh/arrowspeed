// // ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

// import 'package:arrowspeed/core/app_colors/app_colors.dart';
// import 'package:flutter/material.dart';

// class DottedArrowPainterVertical extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint linePaint = Paint()
//       ..color = AppColors.zomp // يمكنك تغيير اللون هنا
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     // رسم الخط المنقط العمودي
//     double dashWidth = 3;
//     double dashSpace = 2.5;
//     double startX = size.width / 1; // تحديد مركز الخط في الاتجاه العمودي
//     double startY = size.height - 0; // البداية من الأسفل
//     while (startY > 0) {
//       // رسم الخط المنقط
//       canvas.drawLine(
//         Offset(startX, startY),
//         Offset(startX, startY - dashWidth), // تغيير إحداثيات Y
//         linePaint,
//       );
//       startY -= dashWidth + dashSpace;
//     }

//     // رسم السهم في الأعلى (اتجاه عمودي)
//     final Paint arrowPaint = Paint()
//       ..color = AppColors.zomp // نفس اللون للسهم
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;

//     Path arrowPath = Path();
//     arrowPath.moveTo(size.width / 1, size.height); // بداية السهم في الأسفل
//     arrowPath.lineTo(
//         size.width / 2 - 2, size.height - 4); // الجزء الأيسر من السهم
//     arrowPath.lineTo(
//         size.width / 2 + 2, size.height - 4); // الجزء الأيمن من السهم
//     arrowPath.close();
//     canvas.drawPath(arrowPath, arrowPaint);

//     // رسم النقطة في الأعلى
//     // final Paint circlePaint = Paint()..color = ColorsApp.greenLight;
//     // canvas.drawCircle(
//     //     Offset(size.width / 5, 0), 3, circlePaint); // الدائرة في الأعلى
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
