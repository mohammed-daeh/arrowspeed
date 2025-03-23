// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxCompanies extends StatefulWidget {
  @override
  _BoxCompaniesState createState() => _BoxCompaniesState();
}

class _BoxCompaniesState extends State<BoxCompanies> {
  List<Map<String, dynamic>> trips = [
    {
      'image': 'assets/images/a.png',
      'name': 'Aleepo',
      'destinations': [
        {'from': 'Cairo', 'to': 'Dubai', 'image': 'assets/images/idleb.png'},
        {
          'from': 'Paris',
          'to': 'New York',
          'image': 'assets/images/aleppo.png'
        },
        {'from': 'Cairo', 'to': 'Dubai', 'image': 'assets/images/idleb.png'},
        {'from': 'Cairo', 'to': 'Dubai', 'image': 'assets/images/idleb.png'},
      ]
    },
    {
      'image': 'assets/images/b.png',
      'name': 'Idleb',
      'destinations': [
        {'from': 'Tokyo', 'to': 'London', 'image': 'assets/images/aleppo.png'},
        {'from': 'Beijing', 'to': 'Sydney', 'image': 'assets/images/idleb.png'},
        {
          'from': 'Paris',
          'to': 'New York',
          'image': 'assets/images/aleppo.png'
        },
      ]
    },
    {
      'image': 'assets/images/c.png',
      'name': 'Aleepo',
      'destinations': [
        {'from': 'Berlin', 'to': 'Madrid', 'image': 'assets/images/idleb.png'},
        {
          'from': 'Paris',
          'to': 'New York',
          'image': 'assets/images/aleppo.png'
        },
        {'from': 'Rome', 'to': 'Lisbon', 'image': 'assets/images/aleppo.png'},
      ]
    },
    {
      'image': 'assets/images/d.png',
      'name': 'Damas',
      'destinations': [
        {
          'from': 'Paris',
          'to': 'New York',
          'image': 'assets/images/aleppo.png'
        },
        {'from': 'Moscow', 'to': 'Toronto', 'image': 'assets/images/idleb.png'},
        {'from': 'Seoul', 'to': 'Bangkok', 'image': 'assets/images/aleppo.png'},
        {
          'from': 'Paris',
          'to': 'New York',
          'image': 'assets/images/aleppo.png'
        },
      ]
    },
    {
      'image': 'assets/images/aleppo.png',
      'name': 'Latakia',
      'destinations': [
        {'from': 'Paris', 'to': 'New York', 'image': 'assets/images/a.png'},
        {'from': 'Moscow', 'to': 'Toronto', 'image': 'assets/images/b.png'},
        {'from': 'Seoul', 'to': 'Bangkok', 'image': 'assets/images/c.png'},
        {'from': 'Paris', 'to': 'New York', 'image': 'assets/images/d.png'},
      ]
    },
    {
      'image': 'assets/images/aleppo.png',
      'destinations': [
        {'from': 'Paris', 'to': 'New York', 'image': 'assets/images/a.png'},
        {'from': 'Moscow', 'to': 'Toronto', 'image': 'assets/images/b.png'},
        {'from': 'Seoul', 'to': 'Bangkok', 'image': 'assets/images/c.png'},
        {'from': 'Paris', 'to': 'New York', 'image': 'assets/images/d.png'},
      ]
    },
  ];

  RxInt selectedIndex = (-1).obs; 
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(trips.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      if (selectedIndex.value == index) {
                        selectedIndex.value = -1;
                      } else {
                        selectedIndex.value = index;
                      }
                    },
                    child: Column(
                      children: [
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: selectedIndex.value == index
                                      ? AppColors.zomp
                                      : AppColors.prussianBlue,
                                  width: selectedIndex.value == index ? 2 : 1),
                            ),
                            child: CircleAvatar(
                              radius: selectedIndex.value == index ? 30 : 25,
                              backgroundImage:
                                  AssetImage(trips[index]['image']),
                            ),
                          ),
                        ),
                        Obx(
                          () => Icon(
                            selectedIndex.value == index
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Obx(() {
            if (selectedIndex.value == -1) return SizedBox.shrink();
            return SizedBox(
              height: 130,
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(AppColors.oxfordBlue),
                  thickness: WidgetStateProperty.all(8),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: List.generate(
                        trips[selectedIndex.value]['destinations'].length,
                        (index) {
                          final trip =
                              trips[selectedIndex.value]['destinations'][index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(trip['image']),
                              ),
                              title: Text('${trip['from']} → ${trip['to']}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
//todo
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
