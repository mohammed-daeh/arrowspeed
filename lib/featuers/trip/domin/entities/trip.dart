import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  String? id;
  String company;
  List serves;
  String from;
  String to;
  TimeOfDay departureTime;
  TimeOfDay arrivalTime;
  DateTime tripDate;
  int discount;
  int star;
  int totalSeats;
  double price;
  LatLng latLngFrom;
  LatLng latLngTo;
  String? imageUrl; // مسار الصورة (اختياري)
  List<int> bookedSeats; // أرقام المقاعد المحجوزة
  int? availableSeats;

  Trip({
    this.id,
    required this.company,
    required this.serves,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.tripDate,
    required this.discount,
    required this.star,
    required this.totalSeats,
    required this.price,
    required this.latLngFrom,
    required this.latLngTo,
    this.availableSeats,
    this.imageUrl,
    List<int>? bookedSeats, // إذا لم يتم توفيره، يتم تهيئته كمصفوفة فارغة
  }) : bookedSeats = bookedSeats ?? [];
}
