import 'package:students_guide/services/articles/cloud_const.dart';
import 'package:url_launcher/url_launcher.dart';

launcher(String path, String scheme) async {
  Uri url;

  switch (scheme) {
    case telField:
      url = Uri.parse('tel:$path');
      break;
    case emailField:
      url = Uri.parse('mailto:$path');
      break;

    default:
      url = Uri.parse(path);
      break;
  }
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    throw 'Could not launch $path';
  }
}

void mapLauncher(double lat, double lng, String name) async {
  Uri url;

  url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$lat,$lng&destination=$name&travelmode=walking');
  await launchUrl(url, mode: LaunchMode.externalApplication);
}
