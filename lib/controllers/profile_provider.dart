import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_styled_app/constants.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  String _uid = "";
  String get uid => _uid;

  // Update the user ID and fetch data
  void updateUserId(String uid,BuildContext context) {
    _uid = uid;
    getUserData(context);
    Future.microtask(() {
      notifyListeners();
    });// Notify listeners when the data is updated
  }

  // Fetch user data from Firestore
  Future<void> getUserData(BuildContext context) async {
    
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    int likes = 0;
    int savedVideos = 0;
   

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
      savedVideos += (item.data()['save'] as List).length;
      
    }


    _user = {
      
      'savedVideos': savedVideos.toString(),
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };

    Future.microtask(() {
      notifyListeners();
    });
  }

 
}
