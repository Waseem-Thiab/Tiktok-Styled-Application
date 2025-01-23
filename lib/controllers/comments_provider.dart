import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_styled_app/constants.dart';
import 'package:tiktok_styled_app/controllers/auth_provider.dart';
import 'package:tiktok_styled_app/models/comment.dart';

class CommentController extends ChangeNotifier {
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  String _postId = "";
  void updatePostId(String id) {
    _postId = id;
    getComment();
  }

  // Get comments from Firestore
  void getComment() {
    FirebaseFirestore.instance
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .listen((QuerySnapshot query) {
      List<Comment> retValue = [];
      for (var element in query.docs) {
        retValue.add(Comment.fromSnap(element));
      }
      _comments = retValue;
      notifyListeners(); // Notify listeners when the comments are updated
    });
  }

  // Post a new comment
  Future<void> postComment(String commentText, BuildContext context) async {
    var authController = Provider.of<AuthController>(context, listen: false);

    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user!.uid)
            .get();
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user!.uid,
          id: 'Comment $len',
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());

        DocumentSnapshot doc =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
      rethrow;
    }
  }

  // Like or unlike a comment
  Future<void> likeComment(String id, BuildContext context) async {
    var authController = Provider.of<AuthController>(context, listen: false);

    var uid = authController.user!.uid;
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
