import 'package:arrowspeed/featuers/booking/domin/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel(
      {super.id,
      required super.bookingId,
      required super.name,
      required super.from,
      required super.to,
      required super.dateFrom,
      required super.dateTo,
      required super.passengersCount,
      required super.passengersNames,
      required super.seatNumbers,
      required super.ticketNumber,
      required super.ticketFare,
      required super.info});

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      bookingId: json['bookingId'],
      name: json['name'],
      from: json['from'],
      to: json['to'],
      dateFrom: json['dateFrom'],
      dateTo: json['dateTo'],
      passengersCount: json['passengersCount'],
      passengersNames: json['passengersNames'],
      seatNumbers: json['seatNumbers'],
      ticketNumber: json['ticketNumber'],
      ticketFare: json['ticketFare'],
      info: json['info'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'name': name,
      'from': from,
      'to': to,
      'dateFrom': dateFrom.toIso8601String(),
      'dateTo': dateTo.toIso8601String(),
      'passengersCount': passengersCount,
      'passengersNames': passengersNames,
      'seatNumbers': seatNumbers,
      'ticketNumber': ticketNumber,
      'ticketFare': ticketFare,
      'info': info,
    };
  }
}
