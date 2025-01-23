import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/Screens/add_video_screen.dart';
import 'package:tiktok_styled_app/Screens/profile_screen.dart';
import 'package:tiktok_styled_app/Screens/saved_videos_screen.dart';
import 'package:tiktok_styled_app/Screens/search_screen.dart';
import 'package:tiktok_styled_app/Screens/video_screen.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';

// Dynamic Pages List
List<Widget> getPages(BuildContext context) {
  final authController = Provider.of<AuthController>(context);
  final userId = authController.user?.uid ?? '';
  return [
    const VideoScreen(),
    const SearchScreen(),
    const AddVideoScreen(),
     SavedVideosPage(),
    ProfileScreen(uid: userId),
  ];
}

// COLORS
const backgroundColor = Colors.black;
var buttonColor =  const Color.fromARGB(255, 244, 54, 143);
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
