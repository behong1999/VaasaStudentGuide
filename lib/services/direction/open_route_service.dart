import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' show log;

Future getData({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) async {
  const String url = 'https://api.openrouteservice.org/v2/directions/';
  const String apiKey =
      "5b3ce3597851110001cf624872639b9704d84199bc7efe002e05608d";
  const String pathParam = 'foot-walking'; // Change it if you want

  final response = await http.get(Uri.parse(
      '$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));

  if (response.statusCode == 200) {
    String responseBody = response.body;
    return jsonDecode(responseBody);
  } else {
    log(response.statusCode.toString());
  }
}

Future<List<LatLng>> getPolylineCoordinates({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) async {
  try {
    final json = await getData(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    List coordinates = (json['features'][0]['geometry']['coordinates']);

    //NOTE: In the OpenRouteService API, the first value is longitude (lng) and the second value is latitude (lat).
    return coordinates
        .map((coordinate) => LatLng(coordinate[1], coordinate[0]))
        .toList();
  } catch (e) {
    log(e.toString());
    return [];
  }
}
