class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final bool status;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    required this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      status:
          json['status'] == true ||
          json['status'] == 1 ||
          json['status'] == '1',
    );
  }
}
