import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practices/models/user_model.dart';
// import '../models/user_model.dart'; // ✅ CORRECT IMPORT

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ GET CURRENT USER
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return null;

    return UserModel.fromMap(userDoc.data()!);
  }

  /// ✅ AUTH STATE CHANGES STREAM
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) return null;
      print(userDoc.data());
      return UserModel.fromMap(userDoc.data()!);
    });
  }

  /// ✅ SIGN UP
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? address, String? bio,
  }) async {
    // ✅ 1. CREATE USER IN FIREBASE AUTH
    final userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // ✅ 2. CREATE USER MODEL
    final userModel = UserModel(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      address: address,
      createdAt: DateTime.now(),
      displayName: '',
    );

    // ✅ 3. SAVE TO FIRESTORE
    await _firestore
        .collection('users')
        .doc(uid)
        .set(userModel.toMap());

    return userModel;
  }

  /// ✅ SIGN IN  ✅ (THIS FIXES LOADING FOREVER ISSUE)
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;
    print(uid);

    final userDoc =
        await _firestore.collection('users').doc(uid).get();
    print(userDoc.data());

    if (!userDoc.exists) {
      print('User data not found in database!');
      throw Exception('User data not found in database!');
    }

    return UserModel.fromMap(userDoc.data()!);
  }

  /// ✅ SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ✅ UPDATE PROFILE
  Future<void> updateProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toMap());
  }

  /// ✅ PASSWORD RESET
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
