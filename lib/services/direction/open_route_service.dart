import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' show log;
import 'package:students_guide/utils/constants.dart' as constants;

Future getData({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) async {
  final response = await http.get(
    Uri.parse(
      '${constants.url}${constants.pathParam}'
      '?api_key=${constants.apiKey}'
      '&start=$startLng,$startLat&end=$endLng,$endLat',
    ),
  );

  if (response.statusCode == 200) {
    String responseBody = response.body;
    return jsonDecode(responseBody);
  } else {
    log('API error: ${response.statusCode.toString()}');
  }
}

Future<List<LatLng>> getPolylineCoordinates({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) async {
  try {
    final jsonData = await getData(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    List coordinates = jsonData['features'][0]['geometry']['coordinates'];

    //NOTE: In the OpenRouteService API, the first value is longitude (lng)
    // and the second value is latitude (lat).
    return coordinates
        .map((coordinate) => LatLng(coordinate[1], coordinate[0]))
        .toList();
  } catch (e) {
    log(e.toString());
    return [];
  }
}
