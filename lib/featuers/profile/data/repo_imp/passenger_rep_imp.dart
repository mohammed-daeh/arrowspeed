import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/profile/domin/repositories/passenger_repository.dart';

import 'package:arrowspeed/featuers/profile/data/datasources/passenger_firebase_source.dart';

class PassengerRepositoryImpl extends PassengerRepository {
  final PassengerFirebaseSource _source;

  PassengerRepositoryImpl(this._source);

  @override
  Future<void> addPassenger(PassengerModel passenger, String userId) async {
    await _source.addPassenger(passenger,userId);
  }

  @override
  Future<void> updatePassenger(PassengerModel passenger,String userId) async {
    await _source.updatePassenger(passenger,userId);
  }

  @override
  Future<void> deletePassenger(String id, String userId) async {
    await _source.deletePassenger(id,userId);
  }

  @override
  Future<PassengerModel?> getPassengerById(String id) async {
    return await _source.getPassengerById(id);
  }


  @override
  Stream<List<PassengerModel>> getPassengersByUserId(String userId) {
    return _source.getPassengersByUserId(userId);
  }
}
