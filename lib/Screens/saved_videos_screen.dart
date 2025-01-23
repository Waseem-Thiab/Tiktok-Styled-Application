import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/Screens/saved_video_player_screen.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';

class SavedVideosPage extends StatefulWidget {
  @override
  _SavedVideosPageState createState() => _SavedVideosPageState();
}

class _SavedVideosPageState extends State<SavedVideosPage> {
  List<DocumentSnapshot> savedVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedVideos();
  }

  Future<void> fetchSavedVideos() async {
    var authController = Provider.of<AuthController>(context, listen: false);
    var uid = authController.user!.uid;

    // Fetch videos where the current user's UID is in the 'save' array
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('save', arrayContains: uid)
        .get();

    setState(() {
      savedVideos = snapshot.docs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 54, 143),
        title: const Text('Saved Videos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: savedVideos.length,
              itemBuilder: (context, index) {
                var video = savedVideos[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedVideoPlayerScreen(
                          videoUrl: video['videoUrl'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail image
                        Image.network(
                          video['thumbnail'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        // Caption or username
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            video['caption'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
