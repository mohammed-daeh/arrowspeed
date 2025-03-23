// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arrowspeed/core/app_colors/app_colors.dart';

class CostumBottomNavigationBar extends StatelessWidget {
  final List<dynamic> activeIcons;
  final List<dynamic> inactiveIcons;
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CostumBottomNavigationBar({
    Key? key,
    required this.activeIcons,
    required this.inactiveIcons,
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.oxfordBlue,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: isSelected ? 15 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isSelected ? AppColors.white : Colors.transparent,
              ),
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(
                      isSelected ? activeIcons[index] : inactiveIcons[index],
                      isSelected,
                    ),

                    // SvgPicture.asset(
                    //   isSelected ? activeIcons[index] : inactiveIcons[index],
                    //   color: isSelected ? AppColors.oxfordBlue : AppColors.grey,
                    //   width: 18,
                    //   height: 18,
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          Utils.localize(labels[index]),
                          style: TextStyle(
                            color: AppColors.oxfordBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIcon(dynamic iconData, bool isSelected) {
    if (iconData is String) {
      return SvgPicture.asset(
        iconData,
        color: isSelected ? AppColors.oxfordBlue : AppColors.grey,
        width: 18,
        height: 18,
      );
    } else if (iconData is IconData) {
      return Icon(
        iconData,
        color: isSelected ? AppColors.oxfordBlue : AppColors.grey,
        size: 20,
      );
    } else {
      return SizedBox(); // احتياطي لو النوع غلط
    }
  }
}
