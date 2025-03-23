// ignore_for_file: avoid_print, unnecessary_overrides, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapController extends GetxController {
  MapController();
  
  LatLng latLng = LatLng(0.0, 0.0);
  GoogleMapController? mapController;
  final Rx<LatLng?> userLocation = Rx<LatLng?>(null);
  final Rx<double> distance = 0.0.obs;
  final Rx<String> direction = ''.obs;
  final Rx<MapType> currentMapType = MapType.normal.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation(); 
    _updateLocationPeriodically();
  }

  void setDestination(LatLng newDestination) {
    latLng = newDestination;

    if (userLocation.value != null) {
      drawRoute(userLocation.value!, newDestination);
    }

    calculateDistance(newDestination);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return Future.error('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        userLocation.value = LatLng(position.latitude, position.longitude);
        calculateDistance(latLng);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void drawRoute(LatLng start, LatLng end) {
    polylines.clear(); 

    polylines.add(Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.blue,
      width: 5,
      points: [start, end], 
    ));
  }

  
 String calculateDistance(LatLng destination) {
  if (userLocation.value != null) {
    double calculatedDistance = Geolocator.distanceBetween(
      userLocation.value!.latitude,
      userLocation.value!.longitude,
      destination.latitude,
      destination.longitude,
    ) / 1000;
    distance.value = calculatedDistance;

    return '${calculatedDistance.toStringAsFixed(2)} km';
  }
  return "Unable to calculate";
}


  void setMapType(MapType mapType) {
    currentMapType.value = mapType;
  }

  void toggleMapType() {
    currentMapType.value = currentMapType.value == MapType.normal
        ? MapType.satellite
        : currentMapType.value == MapType.satellite
            ? MapType.terrain
            : MapType.normal;
  }

  void goToUserLocation() async {
    if (userLocation.value != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(userLocation.value!),
      );
    }
  }

  void _updateLocationPeriodically() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        await _getCurrentLocation();
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

