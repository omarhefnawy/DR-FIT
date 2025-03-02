import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/shared/about_images.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String value;

  const EditPostScreen({required this.postId, required this.value});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _postController;
  File? _selectedImage;
  bool _isLoading = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final File? image = await ImageServices.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _updatePost() async {
    if (_postController.text.isEmpty && _selectedImage == null) {
      showToast(
          text: 'يرجى إدخال نص أو اختيار صورة!', state: ToastStates.WARNING);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // تحميل الصورة إذا تم اختيار واحدة جديدة
      if (_selectedImage != null) {
        _imageUrl = await ImageServices.uploadImage(_selectedImage!);
      }

      // تحديث المنشور الحالي
      await context.read<PostsCubit>().updatePost(
            postId: widget.postId,
            newText: _postController.text,
            newImageUrl:
                _imageUrl ?? '', // الاحتفاظ بالصورة القديمة إذا لم يتم تغييرها
          );

      showToast(text: 'تم تحديث المنشور بنجاح!', state: ToastStates.SUCCESS);
      Navigator.pop(context);
    } catch (e) {
      showToast(text: 'حدث خطأ أثناء تحديث المنشور!', state: ToastStates.ERROR);
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
        title: Text('تعديل المنشور', style: TextStyle(color: Colors.black)),
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
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب شيئًا...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
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
              ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.black),
                  onPressed: _pickImage,
                ),
                Text('تغيير الصورة', style: TextStyle(color: Colors.black)),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bottomNavigationBar,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('تحديث',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
