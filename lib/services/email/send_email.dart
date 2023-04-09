import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students_guide/utils/constants.dart' as constants;

Future sendEmail({
  String name = 'User',
  required String email,
  required String content,
}) async {
  final url = Uri.parse(constants.sendEmailUrl);
  await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
      {
        'service_id': constants.serviceId,
        'template_id': constants.templateId,
        'user_id': constants.userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': 'A Message From $name (Vaasa Student Guide)',
          'user_message': content,
        }
      },
    ),
  );
}
