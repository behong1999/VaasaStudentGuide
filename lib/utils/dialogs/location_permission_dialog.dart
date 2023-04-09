import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students_guide/utils/dialogs/generic_dialog.dart';

Future<void> requestLocationPermission(BuildContext context) async {
  final permissionStatus = await Permission.location.request();
  Future.delayed(
    Duration.zero,
    () {
      if (permissionStatus.isDenied) {
        showGenericDialog(
          context: context,
          content: const Text(
            'This app requires location permission to function properly. Please grant access to your location in settings.',
          ),
          optionBuilder: () {
            return {
              'Settings': openAppSettings(),
              'Cancel': null,
            };
          },
          title: const Text('Location Permission Required'),
        );
      }
    },
  );
}
