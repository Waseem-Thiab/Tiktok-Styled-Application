import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Map<String, dynamic>> searchedVideos = []; // Store video data

  Future<void> searchVideos(String query) async {
    try {
      // Fetch videos where the caption contains the query (case-insensitive)
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('caption', isGreaterThanOrEqualTo: query)
          .where('caption', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      searchedVideos = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      notifyListeners();
    } catch (e) {
      print('Error searching videos: $e');
    }
  }
}
