enum BookingStatus { pending,confirmed, active, cancelled, completed }

class Booking {
  final String id;
  final String tripId;
  final String userId;
  final int passengersCount;
  final List<String> seatNumbers;
  final double totalFare;
  final BookingStatus status;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.passengersCount,
    required this.seatNumbers,
    required this.totalFare,
    required this.status,
    required this.bookingDate,
  });
}
