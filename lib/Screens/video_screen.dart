import 'package:flutter/material.dart';
import 'package:tiktok_styled_app/Screens/comment_screen.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';
import 'package:tiktok_styled_app/controllers/video_provider.dart';
import 'package:tiktok_styled_app/widgets/circle_animation.dart';
import 'package:tiktok_styled_app/widgets/video_player_item.dart';

import 'package:provider/provider.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoController = Provider.of<VideoController>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView.builder(
        itemCount: videoController.videoList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final data = videoController.videoList[index];

          return Stack(
            children: [
              VideoPlayerItem(
                videoUrl: data.videoUrl,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  data.username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data.caption,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.music_note,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      data.songName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height / 2,
                          width: 80,
                          margin: EdgeInsets.only(top: size.height / 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildProfile(data.profilePhoto),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      videoController.likeVideo(
                                        data.id,
                                        context,
                                      );
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      size: 40,
                                      color: data.likes.contains(
                                              Provider.of<AuthController>(
                                                      context)
                                                  .user
                                                  ?.uid)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    data.likes.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          id: data.id,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.comment_bank_outlined,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    data.commentCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {  videoController.saveVideos(
                                        data.id,
                                        context,
                                      );},
                                child:  Icon(
                                  Icons.bookmark_outlined,
                                  size: 40,
                                  color: data.savedVideos.contains(
                                              Provider.of<AuthController>(
                                                      context)
                                                  .user
                                                  ?.uid)
                                          ? Colors.amber
                                          : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 7),
                              InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.reply,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 7),
                              CircleAnimation(
                                child: buildMusicAlbum(data.profilePhoto),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }
}
