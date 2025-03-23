// ignore_for_file: avoid_print

import 'package:arrowspeed/admin/data/repo_imp/admin_repo_imp_user.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/domin/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersController extends GetxController {
  final AdminRepoImpUser adminRepoImp; // استخدام الكلاس المُحقق مباشرةً
  AdminUsersController(this.adminRepoImp);

  RxList<UserModel> users = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxString filter = 'all'.obs;
  RxString searchQuery = ''.obs;
  RxBool isSearchVisible = false.obs;

  // Controllers for user fields
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final loginEmail = TextEditingController();
  final authEmail = TextEditingController();
  final phoneNumber = TextEditingController();
  final passwordHash = TextEditingController();
  final selectedGender = Rxn<String>();

  // Error messages
  final firstNameError = Rxn<String>();
  final lastNameError = Rxn<String>();
  final emailError = Rxn<String>();
  final gmailError = Rxn<String>();
  final passwordError = Rxn<String>();
  final mobileNumberError = Rxn<String>();
  final genderError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    resetForm();

    fetchUsers(); // جلب البيانات عند بدء الصفحة

    debounce(searchQuery, (_) => fetchUsers(),
        time: Duration(milliseconds: 300)); // Debounce للبحث
    ever(filter, (_) => fetchUsers()); // إعادة تحميل البيانات عند تغيير الفلتر
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterName');
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourEmail');
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@arrowspeed\.com$')
        .hasMatch(value)) {
      return Utils.localize('EmailMustBeArrowspeed');
    }
    return null;
  }

  String? validateGmail(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourGmail');
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@gmail\.com$').hasMatch(value)) {
      return Utils.localize('EmailMustBeGmail');
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourPassword');
    } else if (value.length < 6) {
      return Utils.localize('PasswordMustBeAtLeast');
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.length < 9) {
      return Utils.localize('InvalidPhoneNumber');
    }
    return null;
  }

  String? validateGender() {
    if (selectedGender.value == null) {
      return Utils.localize('PleaseSelectGender');
    }
    return null;
  }

  void validateField(TextEditingController controller,
      String? Function() validator, Rx<String?> error) {
    final errorMessage = validator();
    error.value = errorMessage;
  }

  bool validateAll() {
    final validations = [
      validateName(firstName.text),
      validateName(lastName.text),
      validateEmail(loginEmail.text),
      validateGmail(authEmail.text),
      validatePassword(passwordHash.text),
      validateMobile(phoneNumber.text),
      validateGender(),
    ];

    [
      firstNameError,
      lastNameError,
      emailError,
      gmailError,
      passwordError,
      mobileNumberError,
      genderError,
    ].asMap().forEach((index, error) {
      error.value = validations[index];
    });

    final isValid = validations.every((v) => v == null);
    print("✅ هل جميع الحقول صحيحة؟ $isValid");

    return isValid;
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final result = await adminRepoImp.getAllUsers(
        emailQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        isActive: filter.value == 'all'
            ? null
            : filter.value == 'active'
                ? true
                : false,
      );
      users.assignAll(result);
    } catch (e) {
      print("❌ فشل في جلب المستخدمين: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String selectedFilter) {
    filter.value = selectedFilter;
    fetchUsers();
  }

  void search(String query) {
    searchQuery.value = query;
    fetchUsers();
  }

  // Future<void> addUser() async {
  //   if (!validateAll()) {
  //     return;
  //   }

  //   isLoading.value = true;
  //   try {
  //     final newUser = UserModel(
  //       firstName: firstName.text.trim(),
  //       lastName: lastName.text.trim(),
  //       loginEmail: loginEmail.text.trim(),
  //       authEmail: authEmail.text.trim(),
  //       phoneNumber: phoneNumber.text.trim(),
  //       passwordHash: passwordHash.text,
  //       gender: selectedGender.value == 'male'
  //           ? UserGender.male
  //           : UserGender.female,
  //       isLogin: false,
  //       isVerified: false,
  //       otp: '',
  //       profilePhoto: '',
  //     );
  //     await adminRepoImp.addUser(
  //       newUser, loginEmail.text, // اسم الحقل الذي يحتوي على البريد الإلكتروني
  //     );
  //     fetchUsers();
  //     resetForm();
  //   } catch (e) {
  //     print("❌ فشل في إضافة المستخدم: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> addUser() async {
    // التحقق من صحة جميع الحقول
    if (!validateAll()) {
      return;
    }

    isLoading.value = true;
    try {
      // إنشاء نموذج المستخدم الجديد
      final newUser = UserModel(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        loginEmail: loginEmail.text.trim(),
        authEmail: authEmail.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        passwordHash: passwordHash.text,
        gender: selectedGender.value == 'male'
            ? UserGender.male
            : UserGender.female,
        isLogin: false,
        isVerified: false,
        otp: '',
        profilePhoto: '',
      );

      // إضافة المستخدم مع التحقق من البريد الإلكتروني
      await adminRepoImp.addUser(
        newUser,
        'loginEmail', // اسم الحقل الذي يحتوي على البريد الإلكتروني
      );

      // تحديث قائمة المستخدمين
      fetchUsers();

      // إعادة تعيين النموذج
      resetForm();

      // إظهار رسالة نجاح
      Get.snackbar(
        'نجاح',
        'تمت إضافة المستخدم بنجاح.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // إظهار رسالة خطأ
      if (e.toString().contains('exists')) {
        Get.snackbar(
          'خطأ',
          'البريد الإلكتروني "${loginEmail.text.trim()}" موجود مسبقًا.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إضافة المستخدم. حاول مرة أخرى.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    await adminRepoImp.updateUser(user);
    fetchUsers();
  }

  Future<void> deleteUser(String userId) async {
    try {
      await adminRepoImp.deleteUser(userId);
      Get.snackbar('نجاح', 'تم حذف المستخدم بنجاح');
      fetchUsers();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف المستخدم: $e');
    }
  }

  Future<void> toggleBlockUser(String userId, bool isLogin) async {
    try {
      await adminRepoImp.toggleBlockUser(userId, isLogin);
      Get.snackbar('نجاح', 'تم تحديث حالة المستخدم بنجاح');
      fetchUsers();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث حالة المستخدم: $e');
    }
  }

  void toggleSearchVisibility() => isSearchVisible.toggle();
  void resetForm() {
    firstName.clear();
    lastName.clear();
    loginEmail.clear();
    authEmail.clear();
    passwordHash.clear();
    phoneNumber.clear();
    selectedGender.value = null;

    firstNameError.value = null;
    lastNameError.value = null;
    emailError.value = null;
    gmailError.value = null;
    passwordError.value = null;
    mobileNumberError.value = null;
    genderError.value = null;
  }
}
// class AdminUsersController extends GetxController {
//   final AdminRepoImpUser adminRepoImp;
//   AdminUsersController(this.adminRepoImp);

//   RxList<UserModel> users = <UserModel>[].obs;
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;
//   RxString filter = 'all'.obs;
//   RxString searchQuery = ''.obs;
//   RxBool isSearchVisible = false.obs;
//   RxString selectedFilter = 'all'.obs;

//   // Controllers for user fields
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final loginEmail = TextEditingController();
//   final authEmail = TextEditingController();
//   final phoneNumber = TextEditingController();
//   final passwordHash = TextEditingController();
//   final selectedGender = Rxn<String>();
//   final isLogin = TextEditingController();
//   final isVerified = TextEditingController();

//   final firstNameError = Rxn<String>();
//   final lastNameError = Rxn<String>();
//   final emailError = Rxn<String>();
//   final gmailError = Rxn<String>();
//   final passwordError = Rxn<String>();
//   final mobileNumberError = Rxn<String>();
//   final genderError = Rxn<String>();
//    @override
//   void onInit() {
//     super.onInit();
//     // مراقبة التغييرات في البحث والفلتر
//     debounce(searchQuery, (_) => fetchUsers(), time: Duration(milliseconds: 300));  // Debounce للبحث
//     selectedFilter.listen((value) {
//       fetchUsers();  // إعادة تحميل البيانات عند تغيير الفلتر
//     });
//   }

//   String? validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return Utils.localize('PleaseEnterName');
//     }
//     return null;
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return Utils.localize('PleaseEnterYourEmail');
//     } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@arrowspeed\.com$')
//         .hasMatch(value)) {
//       return Utils.localize('EmailMustBeArrowspeed');
//     }
//     return null;
//   }

//   String? validateGmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return Utils.localize('PleaseEnterYourGmail');
//     } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@gmail\.com$').hasMatch(value)) {
//       return Utils.localize('EmailMustBeGmail');
//     }
//     return null;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return Utils.localize('PleaseEnterYourPassword');
//     } else if (value.length < 6) {
//       return Utils.localize('PasswordMustBeAtLeast');
//     }
//     return null;
//   }

//   String? validateMobile(String? value) {
//     if (value == null || value.length < 9) {
//       return Utils.localize('InvalidPhoneNumber');
//     }
//     return null;
//   }

//   String? validateGender() {
//     if (selectedGender.value == null) {
//       return Utils.localize('PleaseSelectGender');
//     }
//     return null;
//   }

//   void validateField(TextEditingController controller,
//       String? Function() validator, Rx<String?> error) {
//     final errorMessage = validator();
//     error.value = errorMessage;
//   }

//   bool validateAll() {
//     final validations = [
//       validateName(firstName.text),
//       validateName(lastName.text),
//       validateEmail(loginEmail.text),
//       validateGmail(authEmail.text),
//       validatePassword(passwordHash.text),
//       // validateConfirmPassword(confirmPassword.text),
//       validateMobile(phoneNumber.text),
//       validateGender(),
//     ];

//     [
//       firstNameError,
//       lastNameError,
//       emailError,
//       gmailError,
//       passwordError,
//       mobileNumberError,
//       genderError,
//     ].asMap().forEach((index, error) {
//       error.value = validations[index];
//     });

//     final isValid = validations.every((v) => v == null);
//     print("✅ هل جميع الحقول صحيحة؟ $isValid");

//     return isValid;
//   }


//  Future<void> fetchUsers() async {
//     isLoading.value = true;
//     try {
//       final result = await adminRepoImp.getAllUsers(
//         emailQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
//         isActive: filter.value == 'all'
//             ? null
//             : filter.value == 'active'
//                 ? true
//                 : false,
//       );
//       users.assignAll(result);
//     } catch (e) {
//       print("❌ فشل في جلب المستخدمين: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Call this when setting the filter
//    void setFilter(String selectedFilter) {
//     filter.value = selectedFilter;
//   }

//   // Call this when performing the search
//   void search(String query) {
//     searchQuery.value = query;
//     fetchUsers();  // Call fetch after setting the search query
//   }

  
//   Future<void> addUser() async {
//     if (!validateAll()) {
//       errorMessage.value = '❌ تحقق من صحة البيانات أولاً';
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final newUser = UserModel(
//           firstName: firstName.text.trim(),
//           lastName: lastName.text.trim(),
//           loginEmail: loginEmail.text.trim(),
//           authEmail: authEmail.text.trim(),
//           phoneNumber: phoneNumber.text.trim(),
//           passwordHash: passwordHash.text,
//           gender: selectedGender.value == 'male'
//               ? UserGender.male
//               : UserGender.female,
//           isLogin: isLogin.text == 'true',
//           isVerified: isVerified.text == 'true',
//           otp: '',
//           profilePhoto: '');
//       await adminRepoImp.addUser(newUser);
//       fetchUsers();
//     } catch (e) {
//       errorMessage.value = '❌ فشل في إضافة المستخدم: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateUser(UserModel user) async {
//     await adminRepoImp.updateUser(user);
//     fetchUsers();
//   }

//   Future<void> deleteUser(String userId) async {
//     await adminRepoImp.deleteUser(userId);
//     fetchUsers();
//   }

//   Future<void> toggleBlockUser(String userId, bool isLogin) async {
//     await adminRepoImp.toggleBlockUser(userId, isLogin);
//     fetchUsers();
//   }

//   void toggleSearchVisibility() => isSearchVisible.toggle();
// }

// class AdminUsersController extends GetxController {
//   final AdminRepoImp adminRepoImp;
//   AdminUsersController(this.adminRepoImp);

//   RxList<UserModel> users = <UserModel>[].obs;
//   RxList<UserModel> filteredUsers = <UserModel>[].obs;
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;
//   RxString filter = 'all'.obs;
//   RxString searchQuery = ''.obs;
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final loginEmail = TextEditingController();
//   final authEmail = TextEditingController();
//   final phoneNumber = TextEditingController();
//   final passwordHash = TextEditingController();
//   final gender = TextEditingController();
//   final isLogin = TextEditingController();
//   final isVerified = TextEditingController();
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers();
//   }
// List<UserModel> get filteredUsers {
//   final filterValue = filter.value;
//   if (filterValue == 'active') {
//     return users.where((u) => u.isActive).toList();
//   } else if (filterValue == 'inactive') {
//     return users.where((u) => !u.isActive).toList();
//   }
//   return users;
// }

//   Future<void> fetchUsers() async {
//     isLoading.value = true;
//     try {
//       final result = await adminRepoImp.getAllUsers(
//         emailQuery: searchQuery.isEmpty ? null : searchQuery.value,
//         isActive: filter.value == 'all' ? null : filter.value == 'active',
//       );
//       users.assignAll(result);
//       filteredUsers.assignAll(result);
//     } catch (e) {
//       errorMessage.value = "❌ فشل في جلب المستخدمين: $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void setFilter(String newFilter) {
//     filter.value = newFilter;
//     fetchUsers();
//   }

//   void search(String query) {
//     searchQuery.value = query;
//     fetchUsers();
//   }

// void addUser(UserModel userModel) async {
//   isLoading.value = true;
//   try {
//     final newUser = UserModel(
//       firstName: userModel.firstName,
//       lastName: userModel.lastName,
//       loginEmail: userModel.loginEmail,
//       authEmail: userModel.authEmail,
//       phoneNumber: userModel.phoneNumber,
//       passwordHash: userModel.passwordHash,
//       gender: userModel.gender,
//       isLogin: userModel.isLogin,
//       isVerified: userModel.isVerified,
     
   
//       // id: UniqueKey().toString(),
//       // name: name,
//       // email: email,
//       // isActive: true,
//     );
//     await adminRepoImp.addUser(newUser);
//     fetchUsers(); // يعيد تحميل البيانات بعد الإضافة
//   } finally {
//     isLoading.value = false;
//   }
// }


//   Future<void> updateUser(UserModel user) async {
//     await adminRepoImp.updateUser(user);
//     fetchUsers();
//   }

//   Future<void> deleteUser(String userId) async {
//     await adminRepoImp.deleteUser(userId);
//     fetchUsers();
//   }

//   Future<void> toggleBlockUser(String userId, bool isLogin) async {
//     await adminRepoImp.toggleBlockUser(userId, isLogin);
//     fetchUsers();
//   }

//   RxBool isSearchVisible = false.obs;
//   void toggleSearchVisibility() => isSearchVisible.value = !isSearchVisible.value;
// }

// class AdminUsersController extends GetxController {
//   final AdminRepoImp adminRepoImp;
//   AdminUsersController(this.adminRepoImp);

//   // Variables
//   RxList<UserModel> users = <UserModel>[].obs; // قائمة المستخدمين
//   RxList<UserModel> filteredUsers = <UserModel>[].obs; // قائمة المستخدمين بعد البحث/الفلترة
//   RxBool isLoading = false.obs; // حالة التحميل
//   RxString errorMessage = ''.obs; // رسالة الخطأ
//   RxString filter = 'all'.obs; // فلتر الحالة (all, active, inactive)

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers(); // جلب جميع المستخدمين عند بدء التطبيق
//   }

//   // Fetch all users from the repository
//   Future<void> fetchUsers() async {
//     isLoading.value = true;
//     errorMessage.value = ''; // Reset error message
//     try {
//       final fetchedUsers = await adminRepoImp.getAllUsers(
//         isActive: filter.value == 'all' ? null : filter.value == 'active',
//       );
//       users.assignAll(fetchedUsers); // تحديث القائمة الرئيسية
//       filteredUsers.assignAll(fetchedUsers); // تحديث القائمة المصفاة
//     } catch (e) {
//       errorMessage.value = "❌ خطأ أثناء جلب المستخدمين: $e";
//       print(errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Search users based on email in Firebase
//   Future<void> searchUsers(String query) async {
//     isLoading.value = true;
//     try {
//       final searchedUsers = await adminRepoImp.getAllUsers(emailQuery: query);
//       filteredUsers.assignAll(searchedUsers); // تحديث القائمة المصفاة
//     } catch (e) {
//       errorMessage.value = "❌ خطأ أثناء البحث عن المستخدمين: $e";
//       print(errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Set filter (all, active, inactive)
//   void setFilter(String newFilter) {
//     filter.value = newFilter;
//     fetchUsers(); // إعادة جلب المستخدمين بناءً على الفلتر الجديد
//   }

//   // Toggle search visibility
//   RxBool isSearchVisible = false.obs;
//   void toggleSearchVisibility() {
//     isSearchVisible.value = !isSearchVisible.value;
//   }
// }
// class AdminUsersController extends GetxController {
//   final AdminRepoImp adminRepoImp;
//   AdminUsersController(this.adminRepoImp);

//   // Variables
//   RxList<UserModel> users = <UserModel>[].obs; // قائمة المستخدمين
//   RxList<UserModel> filteredUsers = <UserModel>[].obs; // قائمة المستخدمين بعد البحث
//   RxBool isLoading = false.obs; // حالة التحميل
//   RxString errorMessage = ''.obs; // رسالة الخطأ

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers(); // ⬅️ أول ما يشتغل الكنترولر يجيب المستخدمين
//   }

//   // Fetch all users from the repository
//   Future<void> fetchUsers() async {
//     isLoading.value = true;
//     errorMessage.value = ''; // Reset error message
//     try {
//       final fetchedUsers = await adminRepoImp.getAllUsers();
//       users.assignAll(fetchedUsers); // تحديث القائمة الرئيسية
//       filteredUsers.assignAll(fetchedUsers); // تحديث القائمة المصفاة
//     } catch (e) {
//       errorMessage.value = "❌ خطأ أثناء جلب المستخدمين: $e";
//       print(errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Search users based on a query
//   void searchUsers(String query) {
//     if (query.isEmpty) {
//       filteredUsers.assignAll(users); // إذا كان البحث فارغًا، استعد جميع المستخدمين
//     } else {
//       filteredUsers.assignAll(
//         users.where((user) {
//           final name = user.firstName?.toLowerCase() ?? '';
//           final email = user.loginEmail?.toLowerCase() ?? '';
//           return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
//         }).toList(),
//       );
//     }
//   }

//   // Delete a user by ID
//   Future<void> deleteUser(String userId) async {
//     try {
//       // await adminRepoImp.deleteUser(userId); // حذف المستخدم من المصدر
//       // users.removeWhere((user) => user.id == userId); // تحديث القائمة الرئيسية
//       // filteredUsers.removeWhere((user) => user.id == userId); // تحديث القائمة المصفاة
//     } catch (e) {
//       errorMessage.value = "❌ خطأ أثناء حذف المستخدم: $e";
//       print(errorMessage.value);
//     }
//   }

//   // Update a user's data
//   Future<void> updateUser(UserModel updatedUser) async {
//     try {
//       // await adminRepoImp.updateUser(updatedUser); // تحديث المستخدم في المصدر
//       // final index = users.indexWhere((user) => user.id == updatedUser.id);
//       // if (index != -1) {
//       //   users[index] = updatedUser; // تحديث القائمة الرئيسية
//       // }
//       // final filteredIndex = filteredUsers.indexWhere((user) => user.id == updatedUser.id);
//       // if (filteredIndex != -1) {
//       //   filteredUsers[filteredIndex] = updatedUser; // تحديث القائمة المصفاة
//       // }
//     } catch (e) {
//       errorMessage.value = "❌ خطأ أثناء تحديث المستخدم: $e";
//       print(errorMessage.value);
//     }
//   }
// }
// class AdminUsersController extends GetxController {
//   final AdminRepoImp adminRepoImp;
//   AdminUsersController(this.adminRepoImp);

//   RxList<UserModel> users = <UserModel>[].obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUsers(); // ⬅️ أول ما يشتغل الكنترولر يجيب المستخدمين
//   }

//   void fetchUsers() async {
//     isLoading.value = true;
//     try {
//       final fetchedUsers = await adminRepoImp.getAllUsers();
//       users.assignAll(fetchedUsers);
//     } catch (e) {
//       print("❌ خطأ أثناء جلب المستخدمين: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void searchUsers(String query) {}
// }
