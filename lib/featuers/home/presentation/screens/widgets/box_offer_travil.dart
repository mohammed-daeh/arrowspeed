import 'dart:async';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:arrowspeed/core/app_colors/app_colors.dart';

class BoxOfferTravilController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxInt currentIndex = 0.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (scrollController.hasClients) {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.offset;

        if (currentScroll < maxScroll) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0;
          scrollController.jumpTo(0);
        }

        scrollController.animateTo(
          currentIndex.value * 235.0,
          duration: Duration(milliseconds: 1800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    scrollController.dispose();
    super.onClose();
  }
}

class BoxOfferTravil extends StatelessWidget {
  const BoxOfferTravil({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxOfferTravilController>(
      init: BoxOfferTravilController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(Utils.localize('OfferTravel'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CardOfferTravil(
                    pathImag: 'assets/images/idleb.png',
                    from: 'Idleb',
                    to: 'Aleppo',
                    price: '1000',
                    currency: 'USD',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardOfferTravil extends StatelessWidget {
  final String pathImag;
  final String from;
  final String to;
  final String price;
  final String currency;

  const CardOfferTravil({
    super.key,
    required this.pathImag,
    required this.from,
    required this.to,
    required this.price,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        width: 220,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.grey1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Image.asset(pathImag,
                  height: 60, width: 60, fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(from,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.oxfordBlue,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      'assets/icons/arrow-right.svg',
                      width: 13,
                    ),
                    SizedBox(width: 5),
                    Text(
                      to,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.zomp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      currency,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
