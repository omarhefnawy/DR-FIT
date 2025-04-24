class Recipe {
  final String name;
  final int id;
  final String image;
  final String cuisine;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int caloriesPerServing;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.name,
    required this.id,
    required this.image,
    required this.cuisine,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      id: json['id'],
      image: json['image'],
      cuisine: json['cuisine'],
      prepTimeMinutes: json['prepTimeMinutes'],
      cookTimeMinutes: json['cookTimeMinutes'],
      caloriesPerServing: json['caloriesPerServing'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'image': image,
      'cuisine': cuisine,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'caloriesPerServing': caloriesPerServing,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}
