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
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/dialogs/location_permission_dialog.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';
import 'package:students_guide/utils/url_launcher.dart';

class MapView extends StatefulWidget {
  final String address;

  const MapView({Key? key, required this.address}) : super(key: key);

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

    currentIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    return await locationFromAddress(address)
        .then((value) => LatLng(value[0].latitude, value[0].longitude));
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
        await setPolylines();
        // setState(() {});
      } else {
        Future.delayed(
          const Duration(seconds: 0),
          () async => await requestLocationPermission(context),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  setPolylines() async {
    //* Add markers to the map
    markers.add(Marker(
      markerId: const MarkerId('current location'),
      icon: currentIcon,
      position: currentLocation,
      infoWindow: InfoWindow(title: 'current location'.toCamelCase()),
    ));
    markers.add(Marker(
      markerId: const MarkerId('destination'),
      icon: BitmapDescriptor.defaultMarker,
      position: destination,
      infoWindow: InfoWindow(title: widget.address),
    ));

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

  @override
  Widget build(BuildContext context) {
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
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
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
                          color: Colors.white70,
                          border: Border.all(
                            color: Colors.black12,
                          )),
                      child: IconButton(
                          iconSize: 28,
                          onPressed: () {
                            mapLauncher(
                              currentLocation.latitude,
                              currentLocation.longitude,
                              widget.address,
                            );
                          },
                          icon: const Icon(Icons.open_in_full, color: mColor)),
                    ),
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Center(
                child: CustomText(
                  'Cannot open map view. Please check the Internet connection and try again.',
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return const CustomLoadingIcon();
        });
  }
}
