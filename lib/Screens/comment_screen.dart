import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';
import 'package:tiktok_styled_app/controllers/comments_provider.dart';
import 'package:timeago/timeago.dart' as tago;


class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    super.key,
    required this.id,
  });

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      var authController = Provider.of<AuthController>(context, listen: false);

    // Get the CommentController using ChangeNotifierProvider
    final commentController = Provider.of<CommentController>(context, listen: false);
    commentController.updatePostId(id);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Consumer<CommentController>(
                  builder: (context, commentController, child) {
                    return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(comment.profilePhoto),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "${comment.username}  ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                comment.comment,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                tago.format(comment.datePublished.toDate()),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${comment.likes.length} likes',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () => commentController.likeComment(comment.id, context),
                            child: Icon(
                              Icons.favorite,
                              size: 25,
                              color: comment.likes.contains(authController.user!.uid)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => commentController.postComment(_commentController.text, context),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
