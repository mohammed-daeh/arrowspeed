// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/admin/presentation/controllers/admin_users_controller.dart';
import 'package:arrowspeed/admin/presentation/widgets/admin_drawer.dart';
import 'package:arrowspeed/admin/presentation/widgets/user_card_widget.dart';
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/domin/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

class AdminUsersScreen extends GetView<AdminUsersController> {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(child: AdminDrawer()),
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.oxfordBlue,
          title: Obx(() {
            return controller.isSearchVisible.value
                ? TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'بحث عن مستخدم',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: controller.searchQuery.call,
                  )
                : Text(
                    'إدارة المستخدمين',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  );
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () => _showAddUserDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: controller.fetchUsers,
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: controller.toggleSearchVisibility,
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Column(
          children: [
            // Filter Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              child: Obx(() {
                return SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'all', label: Text('الكل')),
                    ButtonSegment(
                      value: 'active',
                      label: Text('نشط'),
                      icon: Icon(Icons.check_circle, color: Colors.green),
                    ),
                    ButtonSegment(
                      value: 'inactive',
                      label: Text('غير نشط'),
                      icon: Icon(Icons.cancel, color: Colors.red),
                    ),
                  ],
                  selected: {controller.filter.value},
                  onSelectionChanged: (newSelection) {
                    if (newSelection.isNotEmpty) {
                      controller.setFilter(newSelection.first);
                    }
                  },
                  multiSelectionEnabled: false,
                  showSelectedIcon: false,
                  emptySelectionAllowed: false,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) =>
                        states.contains(MaterialState.selected)
                            ? AppColors.oxfordBlue.withOpacity(0.2)
                            : Colors.grey[200]),
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.selected)
                            ? AppColors.oxfordBlue
                            : Colors.black),
                  ),
                );
              }),
            ),

            // List or loading or empty state
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/loading.json',
                            width: 150, height: 150),
                        const SizedBox(height: 16),
                        const Text('جارٍ تحميل البيانات...'),
                      ],
                    ),
                  );
                }

                final users = controller.users;
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/empty.json',
                            width: 200, height: 200),
                        const SizedBox(height: 16),
                        const Text('لا توجد بيانات متاحة'),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // if (!controller.isSearchVisible.value)
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.oxfordBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'إجمالي المستخدمين:  ${users.length}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserCardWidget(
                            user: user,
                            onDelete: () => controller.deleteUser(user.id!),
                            onEdit: () => _showEditUserDialog(context, user),
                            onBlock: () => controller.toggleBlockUser(
                                user.id!, !user.isLogin),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    // ملء الحقول بالمعلومات الحالية للمستخدم
    controller.firstName.text = user.firstName;
    controller.lastName.text = user.lastName;
    controller.loginEmail.text = user.loginEmail;
    controller.authEmail.text = user.authEmail;
    controller.phoneNumber.text = user.phoneNumber;
    controller.passwordHash.text = ''; // كلمة المرور لا يتم عرضها لأسباب أمنية
    controller.selectedGender.value =
        user.gender == UserGender.male ? 'male' : 'female';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات المستخدم'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: controller.firstName,
                label: 'الاسم الأول',
                errorText: controller.firstNameError.value,
                onChanged: (_) => controller.validateField(
                  controller.firstName,
                  () => controller.validateName(controller.firstName.text),
                  controller.firstNameError,
                ),
              ),
              _buildTextField(
                controller: controller.lastName,
                label: 'الاسم الأخير',
                errorText: controller.lastNameError.value,
                onChanged: (_) => controller.validateField(
                  controller.lastName,
                  () => controller.validateName(controller.lastName.text),
                  controller.lastNameError,
                ),
              ),
              _buildTextField(
                controller: controller.loginEmail,
                label: 'البريد الإلكتروني (الشخصي)',
                errorText: controller.emailError.value,
                onChanged: (_) => controller.validateField(
                  controller.loginEmail,
                  () => controller.validateEmail(controller.loginEmail.text),
                  controller.emailError,
                ),
              ),
              _buildTextField(
                controller: controller.authEmail,
                label: 'البريد الإلكتروني (Gmail)',
                errorText: controller.gmailError.value,
                onChanged: (_) => controller.validateField(
                  controller.authEmail,
                  () => controller.validateGmail(controller.authEmail.text),
                  controller.gmailError,
                ),
              ),
              _buildTextField(
                controller: controller.passwordHash,
                label: 'كلمة المرور (اتركها فارغة إذا لم تكن تريد تعديلها)',
                obscureText: true,
                errorText: controller.passwordError.value,
                onChanged: (_) => controller.validateField(
                  controller.passwordHash,
                  () =>
                      controller.validatePassword(controller.passwordHash.text),
                  controller.passwordError,
                ),
              ),
              _buildTextField(
                controller: controller.phoneNumber,
                label: 'رقم الهاتف',
                errorText: controller.mobileNumberError.value,
                keyboardType: TextInputType.phone,
                onChanged: (_) => controller.validateField(
                  controller.phoneNumber,
                  () => controller.validateMobile(controller.phoneNumber.text),
                  controller.mobileNumberError,
                ),
              ),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedGender.value,
                    decoration: InputDecoration(
                      labelText: 'الجنس',
                      errorText: controller.genderError.value,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('ذكر')),
                      DropdownMenuItem(value: 'female', child: Text('أنثى')),
                    ],
                    onChanged: (value) {
                      controller.selectedGender.value = value!;
                      controller.genderError.value =
                          controller.validateGender();
                    },
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // إعادة تعيين الحقول عند الإلغاء
              controller.firstName.clear();
              controller.lastName.clear();
              controller.loginEmail.clear();
              controller.authEmail.clear();
              controller.phoneNumber.clear();
              controller.passwordHash.clear();
              controller.selectedGender.value = null;
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          Obx(() => TextButton(
                onPressed: () async {
                  if (controller.validateAll()) {
                    final updatedUser = UserModel(
                      id: user.id, // الاحتفاظ بالـ ID الأصلي
                      firstName: controller.firstName.text.trim(),
                      lastName: controller.lastName.text.trim(),
                      loginEmail: controller.loginEmail.text.trim(),
                      authEmail: controller.authEmail.text.trim(),
                      phoneNumber: controller.phoneNumber.text.trim(),
                      passwordHash: controller.passwordHash.text.isNotEmpty
                          ? controller.passwordHash.text
                          : user
                              .passwordHash, // تحديث كلمة المرور فقط إذا تم إدخالها
                      gender: controller.selectedGender.value == 'male'
                          ? UserGender.male
                          : UserGender.female,
                      isLogin: user.isLogin, // الاحتفاظ بالحالة الحالية للتسجيل
                      isVerified:
                          user.isVerified, // الاحتفاظ بالحالة الحالية للتحقق
                      otp: user.otp,
                      profilePhoto: user.profilePhoto,
                    );
                    await controller.updateUser(updatedUser);
                    Navigator.pop(context);
                  }
                },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('حفظ'),
              )),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة مستخدم جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: controller.firstName,
                label: 'الاسم الأول',
                errorText: controller.firstNameError.value,
                onChanged: (_) => controller.validateField(
                  controller.firstName,
                  () => controller.validateName(controller.firstName.text),
                  controller.firstNameError,
                ),
              ),
              _buildTextField(
                controller: controller.lastName,
                label: 'الاسم الأخير',
                errorText: controller.lastNameError.value,
                onChanged: (_) => controller.validateField(
                  controller.lastName,
                  () => controller.validateName(controller.lastName.text),
                  controller.lastNameError,
                ),
              ),
              _buildTextField(
                controller: controller.loginEmail,
                label: 'البريد الإلكتروني (الشخصي)',
                errorText: controller.emailError.value,
                onChanged: (_) => controller.validateField(
                  controller.loginEmail,
                  () => controller.validateEmail(controller.loginEmail.text),
                  controller.emailError,
                ),
              ),
              _buildTextField(
                controller: controller.authEmail,
                label: 'البريد الإلكتروني (Gmail)',
                errorText: controller.gmailError.value,
                onChanged: (_) => controller.validateField(
                  controller.authEmail,
                  () => controller.validateGmail(controller.authEmail.text),
                  controller.gmailError,
                ),
              ),
              _buildTextField(
                controller: controller.passwordHash,
                label: 'كلمة المرور',
                obscureText: true,
                errorText: controller.passwordError.value,
                onChanged: (_) => controller.validateField(
                  controller.passwordHash,
                  () =>
                      controller.validatePassword(controller.passwordHash.text),
                  controller.passwordError,
                ),
              ),
              _buildTextField(
                controller: controller.phoneNumber,
                label: 'رقم الهاتف',
                errorText: controller.mobileNumberError.value,
                keyboardType: TextInputType.phone,
                onChanged: (_) => controller.validateField(
                  controller.phoneNumber,
                  () => controller.validateMobile(controller.phoneNumber.text),
                  controller.mobileNumberError,
                ),
              ),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedGender.value,
                    decoration: InputDecoration(
                      labelText: 'الجنس',
                      errorText: controller.genderError.value,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('ذكر')),
                      DropdownMenuItem(value: 'female', child: Text('أنثى')),
                    ],
                    onChanged: (value) {
                      controller.selectedGender.value = value;
                      controller.genderError.value =
                          controller.validateGender();
                    },
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          Obx(() => TextButton(
                onPressed: () async {
                  if (controller.validateAll()) {
                    await controller.addUser();
                    Navigator.pop(context);
                  }
                },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('حفظ'),
              )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// class AdminUsersScreen extends GetView<AdminUsersController> {
//   const AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.find<AdminUsersController>();

//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         drawer: Drawer(child: AdminDrawer()),
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: AppColors.oxfordBlue,
//           title: Obx(() {
//             return controller.isSearchVisible.value
//                 ? TextField(
//                     autofocus: true,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'بحث عن مستخدم',
//                       hintStyle: TextStyle(color: Colors.white70),
//                       border: InputBorder.none,
//                     ),
//                     onChanged: controller.searchQuery,
//                   )
//                 : const Text('إدارة المستخدمين');
//           }),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.add_circle_outline, color: Colors.white),
//               onPressed: () => _showAddUserDialog(context),
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.white),
//               onPressed: controller.fetchUsers,
//             ),
//             IconButton(
//               icon: const Icon(Icons.search, color: Colors.white),
//               onPressed: controller.toggleSearchVisibility,
//             ),
//           ],
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(Icons.menu, color: Colors.white),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             // Filter Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Obx(() {
//                 return SegmentedButton<String>(
//                   segments: const [
//                     ButtonSegment(value: 'all', label: Text('الكل')),
//                     ButtonSegment(
//                       value: 'active',
//                       label: Text('نشط'),
//                       icon: Icon(Icons.check_circle, color: Colors.green),
//                     ),
//                     ButtonSegment(
//                       value: 'inactive',
//                       label: Text('غير نشط'),
//                       icon: Icon(Icons.cancel, color: Colors.red),
//                     ),
//                   ],
//                   selected: {controller.filter.value},
//                   onSelectionChanged: (newSelection) {
//                     if (newSelection.isNotEmpty) {
//                       controller.setFilter(newSelection.first);
//                     }
//                   },
//                   multiSelectionEnabled: false,
//                   showSelectedIcon: false,
//                   emptySelectionAllowed: false,
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith(
//                         (states) => states.contains(MaterialState.selected)
//                             ? AppColors.oxfordBlue.withOpacity(0.2)
//                             : Colors.grey[200]),
//                     foregroundColor: MaterialStateProperty.resolveWith(
//                         (states) => states.contains(MaterialState.selected)
//                             ? AppColors.oxfordBlue
//                             : Colors.black),
//                   ),
//                 );
//               }),
//             ),

//             // List or loading or empty state
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Lottie.asset('assets/animations/loading.json',
//                             width: 150, height: 150),
//                         const SizedBox(height: 16),
//                         const Text('جارٍ تحميل البيانات...',
//                             style: TextStyle(fontSize: 18)),
//                       ],
//                     ),
//                   );
//                 }

//                 final users = controller.filteredUsers;
//                 if (users.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Lottie.asset('assets/animations/empty.json',
//                             width: 200, height: 200),
//                         const SizedBox(height: 16),
//                         const Text('لا توجد بيانات متاحة',
//                             style: TextStyle(fontSize: 18)),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return UserCard(user: user);
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddUserDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('إضافة مستخدم جديد'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildTextField(
//                 controller: controller.firstName,
//                 label: 'الاسم الأول',
//                 errorText: controller.firstNameError.value,
//                 onChanged: (_) => controller.validateField(
//                   controller.firstName,
//                   () => controller.validateName(controller.firstName.text),
//                   controller.firstNameError,
//                 ),
//               ),
//               _buildTextField(
//                 controller: controller.lastName,
//                 label: 'الاسم الأخير',
//                 errorText: controller.lastNameError.value,
//                 onChanged: (_) => controller.validateField(
//                   controller.lastName,
//                   () => controller.validateName(controller.lastName.text),
//                   controller.lastNameError,
//                 ),
//               ),
//               _buildTextField(
//                 controller: controller.loginEmail,
//                 label: 'البريد الإلكتروني (الشخصي)',
//                 errorText: controller.emailError.value,
//                 onChanged: (_) => controller.validateField(
//                   controller.loginEmail,
//                   () => controller.validateEmail(controller.loginEmail.text),
//                   controller.emailError,
//                 ),
//               ),
//               _buildTextField(
//                 controller: controller.authEmail,
//                 label: 'البريد الإلكتروني (Gmail)',
//                 errorText: controller.gmailError.value,
//                 onChanged: (_) => controller.validateField(
//                   controller.authEmail,
//                   () => controller.validateGmail(controller.authEmail.text),
//                   controller.gmailError,
//                 ),
//               ),
//               _buildTextField(
//                 controller: controller.passwordHash,
//                 label: 'كلمة المرور',
//                 obscureText: true,
//                 errorText: controller.passwordError.value,
//                 onChanged: (_) => controller.validateField(
//                   controller.passwordHash,
//                   () =>
//                       controller.validatePassword(controller.passwordHash.text),
//                   controller.passwordError,
//                 ),
//               ),
//               _buildTextField(
//                 controller: controller.phoneNumber,
//                 label: 'رقم الهاتف',
//                 errorText: controller.mobileNumberError.value,
//                 keyboardType: TextInputType.phone,
//                 onChanged: (_) => controller.validateField(
//                   controller.phoneNumber,
//                   () => controller.validateMobile(controller.phoneNumber.text),
//                   controller.mobileNumberError,
//                 ),
//               ),
//               Obx(() => DropdownButtonFormField<String>(
//                     value: controller.selectedGender.value,
//                     decoration: InputDecoration(
//                       labelText: 'الجنس',
//                       errorText: controller.genderError.value,
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: 'male', child: Text('ذكر')),
//                       DropdownMenuItem(value: 'female', child: Text('أنثى')),
//                     ],
//                     onChanged: (value) {
//                       controller.selectedGender.value = value;
//                       controller.genderError.value =
//                           controller.validateGender();
//                     },
//                   )),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           Obx(() => TextButton(
//                 onPressed: () async {
//                   if (controller.validateAll()) {
//                     await controller.addUser();
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: controller.isLoading.value
//                     ? const CircularProgressIndicator()
//                     : const Text('حفظ'),
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     String? errorText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     void Function(String)? onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           labelText: label,
//           errorText: errorText,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }

// class AdminUsersScreen extends StatelessWidget {
//   const AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AdminUsersController>();

//     return GestureDetector(
//       onTap: () {
//         if (controller.isSearchVisible.value) {
//           FocusScope.of(context)
//               .unfocus(); // إخفاء الكيبورد عند النقر خارج مربع البحث
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset:
//             false, // <--- إضافة هذه السطر لمنع تغيير حجم الواجهة
//         drawer: Drawer(
//           child: AdminDrawer(),
//         ),
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: AppColors.oxfordBlue,
//           title: Text('إدارة المستخدمين'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.add_circle_outline, color: Colors.white),
//               onPressed: () {
//                 _showAddUserDialog(context); // إضافة مستخدم جديد
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.refresh, color: Colors.white),
//               onPressed: () {
//                 controller.fetchUsers(); // تحديث البيانات
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.white),
//               onPressed: () {
//                 controller.toggleSearchVisibility(); // الدخول إلى وضع البحث
//               },
//             ),
//           ],
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.menu, color: Colors.white),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           // <--- تغليف المحتوى لتجنب مشاكل التخطيط
//           child: Obx(() {
//             if (controller.isLoading.value) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset(
//                       'assets/animations/loading.json',
//                       width: 150,
//                       height: 150,
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'جارٍ تحميل البيانات...',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             final users = controller.filteredUsers;
//             if (users.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset(
//                       'assets/animations/empty.json',
//                       width: 200,
//                       height: 200,
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'لا توجد بيانات متاحة',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 Obx(() {
//                   if (controller.isSearchVisible.value) {
//                     return TextField(
//                       autofocus: true, // تفعيل التركيز تلقائيًا
//                       decoration: InputDecoration(
//                         hintText: 'بحث عن مستخدم',
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (query) {
//                         controller.searchUsers(query); // البحث في Firebase
//                       },
//                     );
//                   } else {
//                     return Text('إدارة المستخدمين');
//                   }
//                 }),
//                 // Filter Section
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SegmentedButton<String>(
//                     segments: const [
//                       ButtonSegment(value: 'all', label: Text('الكل')),
//                       ButtonSegment(
//                         value: 'active',
//                         label: Text('نشط'),
//                         icon: Icon(Icons.check_circle, color: Colors.green),
//                       ),
//                       ButtonSegment(
//                         value: 'inactive',
//                         label: Text('غير نشط'),
//                         icon: Icon(Icons.cancel, color: Colors.red),
//                       ),
//                     ],
//                     selected: {controller.filter.value},
//                     onSelectionChanged: (Set<String> newSelection) {
//                       if (newSelection.isNotEmpty) {
//                         controller.setFilter(newSelection.first);
//                       }
//                     },
//                     multiSelectionEnabled: false,
//                     showSelectedIcon: false,
//                     emptySelectionAllowed: false,
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.resolveWith<Color?>((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return AppColors.oxfordBlue.withOpacity(0.2);
//                         }
//                         return Colors.grey[200];
//                       }),
//                       foregroundColor:
//                           MaterialStateProperty.resolveWith<Color>((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return AppColors.oxfordBlue;
//                         }
//                         return Colors.black;
//                       }),
//                     ),
//                   ),
//                 ),

//                 // Users List
//                 ListView.builder(
//                   physics:
//                       const NeverScrollableScrollPhysics(), // <--- منع التمرير داخل القائمة
//                   shrinkWrap: true,
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return UserCard(user: user);
//                   },
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   // Dialog to add a new user
//   void _showAddUserDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('إضافة مستخدم جديد'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'الاسم الأول'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('إلغاء'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Save new user logic
//                 Navigator.pop(context);
//               },
//               child: Text('حفظ'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// class AdminUsersScreen extends StatelessWidget {
//   const AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AdminUsersController>();

//     return GestureDetector(
//       onTap: () {
//         if (controller.isSearchVisible.value) {
//           FocusScope.of(context)
//               .unfocus(); // إخفاء الكيبورد عند النقر خارج مربع البحث
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset:
//             false, // <--- إضافة هذه السطر لمنع تغيير حجم الواجهة
//         drawer: Drawer(
//           child: AdminDrawer(),
//         ),
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: AppColors.oxfordBlue,
//           title: Obx(() {
//             if (controller.isSearchVisible.value) {
//               return TextField(
//                 autofocus: true, // تفعيل التركيز تلقائيًا
//                 decoration: InputDecoration(
//                   hintText: 'بحث عن مستخدم',
//                   border: InputBorder.none,
//                 ),
//                 onChanged: (query) {
//                   controller.searchUsers(query); // البحث في Firebase
//                 },
//               );
//             } else {
//               return Text('إدارة المستخدمين');
//             }
//           }),
//           //   actions: Obx(() {
//           //     if (controller.isSearchVisible.value) {
//           //       return  <Widget>[
//           // IconButton(
//           //   icon: Icon(Icons.close, color: Colors.white),
//           //   onPressed: () {
//           //     controller.toggleSearchVisibility(); // الخروج من وضع البحث
//           //   },
//           // ),
//           //       ];
//           //     } else {
//           //       return <Widget> [
//           //         IconButton(
//           //           icon: Icon(Icons.add_circle_outline, color: Colors.white),
//           //           onPressed: () {
//           //             _showAddUserDialog(context); // إضافة مستخدم جديد
//           //           },
//           //         ),
//           //         IconButton(
//           //           icon: Icon(Icons.refresh, color: Colors.white),
//           //           onPressed: () {
//           //             controller.fetchUsers(); // تحديث البيانات
//           //           },
//           //         ),
//           //         IconButton(
//           //           icon: Icon(Icons.search, color: Colors.white),
//           //           onPressed: () {
//           //             controller.toggleSearchVisibility(); // الدخول إلى وضع البحث
//           //           },
//           //         ),
//           //       ];
//           //     }
//           //   }),
//           //   leading: Builder(
//           //     builder: (context) => IconButton(
//           //       icon: Icon(Icons.menu, color: Colors.white),
//           //       onPressed: () => Scaffold.of(context).openDrawer(),
//           //     ),
//           //   ),
//           // ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.close, color: Colors.white),
//               onPressed: () {
//                 controller.toggleSearchVisibility(); // الخروج من وضع البحث
//               },
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.add_circle_outline,
//                 color: AppColors.white,
//               ),
//               onPressed: () {
//                 // Add new user functionality
//               },
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.refresh,
//                 color: AppColors.white,
//               ),
//               onPressed: () {
//                 controller.fetchUsers();
//               },
//             ),
//           ],
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.menu, color: Colors.white),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ),
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Lottie.asset(
//                     'assets/animations/loading.json',
//                     width: 150,
//                     height: 150,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'جارٍ تحميل البيانات...',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final users = controller.users;
//           if (users.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Lottie.asset(
//                     'assets/animations/empty.json',
//                     width: 200,
//                     height: 200,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'لا توجد بيانات متاحة',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               // Filter Section (Visible only when not in search mode)
//               Visibility(
//                 visible: !controller.isSearchVisible.value,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SegmentedButton<String>(
//                     segments: const [
//                       ButtonSegment(value: 'all', label: Text('الكل')),
//                       ButtonSegment(
//                         value: 'active',
//                         label: Text('نشط'),
//                         icon: Icon(Icons.check_circle, color: Colors.green),
//                       ),
//                       ButtonSegment(
//                         value: 'inactive',
//                         label: Text('غير نشط'),
//                         icon: Icon(Icons.cancel, color: Colors.red),
//                       ),
//                     ],
//                     selected: {controller.filter.value},
//                     onSelectionChanged: (Set<String> newSelection) {
//                       if (newSelection.isNotEmpty) {
//                         controller.setFilter(newSelection.first);
//                       }
//                     },
//                     multiSelectionEnabled: false,
//                     showSelectedIcon: false,
//                     emptySelectionAllowed: false,
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.resolveWith<Color?>((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return AppColors.oxfordBlue.withOpacity(0.2);
//                         }
//                         return Colors.grey[200];
//                       }),
//                       foregroundColor:
//                           MaterialStateProperty.resolveWith<Color>((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return AppColors.oxfordBlue;
//                         }
//                         return Colors.black;
//                       }),
//                     ),
//                   ),
//                 ),
//               ),

//               // Users List
//               Expanded(
//                 child: ListView.builder(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: controller.filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     final user = controller.filteredUsers[index];
//                     return UserCard(user: user);
//                   },
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // Dialog to add a new user
//   void _showAddUserDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('إضافة مستخدم جديد'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'الاسم الأول'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
//               ),
//               // Add more fields as needed
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('إلغاء'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Save new user logic
//                 Navigator.pop(context);
//               },
//               child: Text('حفظ'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// class AdminUsersScreen extends StatelessWidget {
//   const AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AdminUsersController>();

//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context)
//             .unfocus(); // إخفاء الكيبورد عند النقر خارج مربع البحث
//       },
//       child: Scaffold(
//         drawer: Drawer(
//           child: AdminDrawer(),
//         ),
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: AppColors.oxfordBlue,
//           title: Obx(() {
//             if (controller.isSearchVisible.value) {
//               return TextField(
//                 decoration: InputDecoration(
//                   hintText: 'بحث عن مستخدم',
//                   border: InputBorder.none,
//                 ),
//                 onChanged: (query) {
//                   controller.searchUsers(query);
//                 },
//               );
//             } else {
//               return Text('إدارة المستخدمين');
//             }
//           }),
//           // title: Text(
//           //   'إدارة المستخدمين',
//           //   style: TextStyle(color: Colors.white),
//           // ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.add_circle_outline, color: Colors.white),
//               onPressed: () {
//                 // Add new user functionality
//                 _showAddUserDialog(context);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.refresh, color: Colors.white),
//               onPressed: () {
//                 controller.fetchUsers();
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.white),
//               onPressed: () {
//                 controller.toggleSearchVisibility();
//               },
//             ),
//           ],
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.menu, color: Colors.white),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ),
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Lottie.asset('assets/animations/loading.json',
//                       width: 150, height: 150),
//                   const SizedBox(height: 16),
//                   const Text('جارٍ تحميل البيانات...',
//                       style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             );
//           }

//           final users = controller.users;
//           if (users.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Lottie.asset('assets/animations/empty.json',
//                       width: 200, height: 200),
//                   const SizedBox(height: 16),
//                   const Text('لا توجد بيانات متاحة',
//                       style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               // Filter and Statistics Section
//               Obx(() {
//                 return SegmentedButton<String>(
//                   segments: const [
//                     ButtonSegment(value: 'all', label: Text('الكل')),
//                     ButtonSegment(
//                         value: 'active',
//                         label: Text('نشط'),
//                         icon: Icon(Icons.check_circle, color: Colors.green)),
//                     ButtonSegment(
//                         value: 'inactive',
//                         label: Text('غير نشط'),
//                         icon: Icon(Icons.cancel, color: Colors.red)),
//                   ],
//                   selected: {controller.filter.value},
//                   onSelectionChanged: (Set<String> newSelection) {
//                     if (newSelection.isNotEmpty) {
//                       controller.setFilter(newSelection.first);
//                     }
//                   },
//                   multiSelectionEnabled: false,
//                   showSelectedIcon: false,
//                   emptySelectionAllowed: false,
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.resolveWith<Color?>((states) {
//                       if (states.contains(MaterialState.selected)) {
//                         return AppColors.oxfordBlue.withOpacity(0.2);
//                       }
//                       return Colors.grey[200];
//                     }),
//                     foregroundColor:
//                         MaterialStateProperty.resolveWith<Color>((states) {
//                       if (states.contains(MaterialState.selected)) {
//                         return AppColors.oxfordBlue;
//                       }
//                       return Colors.black;
//                     }),
//                   ),
//                 );
//               }),

//               // Search Bar
//               Obx(() {
//                 return Visibility(
//                   visible: controller.isSearchVisible.value,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'بحث عن مستخدم',
//                         prefixIcon: Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onChanged: (query) {
//                         controller.searchUsers(query); // البحث في Firebase
//                       },
//                     ),
//                   ),
//                 );
//               }),
//               // Users List

//               Expanded(
//                 child: ListView.builder(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: controller.filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     final user = controller.filteredUsers[index];
//                     return UserCard(user: user);
//                   },
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // Dialog to add a new user
//   void _showAddUserDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('إضافة مستخدم جديد'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'الاسم الأول'),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
//               ),
//               // Add more fields as needed
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('إلغاء'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Save new user logic
//                 Navigator.pop(context);
//               },
//               child: Text('حفظ'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// Widget for user card

// class AdminUsersScreen extends GetView<AdminUsersController> {
//   const AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: AdminDrawer(),
//       ),
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.oxfordBlue,
//         title: Text(
//           'إدارة المستخدمين',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.add_circle_outline,
//               color: AppColors.white,
//             ),
//             onPressed: () {
//               // Add new user functionality
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: AppColors.white,
//             ),
//             onPressed: () {
//               controller.fetchUsers();
//             },
//           ),
//         ],
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: Icon(Icons.menu, color: Colors.white),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset('assets/animations/loading.json',
//                     width: 150, height: 150),
//                 const SizedBox(height: 16),
//                 const Text('جارٍ تحميل البيانات...',
//                     style: TextStyle(fontSize: 18)),
//               ],
//             ),
//           );
//         }

//         final users = controller.users;

//         if (users.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset('assets/animations/empty.json',
//                     width: 200, height: 200),
//                 const SizedBox(height: 16),
//                 const Text('لا توجد بيانات متاحة',
//                     style: TextStyle(fontSize: 18)),
//               ],
//             ),
//           );
//         }

//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'بحث عن مستخدم',
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (query) {
//                     controller.searchUsers(query); // Search functionality
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 ListView.builder(
//                   physics:
//                       const AlwaysScrollableScrollPhysics(), // ضروري للـ pull حتى لو القائمة فاضية

//                   shrinkWrap: true,
//                   // physics: const NeverScrollableScrollPhysics(),
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return Card(
//                       elevation: 6,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 30,
//                               backgroundColor: user.isLogin == true
//                                   ? Colors.green
//                                   : Colors.grey,
//                               child: Text(
//                                 user.firstName.substring(0, 1).toUpperCase(),
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     user.firstName,
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     user.loginEmail,
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     user.isLogin == true ? 'نشط' : 'غير نشط',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: user.isLogin == true
//                                           ? Colors.green
//                                           : Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             PopupMenuButton<String>(
//                               onSelected: (value) {
//                                 switch (value) {
//                                   case 'edit':
//                                     BotToast.showText(
//                                       text: 'Soon..',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               vertical: 30,
//                                               horizontal:
//                                                   30), // تحديد الارتفاع والعرض
//                                     );
//                                     break;
//                                   case 'delete':
//                                     BotToast.showText(text: 'Soon..');
//                                     break;
//                                   case 'block':
//                                     BotToast.showText(text: 'Soon..');
//                                     break;
//                                 }
//                               },
//                               itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                   value: 'edit',
//                                   child: Row(
//                                     children: const [
//                                       Icon(Icons.edit, color: Colors.blue),
//                                       SizedBox(width: 8),
//                                       Text('تعديل'),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   value: 'delete',
//                                   child: Row(
//                                     children: const [
//                                       Icon(Icons.delete, color: Colors.red),
//                                       SizedBox(width: 8),
//                                       Text('حذف'),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   value: 'block',
//                                   child: Row(
//                                     children: const [
//                                       Icon(Icons.block, color: Colors.orange),
//                                       SizedBox(width: 8),
//                                       Text('حظر'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               icon: const Icon(Icons.more_vert),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class AdminUsersScreen extends GetView<AdminUsersController> {
//   AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         title: const Text('إدارة المستخدمين'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               controller.fetchUsers(); // Refresh data
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset('assets/animations/loading.json',
//                     width: 500, height: 500),
//                 const SizedBox(height: 16),
//                 const Text('جارٍ تحميل البيانات...',
//                     style: TextStyle(fontSize: 18)),
//               ],
//             ),
//           );
//         }

//         final users = controller.users;

//         if (users.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Lottie.asset('assets/animations/empty.json',
//                     width: 200, height: 200),
//                 const SizedBox(height: 16),
//                 const Text('لا توجد بيانات متاحة',
//                     style: TextStyle(fontSize: 18)),
//               ],
//             ),
//           );
//         }

//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'إدارة المستخدمين',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add_circle_outline,
//                           color: Colors.green),
//                       onPressed: () {
//                         // Add new user functionality
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'بحث عن مستخدم',
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (query) {
//                     controller.searchUsers(query); // Search functionality
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor:
//                               user.isLogin == true ? Colors.green : Colors.grey,
//                           child: Text(
//                             user.firstName?.substring(0, 1).toUpperCase() ??
//                                 '?',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         title: Text(user.firstName ?? 'بدون اسم'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(user.loginEmail ?? 'بدون معرف'),
//                             // Text(
//                             //     'الحالة: ${user.isLogin == true ? 'نشط' : 'غير نشط'}'),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 // Edit user functionality
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 // Delete user functionality
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
// class AdminUsersScreen extends GetView<AdminUsersController> {
//   // final AdminUsersController controller = Get.put(
//   //   AdminUsersController(AdminRepoImp(FirebaseAdminSource())),
//   // );

//   AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final users = controller.users;

//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'إدارة المستخدمين',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add_circle_outline,
//                           color: Colors.green),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const TextField(
//                   decoration: InputDecoration(
//                     labelText: 'بحث عن مستخدم',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     return Card(
//                       elevation: 4,
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.blue,
//                           child: Text(
//                               user.firstName?.substring(0, 1).toUpperCase() ??
//                                   '?',
//                               style: const TextStyle(color: Colors.white)),
//                         ),
//                         title: Text(user.firstName ?? 'بدون اسم'),
//                         subtitle: Text(user.loginEmail),
//                         trailing: Switch(
//                           value: user.isLogin ?? false,
//                           onChanged:
//                               (_) {}, // لاحقًا تضيف التحكم في حالة التفعيل
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class AdminUsersScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> users = [
//     {'name': 'أحمد', 'email': 'ahmed@example.com', 'isActive': true},
//     {'name': 'سارة', 'email': 'sara@example.com', 'isActive': false},
//   ];

//    AdminUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'إدارة المستخدمين',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add_circle_outline, color: Colors.green),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'بحث عن مستخدم',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return Card(
//                   elevation: 4,
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.blue,
//                       child: Text(user['name'][0],
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                     title: Text(user['name']),
//                     subtitle: Text(user['email']),
//                     trailing: Switch(
//                       value: user['isActive'],
//                       onChanged: (value) {},
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class UserCard extends StatelessWidget {
//   final UserModel user;

//   const UserCard({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: user.isLogin ? Colors.green : Colors.grey,
//               child: Text(
//                 user.firstName.substring(0, 1).toUpperCase(),
//                 style: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.firstName,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user.loginEmail,
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user.isLogin ? 'نشط' : 'غير نشط',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: user.isLogin ? Colors.green : Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 switch (value) {
//                   case 'edit':
//                     BotToast.showText(text: 'Soon..');
//                     break;
//                   case 'delete':
//                     BotToast.showText(text: 'Soon..');
//                     break;
//                   case 'block':
//                     BotToast.showText(text: 'Soon..');
//                     break;
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'edit',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.edit, color: Colors.blue),
//                       SizedBox(width: 8),
//                       Text('تعديل'),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.delete, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('حذف'),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'block',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.block, color: Colors.orange),
//                       SizedBox(width: 8),
//                       Text('حظر'),
//                     ],
//                   ),
//                 ),
//               ],
//               icon: const Icon(Icons.more_vert),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
