import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice_ex/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_binding.dart';
import 'package:talat/src/screens/map/map_controller.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';

import '../../app_routes/app_routes.dart';
import '../../models/search_map_model.dart';
import '../../theme/color_constants.dart';
import '../../theme/image_constants.dart';
import '../../utils/flutter_google_places_custom/flutter_google_places.dart';
import '../../widgets/common_text_style.dart';
import '../activite/activity_detail/activity_detail_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double zoomVal = 5.0;

  final myMapController = Get.put(MapScreenController());

  BitmapDescriptor? pinLocationIcon;

  final Completer<BitmapDescriptor> iconCompleter =
      Completer<BitmapDescriptor>();

  Marker? marker;

  bool? isVisible = false;

  double? latitude;
  double? longtitude;

  final List<Prediction> _suggestions = [];

  late GoogleMapsPlaces places;
  var kGoogleApiKey = "AIzaSyDFEDH0OFN1aYV2n2QQ1zIbC8J6t9mngPI";

  @override
  void initState() {
    addMarkers();
    places =
        GoogleMapsPlaces(apiKey: 'AIzaSyDFEDH0OFN1aYV2n2QQ1zIbC8J6t9mngPI');

    pinLocationIcon;
    _suggestions;
    super.initState();
    myMapController.getSearchMap().then((value) {
      addMarkerIcon();
    });
    searchUserLong.value = "";
    searchUserLat.value = "";
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        ImageConstant.dashBoardTalatIcon);
  }

  //

  @override
  Widget build(BuildContext context) {
    addMarkerIcon();
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: toLabelValue("maps_near_title_label"),
      ),
      body: GetBuilder<MapScreenController>(builder: (controller) {
        return Stack(
          children: <Widget>[
            buildGoogleMap(context),
            // searchLocation(),
            GestureDetector(
              onTap: () {
                _handlePressButton(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              toLabelValue("search_location_label"),
                              style: txtStyleNormalBlack14(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 60,
                        width: 44,
                        // margin: EdgeInsets.all(value),
                        decoration: BoxDecoration(
                            color: ColorConstant.appThemeColor,
                            borderRadius: language == "1"
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                        child: Icon(
                          Icons.search,
                          size: 25,
                          color: ColorConstant.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 98.0, right: 18),
              child: _zoomplusfunction(),
            ),
            Obx(() => (controller.mapResponseResult.value.providerName !=
                        null &&
                    controller.mapResponseResult.value.providerName!.isNotEmpty)
                ? Positioned(
                    bottom: 70,
                    left: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        providerID.value =
                            controller.mapResponseResult.value.providerId ?? '';
                        itemID.value =
                            controller.mapResponseResult.value.id ?? '';
                        // providerID.value =
                        //     popularListData?.providerId ?? '';
                        ActivityDetailBinding().dependencies();
                        Get.find<ActivityDetailController>()
                            .categoryActivityDetail();

                        Get.toNamed(
                          AppRouteNameConstant.activityDetailScreen,
                        );
                      },
                      child: Container(
                        // alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // color: Colors.red,
                        // height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12)),
                              child: CachedNetworkImage(
                                imageUrl: controller
                                        .mapResponseResult.value.main_image ??
                                    '',
                                fit: BoxFit.cover,
                                height: 148,
                                width: Get.width,
                                placeholder: (context, url) {
                                  return const PlaceholderImage();
                                },
                                errorWidget: (context, url, error) {
                                  return const PlaceholderImage();
                                },
                              ),
                            ),
                            //
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Text(
                                  controller.mapResponseResult.value
                                          .activity_name ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Text(
                                  controller.mapResponseResult.value
                                          .providerName ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(controller
                                          .mapResponseResult.value.distance ??
                                      "")
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox())
          ],
        );
      }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
          onTap: () async {
            final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            // final location = Location(lat: latitude??0.0 , lng: longtitude ?? 0.0);
            userLat.value = position.latitude.toString();
            userLong.value = position.longitude.toString();
            gotoLocation(position.latitude, position.longitude);
            myMapController.getSearchMap().then((value) {
              addMarkerIcon();
            });
            addMarkers();
          },
          child: Image.asset(ImageConstant.mapIcon, height: 48, width: 48)),
    );
  }

  Widget buildGoogleMap(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
              target: (userLat.value == "")
                  ? const LatLng(29.3117, 47.9774)
                  : LatLng(double.parse(userLat.value),
                      double.parse(userLong.value)),
              zoom: 16),
          onTap: (argument) {
            myMapController.selectedId = '';
            myMapController.mapResponseResult.value = MapResult();
            myMapController.selectedMapResponseResult.value = MapResult();
            myMapController.update();
            setState(() {});
          },
          onMapCreated: (GoogleMapController controller) {
            myMapController.markerController.complete(controller);
          },
          markers: myMapController.markers.value,
        ),
      );
    });
  }

  Future<void> _handlePressButton(BuildContext context) async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        logo: const Text(""),
        // onError: onError,
        // mode: _mode,
        language: "en",

        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.search),
          hintText: 'Search location',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),

        components: [
          Component(Component.country, "in"),
          // Component(Component.country, "uk"),
          Component(Component.country, "kw"),
        ],
        offset: 0,
        radius: 1000,
        types: [],
        strictbounds: false,

        region: "kw",

        mode: Mode.fullscreen,
      );

      if (p != null) {
        // print(p);
        displayPrediction(p);
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> displayPrediction(Prediction? p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (p != null) {
      // get detail (lat/lng)

      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      // print(_places);
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result?.geometry?.location.lat;
      final lng = detail.result?.geometry?.location.lng;
      // print(lat);
      // print(lng);
      userLat.value = lat.toString();
      userLong.value = lng.toString();
      myMapController.getSearchMap();

      gotoLocation(lat ?? 0, lng ?? 0);
      myMapController.getSearchMap().then((value) {
        addMarkerIcon();
      });
      addMarkers();

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userLat.value = position.latitude.toString();
      userLong.value = position.longitude.toString();

      prefs.setString("customer_lat", userLat.value.toString());
      prefs.setString("customer_long", userLong.toString());
    }
  }

  addMarkers() async {
    myMapController.getSearchMap();

    myMapController.markers.add(Marker(
      markerId: const MarkerId('My location'),
      position:
          LatLng(double.parse(userLat.value), double.parse(userLong.value)),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        // isVisible = true;
      },
    ));
  }

  Future<void> addMarkerIcon() async {
    final Uint8List markerIcon = await getBytesFromAsset(
        'assets/map_icons/MicrosoftTeams-image.png', 100);
    final Uint8List markerIconRed = await getBytesFromAsset(
        'assets/map_icons/MicrosoftTeams-image_red.png', 100);
    if (myMapController.mapResponse.value.result != null &&
        myMapController.mapResponse.value.result!.isNotEmpty) {
      BitmapDescriptor markerBitMap = BitmapDescriptor.fromBytes(markerIcon);
      BitmapDescriptor markerBitMapRed =
          BitmapDescriptor.fromBytes(markerIconRed);
      for (int i = 0;
          i < myMapController.mapResponse.value.result!.length;
          i++) {
        var result = myMapController.mapResponse.value.result?[i];
        myMapController.markers.add(
          Marker(
            visible: true,
            markerId: MarkerId("${result?.id}"),
            position: LatLng(double.parse(result?.latitude ?? '0.0'),
                double.parse(result?.longitude ?? '0.0')),
            infoWindow: InfoWindow(title: "${result?.activity_name}"),
            icon: myMapController.selectedId == result?.id
                ? markerBitMapRed
                : markerBitMap,
            onTap: () {
              // print(result?.id);
              myMapController.selectedId = result?.id;
              myMapController.mapResponseResult.value = result!;
              myMapController.selectedMapResponseResult.value = result;
              myMapController.update();
              setState(() {});
            },
          ),
        );
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> gotoLocation(double lat, double long) async {
    final GoogleMapController _controller =
        await myMapController.markerController.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
