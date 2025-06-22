import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:dr_fit/core/shared/about_images.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
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
  bool _postUploaded = false;

  Future<void> _pickImage() async {
    final File? image = await ImageServices.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      await CacheHelper.setData(key: 'draftImage', value: _selectedImage!.path);
    }
  }

  Future<void> _uploadPost() async {
  final trimmedText = _postController.text.trim();
  
  // 1. التحقق من الإدخال بشكل أكثر دقة
  if (trimmedText.isEmpty && _selectedImage == null) {
    showToast(
      text: 'الرجاء إدخال نص أو صورة للمشاركة',
      state: ToastStates.WARNING,
    );
    return;
  }

  // 2. التحقق من المحتوى النصي
  try {
    if (trimmedText.isNotEmpty) {
      final isValid = await context.read<PostsCubit>().checkContent(trimmedText);
      if (!isValid) {
        showToast(
          text: 'المحتوى يحتوي على كلمات غير لائقة',
          state: ToastStates.ERROR,
        );
        return;
      }
    }
  } catch (e) {
    showToast(
      text: 'فشل التحقق من المحتوى، الرجاء المحاولة لاحقاً',
      state: ToastStates.ERROR,
    );
    return;
  }

  // 3. التحقق من حالة الـ widget قبل التحديثات
  if (!mounted) return;

  setState(() => _isLoading = true);

  try {
    String? imageUrl;
    
    // 4. تحميل الصورة مع معالجة الأخطاء التفصيلية
    if (_selectedImage != null) {
      try {
        imageUrl = await ImageServices.uploadImage(_selectedImage!)
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        showToast(
          text: 'تم تجاوز وقت تحميل الصورة',
          state: ToastStates.ERROR,
        );
        return;
      } catch (e) {
        showToast(
          text: 'فشل تحميل الصورة: ${e.toString()}',
          state: ToastStates.ERROR,
        );
        return;
      }
    }

    // 5. إنشاء نموذج المنشور
    final newPost = PostModel(
      postId: FirebaseFirestore.instance.collection('posts').doc().id,
      uid: FirebaseAuth.instance.currentUser!.uid,
      userName: widget.userName,
      post: trimmedText,
      image: imageUrl,
      date: Timestamp.now(),
      likes: [],
    );

    // 6. إضافة المنشور مع التحقق من السياق
    if (!mounted) return;
    await context.read<PostsCubit>().addPost(post: newPost);

    // 7. إدارة المسودة بعد النجاح
    _postUploaded = true;
    await _clearDraft();
    
    // 8. إغلاق الشاشة مع التحديث
    if (mounted) {
      Navigator.of(context).pop(true); // إرجاع نجاح العملية
    }

    showToast(text: 'تم النشر بنجاح!', state: ToastStates.SUCCESS);

  } catch (e) {
    showToast(
      text: 'خطأ غير متوقع: ${e.toString()}',
      state: ToastStates.ERROR,
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  
  
  @override
  void dispose() {
    if (!_postUploaded) {
      CacheHelper.setData(key: 'draftText', value: _postController.text);
    }
    super.dispose();
  }

  Future<void> _loadDraftData() async {
    String? draftText =
        await CacheHelper.getData(key: 'draftText', defaultValue: '');
    if (draftText != null && draftText.isNotEmpty) {
      _postController.text = draftText;
    }

    String? draftImage =
        await CacheHelper.getData(key: 'draftImage', defaultValue: '');
    if (draftImage != null && draftImage.isNotEmpty) {
      setState(() {
        _selectedImage = File(draftImage);
      });
    }
  }

  Future<void> _clearDraft() async {
    await CacheHelper.removeData(key: 'draftText');
    await CacheHelper.removeData(key: 'draftImage');
  }

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _selectedImage != null;

    return Scaffold(
      backgroundColor: PrimaryColor(context),
      appBar: AppBar(
        title: Text('إضافة منشور', style: TextStyle(color: textColor(context))),
        centerTitle: true,
        backgroundColor: PrimaryColor(context),
        elevation: 0,
        iconTheme: IconThemeData(color: textColor(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor(context),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  controller: _postController,
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20,color: textColor(context)),
                  decoration: InputDecoration(
                    hintText: 'اكتب شيئًا...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (hasImage)
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: EdgeInsets.all(10),
                            child: InteractiveViewer(
                              panEnabled: true,
                              minScale: 0.5,
                              maxScale: 3.0,
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildOriginalAspectRatioImage(),
                        ),
                      ),
                    ),
                    Text(
                      'انقر على الصورة للتكبير',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.image, color: Colors.white),
                    label: Text(
                      hasImage ? 'تغيير الصورة' : 'إضافة صورة',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: _pickImage,
                  ),
                  if (hasImage)
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text('حذف الصورة',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                        CacheHelper.removeData(key: 'draftImage');
                      },
                    ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bottomNavBarColor(context),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? CupertinoActivityIndicator()
                      : Text('نشر',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalAspectRatioImage() {
    return FutureBuilder<Size>(
      future: _getImageSize(_selectedImage!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final size = snapshot.data!;
          return AspectRatio(
            aspectRatio: size.width / size.height,
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<Size> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }
}
