import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/constants.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';
import 'package:tiktok_styled_app/models/video.dart';

class VideoController extends ChangeNotifier {
  final List<Video> _videoList = [];

  List<Video> get videoList => _videoList;

  VideoController() {
    _fetchVideos();
  }

  // Fetch videos from Firestore
  Future<void> _fetchVideos() async {
    firestore.collection('videos').snapshots().listen((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      _videoList.clear();
      _videoList.addAll(retVal);
      notifyListeners(); // Notify UI to update
    });
  }

  // Like/unlike a video
  Future<void> likeVideo(String id, BuildContext context) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var authController = Provider.of<AuthController>(context, listen: false);
    var uid = authController.user!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }

    // After like/unlike, we fetch videos again to update UI
    _fetchVideos();
  }


// Like/unlike a video
  Future<void> saveVideos(String id, BuildContext context) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var authController = Provider.of<AuthController>(context, listen: false);
    var uid = authController.user!.uid;
    if ((doc.data()! as dynamic)['save'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'save': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'save': FieldValue.arrayUnion([uid]),
      });
    }

    // After like/unlike, we fetch videos again to update UI
    notifyListeners();
  }





  
}
