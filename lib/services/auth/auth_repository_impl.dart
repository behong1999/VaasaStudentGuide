import 'package:firebase_core/firebase_core.dart';
import 'package:students_guide/firebase_options.dart';
import 'package:students_guide/models/admin_model.dart';
import 'package:students_guide/services/auth/auth_exception.dart';
import 'package:students_guide/services/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, FirebaseAuth;

class AuthRepositoryImpl implements AuthRepository {
  @override
  AdminModel? get currentAdmin {
    final admin = FirebaseAuth.instance.currentUser;
    if (admin != null) {
      return AdminModel.fromFirebase(admin);
    } else {
      return null;
    }
  }

  @override
  Future initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AdminModel> signIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final admin = currentAdmin;
      if (admin != null) {
        return admin;
      } else {
        throw AdminNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AdminNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future signOut() async {
    final admin = FirebaseAuth.instance.currentUser;
    if (admin != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw AdminNotLoggedInAuthException();
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AdminNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }
}
