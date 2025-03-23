enum UserGender { male, female }

class User {
  final String? id;
  final String firstName;
  final String lastName;
  final String authEmail; 
  final String loginEmail; 
  final String phoneNumber;
  final UserGender gender;
  final String profilePhoto; 
  final String passwordHash; 
  final bool isVerified; 
  final bool isLogin; 
  final String otp;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.authEmail,
    required this.loginEmail,
    required this.phoneNumber,
    required this.gender,
    this.otp = "",
    this.profilePhoto = '', 
    required this.passwordHash,
    this.isVerified = false, 
    this.isLogin = false, 
  });
}
