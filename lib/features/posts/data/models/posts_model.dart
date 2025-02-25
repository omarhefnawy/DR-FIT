import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String uid;
  final String post;
  final String? image;
  final Timestamp date;
  final List<String> likes;

  PostModel({
    required this.postId,
    required this.uid,
    required this.post,
    required this.image,
    required this.date,
    required this.likes,
  });

  // CopyWith method
  PostModel copyWith({
    String? postId,
    String? uid,
    String? post,
    String? image,
    Timestamp? date,
    List<String>? likes,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      post: post ?? this.post,
      image: image ?? this.image,
      date: date ?? this.date,
      likes: likes ?? this.likes,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'post': post,
      'image': image,
      'date': date,
      'likes': likes,
    };
  }

  // Create from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      uid: json['uid'],
      post: json['post'],
      image: json['image'],
      date: json['date'],
      likes: List<String>.from(json['likes'] ?? []),
    );
  }
}
