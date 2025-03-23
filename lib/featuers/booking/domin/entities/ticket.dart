class Ticket {
  String? id;
  final String bookingId;
  final String name;
  final String from;
  final String to;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String passengersCount;
  final String passengersNames;
  final String seatNumbers;
  final String ticketNumber;
  final String ticketFare;
  final String info;
  Ticket({
    this.id,
   required this.bookingId,
    required this.name,
    required this.from,
    required this.to,
    required this.dateFrom,
    required this.dateTo,
    required this.passengersCount,
    required this.passengersNames,
    required this.seatNumbers,
    required this.ticketNumber,
    required this.ticketFare,
    required this.info,
  });
}
