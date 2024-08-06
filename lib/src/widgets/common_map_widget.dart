import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/my_booking/confirm_booking_screen.dart';

class CommonMapWidget extends StatelessWidget {
  final double latitude;

  final double longitude;
  final Set<Marker> markers;

  CommonMapWidget({super.key, required this.latitude, required this.longitude, required this.markers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: Get.height * 0.22,
        width: double.infinity,
        child: GoogleMap(
          onTap: (arguments) async {
            MapUtils.openMap(latitude, longitude);
          },
          onMapCreated: _onMapCreated,
          // markers: Set<Marker>.of(controller.markers.value.),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          scrollGesturesEnabled: false,
          markers: markers,
          //enable Zoom in, out on map
          initialCameraPosition: CameraPosition(
            //innital position in map
            target: LatLng(latitude, longitude),
            //initial position
            zoom: 18.0, //initial zoom level
          ),
        ),
      ),
    );
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
