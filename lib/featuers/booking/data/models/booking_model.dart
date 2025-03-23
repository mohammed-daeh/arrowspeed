import 'package:arrowspeed/featuers/booking/domin/entities/booking.dart';


class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.tripId,
    required super.userId,
    required super.passengersCount,
    required super.seatNumbers,
    required super.totalFare,
    required super.status,
    required super.bookingDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      tripId: json['tripId'],
      userId: json['userId'],
      passengersCount: json['passengersCount'],
      seatNumbers: List<String>.from(json['seatNumbers']),
      totalFare: (json['totalFare'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
          (e) => e.toString() == 'BookingStatus.${json['status']}',
          orElse: () => BookingStatus.pending), 
      bookingDate: DateTime.parse(json['bookingDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'passengersCount': passengersCount,
      'seatNumbers': seatNumbers,
      'totalFare': totalFare,
      'status': status.toString().split('.').last,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }
}
