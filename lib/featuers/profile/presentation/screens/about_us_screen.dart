// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('AboutUs'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logo/logo_blue_name.svg',
                        width: 150,
                      ),
                      SizedBox(height: 60),
                      Text(
                        Utils.localize('About'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      TermsAndConditions(),
                      SizedBox(height: 20),
                      PrivacyPolicy(),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(
                              "https://www.youtube.com/watch?v=yGJZFKr_1fk&list=RD8ZYw3eY1qlc&index=12"));
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                offset: Offset(0, 2),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/link.svg',
                                height: 24,
                                width: 24,
                                color: AppColors.oxfordBlue,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  Utils.localize('VisitourWebsite'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.oxfordBlue,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: AppColors.oxfordBlue),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/version.svg',
                              width: 15,
                              height: 15,
                              color: AppColors.zomp,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Utils.localize('Version'),
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.zomp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'v4.3',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.zomp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/logo/logo_color.png',
                        width: 150,
                        height: 150,
                        color: AppColors.greyHintForm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.localize('TermsandConditions'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.oxfordBlue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      Utils.localize('terms1'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('terms2'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('terms3'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('terms4'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('terms5'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('terms6'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 2),
              color: Colors.grey.withOpacity(0.2),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/file.svg',
              height: 24,
              width: 24,
              color: AppColors.oxfordBlue,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                Utils.localize('TermsandConditions'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.oxfordBlue,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.oxfordBlue),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.localize('PrivacyPolicy'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.oxfordBlue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      Utils.localize('privacy1'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('privacy2'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('privacy3'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('privacy4'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Utils.localize('privacy5'),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 2),
              color: Colors.grey.withOpacity(0.2),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/lock.svg',
              height: 24,
              width: 24,
              color: AppColors.oxfordBlue,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                Utils.localize('PrivacyPolicy'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.oxfordBlue,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.oxfordBlue),
          ],
        ),
      ),
    );
  }
}
