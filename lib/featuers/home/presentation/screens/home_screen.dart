// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/box_companies.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/box_search_travil.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/box_offer_travil.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/box_populer_routes.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/box_recent_searches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            child: Container(
              height: 200,
              decoration: BoxDecoration(color: AppColors.oxfordBlue),
            ),
          ),
          Positioned(
            right: 20,
            left: 20,
            top: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arrowspeed',
                        style: TextStyle(
                          height: 1,
                          color: AppColors.white,
                          fontSize: 25,
                        )),
                    Text(
                      Utils.localize('Book your bas!'),
                      style: TextStyle(
                        height: 1,
                        color: AppColors.mountainMeadow,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRouter.addTrip);
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mountainMeadow),
                        shape: BoxShape.circle),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/bell.svg',
                          color: AppColors.white,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Badge(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 95,
            right: 35,
            left: 35,
            child: BoxSearchTravil(),
          ),
          Positioned(
            right: 0,
            left: 20,
            top: 330,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BoxCompanies(),
                  SizedBox(
                    height: 10,
                  ),
                  BoxPopulerRoutes(),
                  SizedBox(
                    height: 10,
                  ),
                  BoxRecentSearches(),
                  SizedBox(
                    height: 10,
                  ),
                  BoxOfferTravil(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
