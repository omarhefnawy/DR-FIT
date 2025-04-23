import 'dart:convert';

class Exercise {
  String bodyPart;
  String equipment;
  String gifUrl;
  String id;
  String name;
  String target;
  List<String> secondaryMuscles;
  List<String> instructions;

  Exercise({
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.id,
    required this.name,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      bodyPart: json['bodyPart'],
      equipment: json['equipment'],
      gifUrl: json['gifUrl'],
      id: json['id'],
      name: json['name'],
      target: json['target'],
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      instructions: List<String>.from(json['instructions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'id': id,
      'name': name,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }

  // إضافة دالة لتحويل الموديل إلى Map (مطلوب لـ Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'bodyPart': bodyPart,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };
  }

  // دالة لتحويل Map من Firestore إلى الموديل
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      target: map['target'] ?? '',
      equipment: map['equipment'] ?? '',
      gifUrl: map['gifUrl'] ?? '',
      bodyPart: map['bodyPart'] ?? '',
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
    );
  }

  static List<Exercise> listFromJson(jsonString) {
    List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => Exercise.fromJson(item)).toList();
  }

  static String listToJson(List<Exercise> exercises) {
    return json.encode(exercises.map((exercise) => exercise.toJson()).toList());
  }
}
