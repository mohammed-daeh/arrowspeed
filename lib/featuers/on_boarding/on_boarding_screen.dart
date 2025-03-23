// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<Map<String, String>> mapOnBoarding = [
    {
      'title': 'title1',
      'description1': 'description1',
      'description2': 'description4',
      'image': 'assets/images/01.jpg',
    },
    {
      'title': 'title2',
      'description1': 'description2',
      'description2': 'description5',
      'image': 'assets/images/02.jpg',
    },
    {
      'title': 'title3',
      'description1': 'description3',
      'description2': 'description6',
      'image': 'assets/images/03.jpg',
    },
  ];
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildDot({required int index}) {
    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentPage == index ? 32 : 8,
        decoration: BoxDecoration(
          color: _currentPage == index ? AppColors.oxfordBlue : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 40,
            child: PageView.builder(
                onPageChanged: _onPageChanged,
                controller: _pageController,
                itemCount: mapOnBoarding.length,
                itemBuilder: (context, index) {
                  return Stack(clipBehavior: Clip.none, children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      height: 553,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                              mapOnBoarding[index]['image'].toString()),
                          fit: BoxFit.cover, // تغطية كاملة للصورة
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 130,
                      right: 15,
                      left: 15,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Utils.localize(
                                      mapOnBoarding[index]['title'].toString()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Utils.localize(mapOnBoarding[index]
                                          ['description1']
                                      .toString()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  Utils.localize(mapOnBoarding[index]
                                          ['description2']
                                      .toString()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      left: 20,
                      bottom: 40,
                      child: Column(
                        children: [
                          if (_currentPage != 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear,
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 148,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.oxfordBlue,
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                    child: Text(
                                      Utils.localize('Next'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      2,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.linear,
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.greyborder,
                                      ),
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                    width: 148,
                                    height: 48,
                                    child: Text(
                                      Utils.localize('Skip'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.greyborder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(AppRouter.signUp);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 297,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.zomp,
                                    borderRadius: BorderRadius.circular(48),
                                  ),
                                  child: Text(
                                    Utils.localize('LetsStartNow'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]);
                }),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mapOnBoarding.length, (index) {
              return _buildDot(index: index);
            }),
          ),
        ],
      ),
    );
  }
}
