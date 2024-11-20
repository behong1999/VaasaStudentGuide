import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students_guide/gen/assets.gen.dart';
import 'package:students_guide/services/direction/open_route_service.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';
import 'package:students_guide/services/url_launcher.dart';

class MapView extends StatefulWidget {
  final String address;

  const MapView({super.key, required this.address});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();

  //* Polylines
  PolylineId id = const PolylineId('poly');
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  //* Markers
  Set<Marker> markers = {};
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  late LatLng currentLocation;
  late LatLng destination;

  @override
  void initState() {
    super.initState();
    mapInit();
  }

  @override
  dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    return await locationFromAddress(address)
        .then((value) => LatLng(value[0].latitude, value[0].longitude));
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int? width, int? height) async {
    ByteData data = await rootBundle.load(path);
    //* Used for decoding and manipulating image data
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    /*
     * Returns a FrameInfo object containing information about the decoded image frame,
     * including the image size and byte data
    */
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> setCustomIcon() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(Assets.images.locationIcon.path, 120, 120);

    currentIcon = BitmapDescriptor.bytes(markerIcon);
  }

  setMarkers() async {
    //* Add markers to the map
    markers.add(Marker(
      markerId: const MarkerId('current location'),
      icon: currentIcon,
      position: currentLocation,
      infoWindow: InfoWindow(title: 'current location'.toCamelCase()),
    ));
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        icon: BitmapDescriptor.defaultMarker,
        position: destination,
        infoWindow: InfoWindow(title: widget.address),
      ),
    );

    //* Draw a polyline between the current location and the destination
    polylineCoordinates = await getPolylineCoordinates(
      startLat: currentLocation.latitude,
      startLng: currentLocation.longitude,
      endLat: destination.latitude,
      endLng: destination.longitude,
    );

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      width: 3,
      points: polylineCoordinates,
    );

    polylines.add(polyline);

    //NOTE: Currently not working due to the billing issue
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   googleAPiKey,
    //   PointLatLng(currentLocation.latitude, currentLocation.longitude),
    //   PointLatLng(destination.latitude, destination.longitude),
    //   travelMode: TravelMode.walking,
    // );
    // print('Error message: ${result.errorMessage}');
    // if (result.status == 'OK') {
    //   for (var point in result.points) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   }
    // }
  }

  void mapInit() async {
    try {
      if (await Permission.location.isGranted) {
        //* Get current location
        currentLocation = await Geolocator.getCurrentPosition()
            .then((value) => LatLng(value.latitude, value.longitude));

        //* Get latitude and longitude of the destination
        destination = await getLatLngFromAddress(widget.address);
        await setCustomIcon();
        await setMarkers();
      }
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Permission.location.isDenied,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                  onPressed: () async => await openAppSettings(),
                  text: "Open permission settings to view the map"),
            ));
          } else {
            return FutureBuilder<LatLng>(
                future: getLatLngFromAddress(widget.address),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.latitude >= 0) {
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    target: snapshot.data as LatLng, zoom: 13),
                                markers: markers,
                                polylines: polylines,
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: true,
                                tiltGesturesEnabled: true,
                                compassEnabled: true,
                                zoomControlsEnabled: true,
                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                gestureRecognizers: <Factory<
                                    OneSequenceGestureRecognizer>>{
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 28,
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 3.0,
                                    )
                                  ],
                                  color: Colors.white70,
                                  border: Border.all(
                                    color: Colors.black12,
                                  )),
                              child: InkWell(
                                  onTap: () {
                                    mapLauncher(
                                      currentLocation.latitude,
                                      currentLocation.longitude,
                                      widget.address,
                                    );
                                  },
                                  child: Image.asset(
                                    Assets.images.googleMaps.path,
                                  )),
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              'Internet connection lost!',
                              size: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            CustomText(
                              'Please try again to view the map.',
                              size: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ]),
                    );
                  }
                  return const CustomLoadingIcon();
                });
          }
        });
  }
}
