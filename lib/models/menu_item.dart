class MenuItem {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.isAvailable = true,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    final rawId = map['id'];
    final rawPrice = map['price'];
    return MenuItem(
      id: rawId == null ? '' : rawId.toString(),
      name: (map['name'] ?? '').toString(),
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '') ?? 0,
      imageUrl: map['image_url']?.toString(),
      description: map['description']?.toString(),
      isAvailable: map['is_available'] == null
          ? true
          : map['is_available'] == true,
    );
  }
}
