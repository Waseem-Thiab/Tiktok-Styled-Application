import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_styled_app/constants.dart';
import 'package:tiktok_styled_app/models/user.dart' as model;

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = firebaseAuth;
  final FirebaseStorage _firebaseStorage = firebaseStorage;

  User? _user;
  File? _pickedImage;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  User? get user => _user;
  File? get profilePhoto => _pickedImage;

  AuthController() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        _pickedImage = File(pickedImage.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<String> _uploadToStorage(File image) async {
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('profilePics')
          .child(_firebaseAuth.currentUser!.uid);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User newUser = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());
        _user = cred.user;
        notifyListeners();
      } else {
        throw Exception('Please enter all the fields');
      }
    } catch (e) {
      debugPrint('Error registering user: $e');
      rethrow;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        notifyListeners();
      } else {
        _errorMessage = 'Please enter all the fields';
      }
    } catch (e) {
      _errorMessage = 'Invalid email or password';
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
