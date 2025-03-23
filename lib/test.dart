// // import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
// // import 'package:arrowspeed/featuers/profile/domin/entities/passenger.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:arrowspeed/core/app_colors/app_colors.dart';
// // import 'package:arrowspeed/core/translation/translation.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:arrowspeed/featuers/profile/presentation/controllers/passenger_controller.dart';

// // class PassengersListScreen extends GetView<PassengerController> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('إدارة الركاب'),
// //         backgroundColor: Colors.deepPurple,
// //       ),
// //       body: Column(
// //         children: [
// //           // قائمة الركاب
// //           Expanded(
// //             child: StreamBuilder<List<PassengerModel>>(
// //               stream: controller.streamPassengers(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(
// //                       child:
// //                           CircularProgressIndicator(color: Colors.deepPurple));
// //                 } else if (snapshot.hasError) {
// //                   return Center(child: Text("حدث خطأ: ${snapshot.error}"));
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return Center(child: Text("لا توجد بيانات"));
// //                 } else {
// //                   final passengers = snapshot.data!;
// //                   return ListView.builder(
// //                     itemCount: passengers.length,
// //                     itemBuilder: (context, index) {
// //                       final passenger = passengers[index];
// //                       final isEditing =
// //                           controller.currentPassengerId.value == passenger.id;
// //                       return isEditing
// //                           ? _buildPassengerForm(context, passenger)
// //                           : _buildPassengerCard(context, passenger);
// //                     },
// //                   );
// //                 }
// //               },
// //             ),
// //           ),
// //           // مربع الإضافة
// //           Obx(() {
// //             return controller.isAddFormVisible.value
// //                 ? _buildAddForm(context)
// //                 : SizedBox();
// //             // : _buildAddButton(context);
// //           }),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPassengerForm(BuildContext context, PassengerModel passenger) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       margin: const EdgeInsets.only(bottom: 10),
// //       decoration: BoxDecoration(
// //         color: AppColors.white,
// //         boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: AppColors.greyborder),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildTextField(controller.nameController, Utils.localize('Name')),
// //           const SizedBox(height: 10),
// //           _buildTextField(controller.ageController, Utils.localize('Age'),
// //               isNumber: true),
// //           const SizedBox(height: 10),
// //           Row(
// //             children: [
// //               Text(Utils.localize('Gend'),
// //                   style: const TextStyle(fontSize: 14)),
// //               const Spacer(),
// //               // _buildGenderRadio(index, passenger, 'Male'),
// //               // _buildGenderRadio(index, passenger, 'Female'),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               _buildActionButton(
// //                   context, Utils.localize('Save'), AppColors.zomp, () {
// //                 controller.savePassenger();
// //               }),
// //               const SizedBox(width: 20),
// //               _buildActionButton(
// //                   context, Utils.localize('Cancel'), AppColors.red, () {
// //                 // showDeleteDialog(context, index);
// //               }),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton(
// //       BuildContext context, String text, Color color, VoidCallback onTap) {
// //     return Expanded(
// //       child: InkWell(
// //         onTap: onTap,
// //         child: Container(
// //           alignment: Alignment.center,
// //           padding: const EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //               color: color.withAlpha(150),
// //               borderRadius: BorderRadius.circular(10)),
// //           child: Text(text),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPassengerCard(BuildContext context, PassengerModel passenger) {
// //     return InkWell(
// //       onTap: () {
// //         // يمكنك ترك هذا الجزء فارغًا أو إضافة وظائف أخرى مثل عرض تفاصيل الراكب
// //       },
// //       onLongPress: () {
// //         controller.startEditing(passenger.id!); // بدء وضع التعديل
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.all(15),
// //         margin: const EdgeInsets.only(bottom: 10),
// //         decoration: BoxDecoration(
// //           color: AppColors.white,
// //           boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(color: AppColors.greyborder),
// //         ),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     passenger.name.isNotEmpty ? passenger.name : 'لا يوجد اسم',
// //                     style:
// //                         TextStyle(fontSize: 15, color: AppColors.prussianBlue),
// //                   ),
// //                   Text(
// //                     '${passenger.age.isNotEmpty ? passenger.age : 'غير محدد'} ${Utils.localize(passenger.gender.toString().split('.').last)}',
// //                     style:
// //                         TextStyle(fontSize: 12, color: AppColors.greyIconForm),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             InkWell(
// //               onTap: () => _showDeleteDialog(passenger.id!),
// //               child: SvgPicture.asset('assets/icons/delete.svg',
// //                   width: 20, height: 20, color: AppColors.red),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAddForm(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       margin: const EdgeInsets.all(10),
// //       decoration: BoxDecoration(
// //         color: AppColors.white,
// //         boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: AppColors.greyborder),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildTextField(controller.nameController, Utils.localize('Name')),
// //           const SizedBox(height: 10),
// //           _buildTextField(controller.ageController, Utils.localize('Age'),
// //               isNumber: true),
// //           const SizedBox(height: 10),
// //           Obx(() => DropdownButtonFormField<PassengerGender>(
// //                 value: controller.selectedGender.value,
// //                 onChanged: (value) {
// //                   controller.selectedGender.value = value!;
// //                 },
// //                 items: PassengerGender.values.map((gender) {
// //                   return DropdownMenuItem(
// //                     value: gender,
// //                     child:
// //                         Text(Utils.localize(gender.toString().split('.').last)),
// //                   );
// //                 }).toList(),
// //                 decoration: InputDecoration(
// //                     labelText: Utils.localize('Gender'),
// //                     border: OutlineInputBorder()),
// //               )),
// //           const SizedBox(height: 10),
// //           Obx(() {
// //             if (controller.isLoading.value) {
// //               return Center(
// //                   child: CircularProgressIndicator(color: Colors.deepPurple));
// //             }
// //             return Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () async {
// //                     await controller.savePassenger();
// //                     controller.isAddFormVisible.value =
// //                         false; // إخفاء مربع الإضافة بعد الحفظ
// //                   },
// //                   child: Text(Utils.localize('Save')),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.deepPurple,
// //                     minimumSize:
// //                         Size(MediaQuery.of(context).size.width * 0.4, 50),
// //                   ),
// //                 ),
// //                 OutlinedButton(
// //                   onPressed: () {
// //                     controller.cancelEdit();
// //                     controller.isAddFormVisible.value =
// //                         false; // إلغاء وإخفاء مربع الإضافة
// //                   },
// //                   child: Text(Utils.localize('Cancel')),
// //                   style: OutlinedButton.styleFrom(
// //                     foregroundColor: Colors.deepPurple,
// //                     minimumSize:
// //                         Size(MediaQuery.of(context).size.width * 0.4, 50),
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showDeleteDialog(String passengerId) {
// //     showDialog(
// //       context: Get.context!,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text(Utils.localize('DeletePassenger')),
// //           content: Text(Utils.localize('Areyousure')),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(Utils.localize('Cancel'),
// //                   style: TextStyle(color: Colors.grey)),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 await Get.find<PassengerController>()
// //                     .deletePassenger(passengerId);
// //                 Navigator.pop(context);
// //               },
// //               child: Text(Utils.localize('Delete'),
// //                   style: TextStyle(color: Colors.red)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildTextField(TextEditingController controller, String labelText,
// //       {bool isNumber = false}) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
// //       decoration:
// //           InputDecoration(labelText: labelText, border: OutlineInputBorder()),
// //     );
// //   }
// // }
// import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
// import 'package:arrowspeed/featuers/profile/domin/entities/passenger.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:arrowspeed/core/app_colors/app_colors.dart';
// import 'package:arrowspeed/core/translation/translation.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:arrowspeed/featuers/profile/presentation/controllers/passenger_controller.dart';

// class PassengersListScreen extends GetView<PassengerController> {
//   const PassengersListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(Utils.localize('PassengersList')),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           IconButton(
//             icon: SvgPicture.asset('assets/icons/plus.svg',
//                 width: 20, height: 20),
//             onPressed: () {
//               _showAddEditBottomSheet(context, isEditing: false);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         child: Obx(() {
//           final passengers = controller.passengers;
//           if (passengers.isEmpty) {
//             return Center(child: Text(Utils.localize('NoPassengers')));
//           }

//           return Column(
//             children: List.generate(
//               passengers.length,
//               (index) {
//                 final passenger = passengers[index];
//                 return _buildPassengerCard(context, passenger);
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   // بناء كارد العرض
//   Widget _buildPassengerCard(BuildContext context, PassengerModel passenger) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.greyborder),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   passenger.name.isNotEmpty
//                       ? passenger.name
//                       : Utils.localize('NoName'),
//                   style: TextStyle(fontSize: 15, color: AppColors.prussianBlue),
//                 ),
//                 Text(
//                   '${passenger.age.isNotEmpty ? passenger.age : Utils.localize('NotSpecified')} ${Utils.localize(passenger.gender.toString().split('.').last)}',
//                   style: TextStyle(fontSize: 12, color: AppColors.greyIconForm),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               _showAddEditBottomSheet(context,
//                   isEditing: true, passenger: passenger);
//             },
//             child: SvgPicture.asset('assets/icons/edit.svg',
//                 width: 20, height: 20, color: AppColors.oxfordBlue),
//           ),
//           const SizedBox(width: 10),
//           InkWell(
//             onTap: () => _showDeleteDialog(passenger.id!),
//             child: SvgPicture.asset('assets/icons/delete.svg',
//                 width: 20, height: 20, color: AppColors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   // نافذة الإضافة/التعديل
//   void _showAddEditBottomSheet(BuildContext context,
//       {bool isEditing = false, PassengerModel? passenger}) {
//     final controller = Get.find<PassengerController>();
//     if (isEditing && passenger != null) {
//       controller.nameController.text = passenger.name;
//       controller.ageController.text = passenger.age;
//       controller.selectedGender.value = passenger.gender;
//     } else {
//       controller.clearFields();
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: controller.nameController,
//                 decoration: InputDecoration(
//                     labelText: Utils.localize('Name'),
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: controller.ageController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                     labelText: Utils.localize('Age'),
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 16),
//               Obx(() => DropdownButtonFormField<PassengerGender>(
//                     value: controller.selectedGender.value,
//                     onChanged: (value) {
//                       controller.selectedGender.value = value!;
//                     },
//                     items: PassengerGender.values.map((gender) {
//                       return DropdownMenuItem(
//                         value: gender,
//                         child: Text(
//                             Utils.localize(gender.toString().split('.').last)),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                         labelText: Utils.localize('Gender'),
//                         border: OutlineInputBorder()),
//                   )),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (isEditing && passenger != null) {
//                         await controller.updatePassenger(passenger);
//                       } else {
//                         await controller.addPassenger();
//                       }
//                       Navigator.pop(context);
//                     },
//                     child: Text(isEditing
//                         ? Utils.localize('Update')
//                         : Utils.localize('Add')),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       minimumSize:
//                           Size(MediaQuery.of(context).size.width * 0.4, 50),
//                     ),
//                   ),
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text(Utils.localize('Cancel')),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.deepPurple,
//                       minimumSize:
//                           Size(MediaQuery.of(context).size.width * 0.4, 50),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // مربع حوار الحذف
//   void _showDeleteDialog(String passengerId) {
//     showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return AlertDialog(
//           icon: SvgPicture.asset(
//             'assets/icons/FAQ&Support.svg',
//             color: AppColors.red,
//             width: 40,
//             height: 40,
//           ),
//           title: Text(Utils.localize('DeletePassenger')),
//           content: Text(Utils.localize('Areyousure')),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(Utils.localize('Cancel'),
//                   style: TextStyle(color: Colors.grey)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await Get.find<PassengerController>()
//                     .deletePassenger(passengerId);
//                 Navigator.pop(context);
//               },
//               child: Text(Utils.localize('Delete'),
//                   style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }


//   void showDeleteDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           icon: SvgPicture.asset(
//             'assets/icons/FAQ&Support.svg',
//             color: AppColors.red,
//             width: 40,
//             height: 40,
//           ),
//           title: Text(Utils.localize('DeletePassenger')),
//           content: Text(Utils.localize('Areyousure')),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(Utils.localize('Cancel')),
//             ),
//             TextButton(
//               onPressed: () {
//                 controller.deletePassenger(index);
//                 Navigator.of(context).pop();
//               },
//               child: Text(Utils.localize('Delete'),
//                   style: const TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildPassengerForm(
//       BuildContext context, int index, Passenger passenger) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.greyborder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildTextField(passenger.nameController, Utils.localize('Name')),
//           const SizedBox(height: 10),
//           _buildTextField(passenger.ageController, Utils.localize('Age'),
//               isNumber: true),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Text(Utils.localize('Gend'),
//                   style: const TextStyle(fontSize: 14)),
//               const Spacer(),
//               _buildGenderRadio(index, passenger, 'Male'),
//               _buildGenderRadio(index, passenger, 'Female'),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildActionButton(
//                   context, Utils.localize('Save'), AppColors.zomp, () {
//                 controller.savePassenger(index);
//               }),
//               const SizedBox(width: 20),
//               _buildActionButton(
//                   context, Utils.localize('Cancel'), AppColors.red, () {
//                 showDeleteDialog(context, index);
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPassengerCard(
//       BuildContext context, int index, Passenger passenger) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.greyborder),
//       ),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(passenger.nameController.text,
//                   style: const TextStyle(
//                       fontSize: 15, color: AppColors.prussianBlue)),
//               Row(
//                 children: [
//                   Text(
//                       '${passenger.ageController.text} ${Utils.localize('years')}, ${Utils.localize(passenger.gender)}',
//                       style: TextStyle(
//                           fontSize: 12, color: AppColors.greyIconForm)),
//                 ],
//               ),
//             ],
//           ),
//           const Spacer(),
//           InkWell(
//             onTap: () => showDeleteDialog(context, index),
//             child: SvgPicture.asset('assets/icons/delete.svg',
//                 width: 20, height: 20, color: AppColors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String labelText,
//       {bool isNumber = false}) {
//     return TextField(
//       controller: controller,
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       decoration:
//           InputDecoration(labelText: labelText, border: OutlineInputBorder()),
//     );
//   }

//   Widget _buildGenderRadio(int index, Passenger passenger, String value) {
//     return Row(
//       children: [
//         Radio<String>(
//           value: value,
//           groupValue: passenger.gender,
//           onChanged: (val) => controller.updatePassengerGender(index, val!),
//         ),
//         Text(Utils.localize(value)),
//       ],
//     );
//   }

//   Widget _buildActionButton(
//       BuildContext context, String text, Color color, VoidCallback onTap) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: color.withAlpha(150),
//               borderRadius: BorderRadius.circular(10)),
//           child: Text(text),
//         ),
//       ),
//     );
//   }
// }
