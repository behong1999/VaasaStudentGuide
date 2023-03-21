import 'package:firebase_auth/firebase_auth.dart' show User;

class AdminModel {
  final String id;
  final String? email;

  AdminModel({
    required this.id,
    required this.email,
  });

  factory AdminModel.fromFirebase(User user) => AdminModel(
        email: user.email,
        id: user.uid,
      );
}
