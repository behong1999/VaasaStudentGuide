import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students_guide/utils/dialogs/generic_dialog.dart';

Future<PermissionStatus> checkPermissionStatus() async {
  return await Permission.location.request();
}

Future<void> requestLocationPermission(BuildContext context) async {
  final permissionStatus = await checkPermissionStatus();

  if (permissionStatus.isDenied) {
    // ignore: use_build_context_synchronously
    final isOpenSettings = await showGenericDialog<bool>(
      context: context,
      content: const Text(
        'This app requires location permission to function properly. Please grant access to your location in settings.',
      ),
      optionBuilder: () {
        return {
          'Settings': true,
          'Cancel': false,
        };
      },
      title: const Text('Location Permission Required'),
    );
    if (isOpenSettings!) {
      await openAppSettings();
    }
  }
}
