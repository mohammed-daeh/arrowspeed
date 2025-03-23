// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher_pkg;

class FaqAndSupportScreen extends StatelessWidget {
  const FaqAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            HeaderScreensInItemsProfile(
              height: 100,
              title: Utils.localize('FAQ&Support'),
            ),
            TabBar(
              tabs: [
                Tab(
                  text: Utils.localize(
                    'FAQ',
                  ),
                ),
                Tab(
                  text: Utils.localize('Support'),
                ),
              ],
              labelColor: AppColors.mountainMeadow, // لون النص المحدد
              unselectedLabelColor:
                  AppColors.prussianBlue, // لون النص غير المحدد
              indicatorColor: AppColors.mountainMeadow,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FAQScreen(),
                  SupportScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      "question": "كيف يمكنني تسجيل حساب جديد؟",
      "answer":
          "يمكنك التسجيل من خلال النقر على زر التسجيل وملء البيانات المطلوبة."
    },
    {
      "question": "كيف يمكنني إعادة تعيين كلمة المرور؟",
      "answer":
          "انتقل إلى صفحة تسجيل الدخول واضغط على \"نسيت كلمة المرور\" واتبع الخطوات."
    },
    {
      "question": "هل التطبيق يدعم الوضع الليلي؟",
      "answer": "نعم، يمكنك التبديل بين الوضع الليلي والفاتح من الإعدادات."
    },
  ];

  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text(faqData[index]["question"]!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(faqData[index]["answer"]!),
                  )
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/logo/logo_color.png',
              width: 170,
              height: 170,
              color: AppColors.greyHintForm,
            ),
          ),
        ),
      ],
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _sendEmail(
      String recipientEmail, String subject, String body) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    if (await url_launcher_pkg.canLaunch(emailLaunchUri.toString())) {
      await url_launcher_pkg.launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch email client';
    }
  }

  Future<void> _sendWhatsAppMessage(BuildContext context,
      {required String phone, required String message}) async {
    String url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

    try {
      final theme = Theme.of(context);

      await custom_tabs.launchUrl(
        Uri.parse(url),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
            navigationBarColor: theme.colorScheme.surface,
          ),
          showTitle: true,
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
        ),
      );
    } catch (e) {
      throw 'Could not launch WhatsApp';
    }
  }

  Future<void> _phoneCall(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await url_launcher_pkg.canLaunch(phoneLaunchUri.toString())) {
      await url_launcher_pkg.launch(phoneLaunchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Utils.localize('ContactSupport'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textScaleFactor: 1.2,
              ),
              Text(
                Utils.localize('ContactSupport2'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textScaleFactor: 1.2,
              ),
              SizedBox(height: 120),
              ContainerContact(
                title: Utils.localize('call'),
                svgPath: 'assets/icons/phone.svg',
                onTap: () => _phoneCall('+352681565589'),
              ),
              SizedBox(height: 20),
              ContainerContact(
                title: Utils.localize('chat'),
                svgPath: 'assets/icons/message-square.svg',
                onTap: () => _sendWhatsAppMessage(context,
                    phone: '+306998310141', message: 'Hello!'),
              ),
              SizedBox(height: 20),
              ContainerContact(
                title: Utils.localize('mail'),
                svgPath: 'assets/icons/mail.svg',
                onTap: () => _sendEmail('mohammed.daeh@gmail.com',
                    'Support Inquiry', 'Hello, I need help with...'),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/logo/logo_color.png',
              width: 170,
              height: 170,
              color: AppColors.greyHintForm,
            ),
          ),
        ),
      ],
    );
  }
}

class ContainerContact extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String svgPath;

  const ContainerContact({
    super.key,
    required this.onTap,
    required this.title,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 1),
              color: Colors.grey.withOpacity(0.8),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            SvgPicture.asset(svgPath, width: 20, height: 20),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
