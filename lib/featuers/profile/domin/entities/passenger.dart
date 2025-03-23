enum PassengerGender { male, female }

class Passenger {
   String? id;
   String userId;
  final String name;
  final String age;
   PassengerGender gender;
    bool? isEditing;


  Passenger({
     this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
     this.isEditing,
  });
}
