import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String postId;
  final String commentId;
  final String uid;
  final String comment;
  final Timestamp time;

  CommentModel({
    required this.postId,
    required this.uid,
    required this.comment,
    required this.time,
    required this.commentId,
  });

  // CopyWith method
  CommentModel copyWith({
    String? postId,
    String? uid,
    String? comment,
    Timestamp? time,
    String? commentId,
  }) {
    return CommentModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      comment: comment ?? this.comment,
      time: time ?? this.time,
      commentId: commentId ?? this.commentId,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'comment': comment,
      'time': time,
      'commentId': commentId,
    };
  }

  // Create from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: json['postId'],
      uid: json['uid'],
      comment: json['comment'],
      time: json['time'],
      commentId: json['commentId'],
    );
  }
}
