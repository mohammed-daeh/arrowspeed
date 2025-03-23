import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullMapWidget extends StatelessWidget {
  final LatLng destination; // ✅ الوجهة المطلوبة
  final MapController controller = Get.put(MapController());

  FullMapWidget({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.oxfordBlue,
        title: const Text(
          'Full Map',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<MapType>(
            onSelected: (MapType mapType) {
              controller.setMapType(mapType);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: MapType.hybrid,
                  child: Text('hybrid'),
                ),
                PopupMenuItem(
                  value: MapType.normal,
                  child: Text('Normal'),
                ),
                PopupMenuItem(
                  value: MapType.satellite,
                  child: Text('Satellite'),
                ),
                PopupMenuItem(
                  value: MapType.terrain,
                  child: Text('Terrain'),
                ),
              ];
            },
            icon: Icon(
              Icons.map,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      body: Obx(
        () => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: controller.userLocation.value ?? LatLng(0, 0),
            zoom: 12.0,
          ),
          onMapCreated: controller.onMapCreated,
          markers: {
            if (controller.userLocation.value != null)
              Marker(
                markerId: MarkerId('user_location'),
                position: controller.userLocation.value!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                infoWindow: InfoWindow(title: 'Your Location'),
              ),
            Marker(
              markerId: MarkerId('destination'),
              position: destination,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'Destination'),
            ),
          },
          polylines: controller.polylines, 
          mapType:
              controller.currentMapType.value, 

          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}

