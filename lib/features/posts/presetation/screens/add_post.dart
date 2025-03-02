import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/shared/about_images.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/domain/repo/posts_repo.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostScreen extends StatefulWidget {
 final String userName;

  const AddPostScreen({required this.userName});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  String? _imageUrl = '';
  Future<void> _pickImage() async {
    final File? image = await ImageServices.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_postController.text.isEmpty && _selectedImage == null) {
      showToast(
          text: 'يرجى إدخال نص أو اختيار صورة!', state: ToastStates.WARNING);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedImage != null) {
        _imageUrl = await ImageServices.uploadImage(_selectedImage!);
      }

      final String postId =
          FirebaseFirestore.instance.collection('posts').doc().id;
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      PostModel newPost = PostModel(
        userName:widget.userName,
        postId: postId,
        uid: uid,
        post: _postController.text,
        image: _imageUrl,
        date: Timestamp.now(),
        likes: [],
      );

      await context.read<PostsCubit>().addPost(post: newPost);
      showToast(text: 'تم نشر البوست بنجاح!', state: ToastStates.SUCCESS);

      Navigator.pop(context); // إغلاق الشاشة بعد النشر
    } catch (e) {
      showToast(text: 'حدث خطأ أثناء نشر البوست!', state: ToastStates.ERROR);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('إضافة منشور', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب شيئًا...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            _selectedImage != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_selectedImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.black),
                  onPressed: _pickImage,
                ),
                Text('إضافة صورة', style: TextStyle(color: Colors.black)),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _uploadPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bottomNavigationBar,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('نشر',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
