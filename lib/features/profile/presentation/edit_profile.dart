import 'dart:io';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/profile/data/model/user_data.dart';
import 'package:dr_fit/features/profile/presentation/profile_cubit.dart';
import 'package:dr_fit/features/storage/data/repo_imp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileData data;
  const EditProfileScreen({super.key, required this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data.name;
    ageController.text = widget.data.age;
    heightController.text = widget.data.height.toString();
    weightController.text = widget.data.weight.toString();
    phoneController.text = widget.data.phone;
    _imageUrl = widget.data.img;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _imageUrl = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في اختيار الصورة: $e')),
      );
    }
  }

  void _saveChanges() async {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        height == null ||
        weight == null ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء ملء جميع الحقول بشكل صحيح')),
      );
      return;
    }

    // Upload the image and get the URL (if a new image is selected)
    String? imageUrl = _imageUrl; // Use the existing image URL by default
    if (_image != null) {
      final storageRepo = UploadProfileImageStorageRepoImp();
      imageUrl = await storageRepo.uploadToStorage(
        name: widget.data.name, // Use a unique name for the file
        file: _image!,
      );
    }

    // Create the updated ProfileData object
    ProfileData updatedData = widget.data.copyWith(
      name: nameController.text,
      age: ageController.text,
      height: height,
      weight: weight,
      phone: phoneController.text,
      img: imageUrl ?? "", // Use the new or existing image URL
    );

    // Update the state in the ProfileCubit
    context.read<ProfileCubit>().updateProfile(data: updatedData);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'تعديل الملف الشخصي',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null
                          ? FileImage(_image!) // Use FileImage for local files
                          : (_imageUrl != null && _imageUrl!.isNotEmpty)
                              ? (_imageUrl!.startsWith('http')
                                  ? NetworkImage(
                                      _imageUrl!) // Use NetworkImage for URLs
                                  : FileImage(
                                      File(
                                        _imageUrl!,
                                      ),
                                    )) // Use FileImage for local paths
                              : const AssetImage(
                                  'assets/logo/logo.png',
                                ), // Default image
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اضغط لاختيار صورة',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('الاسم', nameController),
              _buildTextField('العمر', ageController,
                  keyboardType: TextInputType.number),
              _buildTextField('الطول (سم)', heightController,
                  keyboardType: TextInputType.number),
              _buildTextField('الوزن (كجم)', weightController,
                  keyboardType: TextInputType.number),
              _buildTextField('رقم الهاتف', phoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(buttonPrimaryColor),
                  ),
                  onPressed: _saveChanges,
                  child: const Text(
                    'حفظ التعديلات',
                    style: TextStyle(
                      color: kSecondryColor,
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        textDirection: TextDirection.rtl,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
