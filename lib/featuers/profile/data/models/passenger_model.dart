import 'package:arrowspeed/featuers/profile/domin/entities/passenger.dart';
// enum PassengerGender { male, female }

class PassengerModel extends Passenger {
  PassengerModel({
    super.id = '',
    required super.userId,
    required super.name,
    required super.age,
    required super.gender,
    super.isEditing = false,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      gender: PassengerGender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => PassengerGender.male,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender.name,
    };
  }

  PassengerModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? age,
    PassengerGender? gender,
    bool? isEditing,
  }) {
    return PassengerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PassengerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
