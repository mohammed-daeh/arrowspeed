// ignore_for_file: prefer_const_constructors

import 'package:arrowspeed/admin/presentation/bindings/admin_binding.dart';
import 'package:arrowspeed/admin/presentation/bindings/admin_users_binding.dart';
import 'package:arrowspeed/admin/presentation/admin_home_screen.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_profile_screen.dart';
import 'package:arrowspeed/admin/trip_admin/add_binding.dart';
import 'package:arrowspeed/admin/trip_admin/add_trip_admin.dart';
import 'package:arrowspeed/featuers/auth/presentation/binding/create_account_binding.dart';
import 'package:arrowspeed/featuers/auth/presentation/binding/login_binding.dart';
import 'package:arrowspeed/featuers/auth/presentation/binding/otp_binding.dart';
import 'package:arrowspeed/featuers/auth/presentation/screens/creat_account_screen.dart';
import 'package:arrowspeed/featuers/auth/presentation/screens/login_screen.dart';
import 'package:arrowspeed/featuers/auth/presentation/screens/otp_screen.dart';
import 'package:arrowspeed/featuers/booking/presentation/bindings/booking_binding.dart';
import 'package:arrowspeed/featuers/booking/presentation/bindings/confirm_payment_binding.dart';
import 'package:arrowspeed/featuers/booking/presentation/bindings/confirm_reservation_binding.dart';
import 'package:arrowspeed/featuers/booking/presentation/bindings/reservation_binding.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/confirm_payment_screen.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/confirm_reservation_screen.dart';
import 'package:arrowspeed/featuers/home/presentation/bindings/search_trip_binding.dart';
import 'package:arrowspeed/featuers/profile/presentation/bindings/edit_profile_binding.dart';
import 'package:arrowspeed/featuers/profile/presentation/bindings/passenger_binding.dart';
import 'package:arrowspeed/featuers/profile/presentation/bindings/profile_binding.dart';

import 'package:arrowspeed/featuers/trip/presentation/bindings/trip_binding.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/main_home_page.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/about_us_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/edit_my_profile_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/faq_and_support_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/offers_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/passengers_list_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/refer_and_eam_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/settings_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/bindings/wallet_binding.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/pages/select_payment_method_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/pages/wallet_screen.dart';
import 'package:arrowspeed/featuers/on_boarding/on_boarding_screen.dart';
import 'package:arrowspeed/featuers/splash_screen/splash_screen.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/reservation_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String mainHome = '/mainHome';
  static const String bookings = '/bookings';
  static const String settings = '/settings';
  static const String passengersList = '/passengersList';
  static const String wallet = '/wallet';
  static const String refer = '/refer';
  static const String offer = '/offer';
  static const String faq = '/faq';
  static const String about = '/about';
  static const String editProfile = '/editProfile';
  static const String selectPayment = '/selectPayment';
  static const String ticket = '/ticket';
  static const String addTrip = '/addTrip';
  static const String reservation = '/reservation';
  static const String confirmReservation = '/confirmReservation';
  static const String confirmPayment = '/stripePayment';
  static const String searchTrip = '/searchTrip';

  static const String adminHome = '/adminHome';
  static const String adminProfile = '/adminProfile';

  static List<GetPage> appPages = [
//main
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: onBoarding,
      page: () => OnBoardingScreen(),
    ),
    GetPage(
      name: mainHome,
      page: () => MainHomePage(),
      bindings: [
        TripBinding(),
        ProfileBinding(),
        BookingBinding(),
        SearchTripBinding()
      ],
    ),
//auth
    GetPage(
      name: signUp,
      page: () => CreatAccountScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: otp,
      page: () => OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
//profile
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
        name: passengersList,
        page: () => PassengersListScreen(),
        binding: PassengerBinding()),
    GetPage(
      name: wallet,
      page: () => WalletScreen(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: refer,
      page: () => ReferAndEamScreen(),
    ),
    GetPage(
      name: offer,
      page: () => OffersScreen(),
    ),
    GetPage(
      name: faq,
      page: () => FaqAndSupportScreen(),
    ),
    GetPage(
      name: about,
      page: () => AboutUsScreen(),
    ),
    GetPage(
        name: editProfile,
        page: () => EditProfileScreen(),
        binding: EditProfileBinding()),
    GetPage(
      name: selectPayment,
      page: () => SelectPaymentMethodScreen(),
      binding: WalletBinding(),
    ),
//trip
    GetPage(
      name: addTrip,
      page: () => AddTripScreen(),
      binding: AddBinding(),
    ),
//booking
    GetPage(
      name: reservation,
      page: () => ReservationScreen(),
      binding: ReservationBinding(),
    ),
    GetPage(
      name: confirmReservation,
      page: () => ConfirmReservationScreen(),
      binding: ConfirmReservationBinding(),
    ),
    GetPage(
      name: confirmPayment,
      page: () => ConfirmPaymentScreen(),
      binding: ConfirmPaymentBinding(),
    ),
//admin
    GetPage(name: adminHome, page: () => AdminHomeScreen(), bindings: [
      AdminBinding(),
      AdminUsersBinding(),
    ]),
    GetPage(name: adminProfile, page: () => AdminProfileScreen())
  ];
}
