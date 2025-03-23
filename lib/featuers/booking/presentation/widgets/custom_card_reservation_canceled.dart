// ignore_for_file: prefer_const_constructors, must_be_immutable, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/presentation/widgets/dotted_arrow_vertical.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart" as intl;

class CustomCardReservationCanceled extends StatelessWidget {
  final String image;
  final String name;
  final String from;
  final String to;
  final String stateOfTrip;
  // final String km;
  final String time;
  final String price;
  final String person;

  static int cardIdCounter = 1;
  late final String cardId;

  CustomCardReservationCanceled({
    super.key,
    required this.image,
    required this.name,
    required this.from,
    required this.to,
    required this.stateOfTrip,
    // required this.km,
    required this.time,
    required this.price,
    required this.person,
  }) {
    cardId = cardIdCounter.toString();
    cardIdCounter++;
  }

  String data = 'دمشق - حلب';

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;

    // String day = intl.DateFormat('d').format(DateTime.now());
    String monthName = intl.DateFormat('MMMM', 'AR').format(DateTime.now());
    String year = intl.DateFormat('y').format(DateTime.now());
    // final String formattedTime =
    //     intl.DateFormat('hh:mm a', 'en').format(DateTime.now());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 10)],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: Column(
            children: [
              // الجزء الأول: الرأس
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    // الصورة الدائرية
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.oxfordBlue,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.white,
                        maxRadius: 25,
                        child: Image.asset('assets/logo/logo_color.png'),
                      ),
                    ),
                    SizedBox(width: 8),
                    // تفاصيل الرحلة
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                        Text(
                          ' ${Utils.localize('ATrip')} $from - $to',
                          style: TextStyle(
                            color: AppColors.greyborder,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // حالة الرحلة
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.red.withAlpha(150),
                      ),
                      child: Text(
                        stateOfTrip,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Divider(height: 1, color: AppColors.greyback),
              ),
              Obx(() {
                return Stack(clipBehavior: Clip.none, children: [
                  AnimatedCrossFade(
                    firstChild: InkWell(
                      onTap: () => isExpanded.value = !isExpanded.value,
                      child: SvgPicture.asset('assets/icons/chevron-down.svg'),
                    ),
                    secondChild: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.oxfordBlue,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/map-pin.svg',
                                        color: AppColors.white,
                                        width: 10,
                                        height: 10,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Text(
                                    //   '$km km',
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.oxfordBlue,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/time.svg',
                                        color: AppColors.white,
                                        width: 10,
                                        height: 10,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$time دقيقة',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.oxfordBlue,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/dollar.svg',
                                        color: AppColors.white,
                                        width: 10,
                                        height: 10,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      price,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyback,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 15, left: 15),
                          child: Row(
                            children: [
                              CustomPaint(
                                size: Size(35, 60),
                                painter: DashedArrowVirticalPainter(),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/current_location.svg',
                                        width: 25,
                                        height: 25,
                                        color: AppColors.oxfordBlue,
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Utils.localize('Busorigin'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            data,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.greyIconForm,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 27),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/map-pin.svg',
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Utils.localize('Busdestination'),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            data,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.greyIconForm,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.mountainMeadow.withAlpha(150),
                            ),
                            child: Text(
                              Utils.localize('Rebooking'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/date.svg',
                                    color: AppColors.oxfordBlue,
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$monthName $year',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/Passengers_List.svg',
                                    color: AppColors.oxfordBlue,
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    person,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/dollar.svg',
                                    color: AppColors.oxfordBlue,
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    price,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => isExpanded.value = !isExpanded.value,
                          child:
                              SvgPicture.asset('assets/icons/chevron-up.svg'),
                        ),
                      ],
                    ),
                    crossFadeState: isExpanded.value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  isExpanded.value
                      ? Positioned(
                          left: -15,
                          right: -15,
                          bottom: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.greyback,
                                ),
                              ),
                              Flexible(
                                child: CustomPaint(
                                  painter: DashedLinePainter(),
                                  size: const Size(double.infinity, 3),
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.greyback,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ]);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// رسام الخط المنقط
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
