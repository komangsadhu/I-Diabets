import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final String USER_COLLECTION = "users";

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  User? get currentFirebaseUser => _auth.currentUser;

  Future<bool> checkAndLoadUserData() async {
    if (currentFirebaseUser == null) {
      await logout();
      debugPrint("No user logged in. Forced logout.");
      return false;
    }
    try {
      currentUser = await getUserData(uid: currentFirebaseUser!.uid);
      debugPrint("User data loaded successfully.");
      return true;
    } catch (e) {
      debugPrint("Failed to load user data: $e");
      await logout();
      return false;
    }
  }

  Future<void> sendUserData({
    required String age,
    required String weight,
    required double temperature,
    required double heartRate,
    required double spo2,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("No user logged in. Cannot send user data.");
      return;
    }

    try {
      CollectionReference userCollection = _db.collection(USER_COLLECTION);

      await userCollection.doc(user.uid).set({
        "age": age,
        "weight": weight,
        "temperature": temperature,
        "heartRate": heartRate,
        "spo2": spo2,
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("User data sent to Firestore");
    } catch (e) {
      debugPrint("Failed to send user data: $e");
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredential.user!.uid;
      await _db.collection(USER_COLLECTION).doc(_userId).set({
        "name": name,
        "email": email,
      });
      return true;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Login error: ${e.message}");
      return false;
    } catch (e) {
      debugPrint("Login general error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    currentUser = null;
    debugPrint("User logged out.");
  }
}
