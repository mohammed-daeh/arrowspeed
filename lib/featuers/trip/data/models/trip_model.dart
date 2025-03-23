import 'package:arrowspeed/featuers/trip/domin/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class TripModel extends Trip {
  TripModel({
    super.id,
    required super.company,
    required super.serves,
    required super.from,
    required super.to,
    required super.departureTime,
    required super.arrivalTime,
    required super.tripDate,
    required super.discount,
    required super.star,
    required super.totalSeats,
    required super.price,
    required super.latLngFrom,
    required super.latLngTo,
    super.imageUrl,
    super.bookedSeats,
    super.availableSeats,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      serves: List<String>.from(json['serves'] ?? []),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      departureTime: _parseTime(json['dateFrom']),
      arrivalTime: _parseTime(json['dateTo']),
      tripDate: json['tripDate'] != null
          ? DateTime.parse(json['tripDate'])
          : DateTime.now(),
      discount: json['discount'] ?? 0,
      star: json['star'] ?? 0,
      totalSeats: json['totalSeats'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      latLngTo: _parseLatLng(json['latLngTo']),
      latLngFrom: _parseLatLng(json['latLngFrom']),
      imageUrl: json['imageUrl'] ?? '',
      bookedSeats: (json['bookedSeats'] as List?)
              ?.map((e) => int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
      availableSeats: json['availableSeats'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'serves': serves,
      'from': from,
      'to': to,
      'departureTime': _formatTime(departureTime),
      'arrivalTime': _formatTime(arrivalTime),
      'tripDate': tripDate.toIso8601String(),
      'discount': discount,
      'star': star,
      'totalSeats': totalSeats,
      'price': price,
      'latLngTo': {'lat': latLngTo.latitude, 'lng': latLngTo.longitude},
      'latLngFrom': {'lat': latLngFrom.latitude, 'lng': latLngFrom.longitude},
      'imageUrl': imageUrl,
      'bookedSeats': bookedSeats,
      'availableSeats': availableSeats,
    };
  }

  TripModel copyWith({
    String? id,
    String? company,
    List<String>? serves,
    String? from,
    String? to,
    TimeOfDay? departureTime,
    TimeOfDay? arrivalTime,
    DateTime? tripDate,
    int? discount,
    int? star,
    int? totalSeats,
    double? price,
    LatLng? latLngFrom,
    LatLng? latLngTo,
    String? imageUrl,
    List<int>? bookedSeats,
    int? availableSeats,
  }) {
    return TripModel(
      id: id ?? this.id,
      company: company ?? this.company,
      serves: serves ?? this.serves,
      from: from ?? this.from,
      to: to ?? this.to,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      tripDate: tripDate ?? this.tripDate,
      discount: discount ?? this.discount,
      star: star ?? this.star,
      totalSeats: totalSeats ?? this.totalSeats,
      price: price ?? this.price,
      latLngFrom: latLngFrom ?? this.latLngFrom,
      latLngTo: latLngTo ?? this.latLngTo,
      imageUrl: imageUrl ?? this.imageUrl,
      bookedSeats: bookedSeats ?? this.bookedSeats,
      availableSeats: availableSeats ?? this.availableSeats,
    );
  }

  static TimeOfDay _parseTime(String? time) {
    if (time == null) return const TimeOfDay(hour: 0, minute: 0);
    final parts = time.split(":");
    return (parts.length == 2)
        ? TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]))
        : const TimeOfDay(hour: 0, minute: 0);
  }

  static String _formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  static LatLng _parseLatLng(dynamic json) {
    return (json != null && json['lat'] != null && json['lng'] != null)
        ? LatLng(json['lat'], json['lng'])
        : const LatLng(0, 0);
  }
}
