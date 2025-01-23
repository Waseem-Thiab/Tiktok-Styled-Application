import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_styled_app/constants.dart';
import 'package:tiktok_styled_app/models/video.dart';
import 'package:video_compress_v2/video_compress_v2.dart';
class UploadVideoProvider extends ChangeNotifier {
  // Compress video
Future<File> _compressVideo(String videoPath) async {
  final compressedVideo = await VideoCompressV2.compressVideo(
    videoPath,
    quality: VideoQuality.MediumQuality,
  );

  // Ensure the compressedVideo and its file are not null
  if (compressedVideo == null || compressedVideo.file == null) {
    throw Exception("Video compression failed: Compressed video or file is null.");
  }

  return compressedVideo.file!; // Safely return the non-nullable file
}

  // Upload video to storage
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    try {
      Reference ref = firebaseStorage.ref().child('videos').child(id);
      UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // Get thumbnail
  Future<File> _getThumbnail(String videoPath) async {
    return await VideoCompressV2.getFileThumbnail(videoPath);
  }

  // Upload image to storage
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    try {
      Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
      UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // Upload video
  Future<void> uploadVideo(
    BuildContext context,
    String songName,
    String caption,
    String videoPath,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      // Generate a new video ID
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;

      // Upload video and thumbnail
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      // Create Video model
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        savedVideos: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      // Save video to Firestore
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Show error using ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Uploading Video: ${e.toString()}'),
        ),
      );
    }
  }
}
