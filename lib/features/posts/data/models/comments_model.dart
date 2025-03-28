import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String postId;
  final String commentId;
  final String uid;
  final String userName; // ✅ إضافة اسم المستخدم
  final String comment;
  final Timestamp time;

  CommentModel({
    required this.postId,
    required this.uid,
    required this.userName, // ✅ إضافة إلى المتغيرات المطلوبة
    required this.comment,
    required this.time,
    required this.commentId,
  });

  // CopyWith method
  CommentModel copyWith({
    String? postId,
    String? uid,
    String? userName, // ✅ تعديل copyWith لإضافة userName
    String? comment,
    Timestamp? time,
    String? commentId,
  }) {
    return CommentModel(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName, // ✅ تحديث النسخ الجديدة
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
      'userName': userName, // ✅ حفظ اسم المستخدم في قاعدة البيانات
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
      userName: json['userName'] ?? 'مستخدم مجهول', // ✅ استرداد الاسم
      comment: json['comment'],
      time: json['time'],
      commentId: json['commentId'],
    );
  }
}
