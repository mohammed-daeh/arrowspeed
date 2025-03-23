import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';

abstract class PassengerRepository {
  Future<void> addPassenger(PassengerModel passenger, String userId);

  Future<void> updatePassenger(PassengerModel passenger,String userId);

  Future<void> deletePassenger(String id, String userId);

  Future<PassengerModel?> getPassengerById(String id);

 Stream<List<PassengerModel>> getPassengersByUserId(String userId);
}
