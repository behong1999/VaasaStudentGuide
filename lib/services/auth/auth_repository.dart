import 'package:students_guide/models/admin_model.dart';

abstract class AuthRepository {
  Future initialize();

  AdminModel? get currentAdmin;

  Future<AdminModel> signIn({
    required String email,
    required String password,
  });

  Future signOut();

  Future<void> resetPassword({required String email});
}
