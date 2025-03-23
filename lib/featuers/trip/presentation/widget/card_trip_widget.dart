// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/dotted_line_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

TimeOfDay parseTime(String time) {
  List<String> timeParts = time.split(":");
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

class CardTripWidget extends StatelessWidget {
  String company;
  String iconCompany;
  String serves;
  String discount;
  String from;
  String to;
  String dateFrom;
  String dateTo;
  String star;
  int totalSeats;
  double price;
  VoidCallback onTap;

  CardTripWidget(
      {super.key,
      required this.onTap,
      required this.company,
      required this.iconCompany,
      required this.serves,
      required this.discount,
      required this.from,
      required this.to,
      required this.dateFrom,
      required this.dateTo,
      required this.star,
      required this.totalSeats,
      required this.price});

  @override
  Widget build(BuildContext context) {
    TimeOfDay departureTime = parseTime(dateFrom);
    TimeOfDay arrivalTime = parseTime(dateTo);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        AppColors.oxfordBlue, 
                    radius: 20, 
                    foregroundColor: Colors.white, 
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        border: Border.all(
                          color: AppColors.oxfordBlue, 
                          width: 1, 
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          iconCompany, 
                          fit: BoxFit
                              .cover,
                          width: double.infinity, 
                          height:
                              double.infinity, 
                        ),
                      ),
                    ),
                  ),
                
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.oxfordBlue,
                        ),
                      ),
                      Text(
                        serves,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyIconForm,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '$discount %',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.oxfordBlue,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          from,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                        Text(
                          "${departureTime.hour}:${departureTime.minute}",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.greyborder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DottedLineWithIcons(
                    middleIconPath: 'assets/icons/bas_icon.svg',
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          to,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                        Text(
                          "${arrivalTime.hour}:${arrivalTime.minute}",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.greyborder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: AppColors.mountainMeadow.withAlpha(140),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  Utils.localize('book_now'),
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            CustomPaint(
              painter: DashedLinePainter(),
              size: const Size(double.infinity, 3),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/star.svg',
                          width: 15, height: 15, color: AppColors.yallow),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        star,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.oxfordBlue,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/user2.svg',
                        width: 15,
                        height: 15,
                        fit: BoxFit.scaleDown,
                        color: AppColors.oxfordBlue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        totalSeats.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.oxfordBlue,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Text(
                    '$price \$',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.prussianBlue),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
