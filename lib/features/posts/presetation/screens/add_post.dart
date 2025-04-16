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
  String? _imageUrl;
  bool _postUploaded = false;

  // قائمة الكلمات المحظورة
  final List<String> _badWords = [
    'حقير',
    'قذر',
    'غبي',
    'أحمق',
    'مجنون',
    'نذل',
    'غبي',
    'خنزير',
    'حمار',
    'مجنونة',
    'خسيس',
    'خاين',
    'كريه',
    'مغفل',
    'بطيء',
    'تافه',
    'خاسر',
    'سافل',
    'مريض نفسي',
    'عبيط',
    'معتوه',
    'وسخ',
    'مجرم',
    'شاذ',
    'فاشل',
    'حيوان',
    'عديم الفائدة',
    'مقرف',
    'محتال',
    'ضعيف الشخصية',
    'مريض عقلي',
    'دنيء',
    'غشاش',
    'وطيء',
    'خائنة',
    'متخلف عقلياً',
  ];

  bool _containsBadWords(String text) {
    final normalizedText = _normalizeText(text);
    return _badWords.any((word) {
      final normalizedWord = _normalizeText(word);
      return normalizedText.contains(normalizedWord);
    });
  }

  String _normalizeText(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .toLowerCase();
  }

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
    final bool noText = trimmedText.isEmpty;
    final bool noImage = _selectedImage == null;

    if (noText && noImage) {
      showToast(
        text: 'يرجى إدخال نص أو اختيار صورة!',
        state: ToastStates.WARNING,
      );
      return;
    }

    if (trimmedText.isNotEmpty && _containsBadWords(trimmedText)) {
      showToast(
        text: 'يحتوي النص على كلمات غير لائقة! يرجى مراجعة المحتوى.',
        state: ToastStates.ERROR,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? finalImageUrl;
      if (_selectedImage != null) {
        finalImageUrl = await ImageServices.uploadImage(_selectedImage!);
      }

      final String postId =
          FirebaseFirestore.instance.collection('posts').doc().id;
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      PostModel newPost = PostModel(
        userName: widget.userName,
        postId: postId,
        uid: uid,
        post: trimmedText,
        image: finalImageUrl,
        date: Timestamp.now(),
        likes: [],
      );

      await context.read<PostsCubit>().addPost(post: newPost);
      showToast(text: 'تم نشر البوست بنجاح!', state: ToastStates.SUCCESS);

      // مسح المسودة بعد النشر بنجاح
      _postUploaded = true;
      await _clearDraft();
      Navigator.pop(context);
    } catch (e) {
      showToast(text: 'حدث خطأ أثناء نشر البوست!', state: ToastStates.ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDraftData();
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
  Widget build(BuildContext context) {
    final hasImage = _selectedImage != null;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('إضافة منشور', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  style: TextStyle(fontSize: 20),
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
                            ),
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
                    backgroundColor: bottomNavigationBar,
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

  @override
  @override
  void dispose() {
    super.dispose();
    if (!_postUploaded) {
      CacheHelper.setData(key: 'draftText', value: _postController.text);
    }
  }
}
