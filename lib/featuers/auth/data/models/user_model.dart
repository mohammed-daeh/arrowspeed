import 'package:arrowspeed/featuers/auth/domin/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.authEmail, 
    required super.loginEmail, 
    required super.phoneNumber,
    required super.gender,
    String? profilePhoto,
    required super.passwordHash, 
    required super.isVerified, 
    required super.isLogin, 
    String? otp, 
  }) : super(
          otp: otp ?? "",
          profilePhoto: profilePhoto ?? '',
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      authEmail: json['authEmail'], 
      loginEmail:
          json['loginEmail'], 
      phoneNumber: json['phoneNumber'],
      gender: UserGender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => UserGender.male,
      ),
      profilePhoto: json['profilePhoto'],
      otp: json['otp'],
      passwordHash: json['passwordHash'], 
      isVerified: json['isVerified'] ?? false, 
      isLogin: json['isLogin'] ?? false, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'authEmail': authEmail, 
      'loginEmail': loginEmail, 
      'phoneNumber': phoneNumber,
      'gender': gender.name,
      'profilePhoto': profilePhoto,
      'otp': otp,
      'passwordHash': passwordHash,
      'isVerified': isVerified,
      'isLogin': isLogin,
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? authEmail, 
    String? loginEmail, 
    String? phoneNumber,
    UserGender? gender,
    String? profilePhoto,
    String? passwordHash, 
    bool? isVerified,
    bool? isLogin, 
    String? otp, 
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      authEmail: authEmail ?? this.authEmail,
      loginEmail: loginEmail ?? this.loginEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      passwordHash: passwordHash ?? this.passwordHash,
      isVerified: isVerified ?? this.isVerified,
      isLogin: isLogin ?? this.isLogin,
      otp: otp ?? this.otp,
    );
  }
}

