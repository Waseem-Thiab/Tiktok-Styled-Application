import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/Screens/auth/login_Screen.dart';
import 'package:tiktok_styled_app/Screens/home_screen.dart';
import 'package:tiktok_styled_app/constants.dart';
import 'package:tiktok_styled_app/controllers/add_video_page_provider.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';
import 'package:tiktok_styled_app/controllers/comments_provider.dart';
import 'package:tiktok_styled_app/controllers/profile_provider.dart';
import 'package:tiktok_styled_app/controllers/search_provider.dart';
import 'package:tiktok_styled_app/controllers/theme_provider.dart';
import 'package:tiktok_styled_app/controllers/video_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UploadVideoProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CommentController()),
        ChangeNotifierProvider(create: (_) => VideoController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),


      ],
      child:const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Tiktok Styled App',
      theme: themeProvider.themeData,
      home: Consumer<AuthController>(
        builder: (context, authController, child) {
          return authController.user != null ? const HomeScreen() : LoginScreen();
        },
      ),
    );
  }
}
