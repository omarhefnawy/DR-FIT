class ProfileData {
  final String uid;
  final double height;
  final double weight;
  final String name;
  final String age;
  final String phone;
  final String img;

  ProfileData({
    required this.uid,
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    required this.phone,
    required this.img,
  });

  // Convert the object to a Map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'height': height,
      'weight': weight,
      'name': name,
      'age': age,
      'phone': phone,
      'img': img,
    };
  }

  // Convert a Map back to a ProfileData object
  factory ProfileData.fromMap(String uid, Map<String, dynamic> map) {
    return ProfileData(
      uid: uid,
      name: map['name'] ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      height: (map['height'] as num?)?.toDouble() ?? 0.0,
      age: map['age'] ?? '',
      phone: map['phone'] ?? '',
      img: map['img'] ?? '',
    );
  }

  // Create a copy of the current object with optional new values
  ProfileData copyWith({
    String? uid,
    double? height,
    double? weight,
    String? name,
    String? age,
    String? phone,
    String? img,
  }) {
    return ProfileData(
      uid: uid ?? this.uid,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      img: img ?? this.img,
    );
  }
}
