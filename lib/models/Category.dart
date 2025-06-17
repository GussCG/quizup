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
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: 'assets/category/${json['id']}.jpg',
      description: json['description'] as String? ?? 'No description available',
    );
  }

  factory Category.empty() {
    return Category(
      id: '0',
      name: 'Categoría desconocida',
      imagePath: '',
      description: 'No description available',
    );
  }
}
