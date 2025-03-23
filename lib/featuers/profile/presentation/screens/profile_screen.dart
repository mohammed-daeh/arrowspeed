// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/main_page_controller.dart';
import 'package:arrowspeed/featuers/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:arrowspeed/featuers/profile/presentation/widgets/header_profile.dart';
import 'package:arrowspeed/featuers/profile/presentation/widgets/card_items_profile.dart';
import 'package:arrowspeed/featuers/profile/presentation/widgets/log_out_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<EditProfileController> {
const  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => HeaderProfile(
            widget: CircleAvatar(
              radius: 40,
              backgroundImage: controller.profilePhoto.value.isNotEmpty
                  ? (controller.profilePhoto.value.startsWith("http")
                          ? NetworkImage(controller.profilePhoto.value)
                          : FileImage(File(controller.profilePhoto.value)))
                      as ImageProvider
                  : AssetImage("assets/logo/logo_color.png") as ImageProvider,
            ),

            firstName: controller.firstName.value.isEmpty
                ? controller.originalUser?.firstName ?? "الاسم غير متوفر"
                : controller.firstName.value,
            lastName: controller.lastName.value.isEmpty
                ? controller.originalUser?.lastName ?? "الاسم غير متوفر"
                : controller.lastName.value,
            email: controller.email.value,
          ),
        ),
        CardItemsProfile(
          title: Utils.localize('Bookings'),
          pathIcon: 'assets/icons/reservation.svg',
          onTap: () {
            final BottomNavController controller = Get.find();
            controller.changeTabIndex(2);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('PassengersList'),
          pathIcon: 'assets/icons/Passengers_List.svg',
          onTap: () {
            Get.toNamed(AppRouter.passengersList);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('Wallet'),
          pathIcon: 'assets/icons/Wallet.svg',
          onTap: () {
            Get.toNamed(AppRouter.wallet);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('Refer&Eam'),
          pathIcon: 'assets/icons/Refer&Eam.svg',
          onTap: () {
            Get.toNamed(AppRouter.refer);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('Offers'),
          pathIcon: 'assets/icons/Offers.svg',
          onTap: () {
            Get.toNamed(AppRouter.offer);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('FAQ&Support'),
          pathIcon: 'assets/icons/FAQ&Support.svg',
          onTap: () {
            Get.toNamed(AppRouter.faq);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('Settings'),
          pathIcon: 'assets/icons/Settings.svg',
          onTap: () {
            Get.toNamed(AppRouter.settings);
          },
        ),
        CardItemsProfile(
          title: Utils.localize('Logout'),
          pathIcon: 'assets/icons/log-out.svg',
          onTap: () async {
            Get.dialog(LogOutDialogWidget());
          },
        ),
        CardItemsProfile(
          title: Utils.localize('AboutUs'),
          pathIcon: 'assets/icons/AboutUs.svg',
          onTap: () {
            Get.toNamed(AppRouter.about);
          },
        ),
      ],
    );
  }
}
