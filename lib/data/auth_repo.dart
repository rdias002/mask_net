import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/exception_wrapper.dart';

import '../config/logger.dart';
import '../config/result.dart';
import '../presentation/model/user_model.dart';

class AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseDb = FirebaseFirestore.instance;

  Future<Result<void>> createAccount(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user?.updateDisplayName("");

      return const ResultSuccess(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResultFailed(
            ExceptionWrapper(message: 'The password provided is too weak.'));
      } else if (e.code == 'invalid-email') {
        return ResultFailed(
            ExceptionWrapper(message: 'Please make sure email is valid.'));
      } else if (e.code == 'email-already-in-use') {
        return ResultFailed(ExceptionWrapper(
            message: 'The account already exists for that email.'));
      } else {
        logger.e(e);
        return ResultFailed(ExceptionWrapper(
            message: 'Something went wrong. Please try again.'));
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<void>> saveUserName(String userName) async {
    try {
      final result =
          await firebaseDb.collection('userNames').doc(userName).get();
      if (result.exists) {
        return ResultFailed(
            ExceptionWrapper(message: 'Username already exists.'));
      } else {
        await firebaseDb.collection('userNames').doc(userName).set({
          'userId': firebaseAuth.currentUser?.uid,
        });
        firebaseAuth.currentUser?.updateDisplayName(userName);
        return const ResultSuccess(null);
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<void>> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return const ResultSuccess(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        return ResultFailed(
            ExceptionWrapper(message: 'User not found or wrong password.'));
      } else if (e.code == 'invalid-email') {
        return ResultFailed(
            ExceptionWrapper(message: 'Please make sure email is valid.'));
      } else {
        logger.e(e);
        return ResultFailed(ExceptionWrapper(
            message: 'Something went wrong. Please try again.'));
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<void>> sendResetPasswordLink(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );

      return const ResultSuccess(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        return ResultFailed(
            ExceptionWrapper(message: 'User not found or wrong password.'));
      } else if (e.code == 'invalid-email') {
        return ResultFailed(
            ExceptionWrapper(message: 'Please make sure email is valid.'));
      } else {
        logger.e(e);
        return ResultFailed(ExceptionWrapper(
            message: 'Something went wrong. Please try again.'));
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<void>> logout() async {
    try {
      await firebaseAuth.signOut();
      return const ResultSuccess(null);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<UserProfile>> getUserProfile() async {
    try {
      return ResultSuccess(UserProfile(
        userId: firebaseAuth.currentUser?.uid ?? '',
        username: firebaseAuth.currentUser?.displayName ?? '',
        email: firebaseAuth.currentUser?.email ?? '',
      ));
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(message: 'Something went wrong.'));
    }
  }
}
