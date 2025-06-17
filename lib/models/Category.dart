class Category {
  final String id;
  final String name;
  final String imagePath;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imagePath: 'assets/category/${json['id']}.jpg',
      description: json['description'],
    );
  }
}
