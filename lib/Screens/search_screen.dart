import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/Screens/saved_video_player_screen.dart';
import 'package:tiktok_styled_app/controllers/search_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 244, 54, 143),
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: 'Search videos by caption',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onFieldSubmitted: (value) => searchProvider.searchVideos(value),
            ),
          ),
          body: searchProvider.searchedVideos.isEmpty
              ? const Center(
                  child: Text(
                    'Search for videos!',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Horizontal spacing
                    mainAxisSpacing: 8.0, // Vertical spacing
                  ),
                  itemCount: searchProvider.searchedVideos.length,
                  itemBuilder: (context, index) {
                    var video = searchProvider.searchedVideos[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to VideoPlayerScreen with videoUrl
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedVideoPlayerScreen(
                              videoUrl: video['videoUrl'], // Pass video URL
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            video['thumbnail'], // Display video thumbnail
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
