class UserData {
  double height;
  double weight;
  String name;
  String age;
  String phone;
  String img;

  UserData({
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
      'height': height,
      'weight': weight,
      'name': name,
      'age': age,
      'phone': phone,
      'img': img, // Adding img to the map
    };
  }

  // Convert a Map back to a UserData object
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      phone: map['phone'],
      img: map['img'], // Retrieving img from the map
    );
  }
}
