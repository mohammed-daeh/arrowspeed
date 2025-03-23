// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/data/models/ticket_model.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/map_controller.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/full_map_screen.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/ticket_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;

class CustomCardReservationActive extends StatelessWidget {
  final String iconCompany;
  final String company;
  final String from;
  final String to;
  final String km;
  final String time;
  final String tripPrice;
  final String stateOfTrip;
  final LatLng latLng;
  final String personCount;
  final String price;
  final String name;

  static int cardIdCounter = 1;
  late final String cardId;

  CustomCardReservationActive({
    super.key,
    required this.iconCompany,
    required this.company,
    required this.from,
    required this.to,
    required this.km,
    required this.time,
    required this.tripPrice,
    required this.stateOfTrip,
    required this.latLng,
    required this.personCount,
    required this.price,
    // required this.image,
    required this.name,
  }) {
    cardId = cardIdCounter.toString();
    cardIdCounter++;
  }

  final ticketData = TicketModel(
    bookingId: '',
    name: 'name',
    from: 'from',
    to: 'to',
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    passengersCount: '1',
    passengersNames: 'passengersNames',
    seatNumbers: 'seatNumbers',
    ticketNumber: 'ticketNumber',
    ticketFare: '500',
    info: 'info',
  );
  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;
    final MapController mapController = Get.put(MapController());

    String monthName = intl.DateFormat('MMMM', 'AR').format(DateTime.now());
    String year = intl.DateFormat('y').format(DateTime.now());

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.oxfordBlue,
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
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                        Text(
                          ' ${Utils.localize(from)} - ${Utils.localize(to)}',
                          style: TextStyle(
                            color: AppColors.greyborder,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.mountainMeadow.withAlpha(150),
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
                          padding: EdgeInsets.only(top: 5.0),
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
                                    Text(
                                      '$km km',
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
                                    SizedBox(width: 8),
                                    Text(
                                      tripPrice,
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
                        Obx(() {
                          if (mapController.userLocation.value == null) {
                            return Center(child: CircularProgressIndicator());
                          }

                          Future.delayed(Duration.zero, () {
                            mapController
                                .update(); 
                          });

                          return SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: mapController.userLocation.value!,
                                zoom: 12.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('current_location'),
                                  position: mapController.userLocation.value!,
                                  infoWindow:
                                      InfoWindow(title: 'Your Location'),
                                ),
                                Marker(
                                  markerId: MarkerId('destination'),
                                  position: latLng,
                                  infoWindow:
                                      InfoWindow(title: 'Departure Center'),
                                ),
                              },
                            ),
                          );
                        }),

                      
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            Utils.localize('Mapdetails'),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/map-pin.svg',
                                  color: AppColors.oxfordBlue,
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Utils.localize('Distance'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              
                                Obx(() => Text(
                                      mapController.calculateDistance(latLng),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ))
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => FullMapWidget(
                                   
                                      destination: latLng,
                                    ));
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/compass.svg',
                                    color: AppColors.oxfordBlue,
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    Utils.localize('Direction'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    Utils.localize('Clicktoviewmap'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Row(
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
                                      personCount,
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
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 28,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () => isExpanded.value = !isExpanded.value,
                              child: SvgPicture.asset(
                                'assets/icons/chevron-up.svg',
                                width: 18,
                                height: 18,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(TicketDetails(ticketData: ticketData));
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/info.svg',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ),
                          ],
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
