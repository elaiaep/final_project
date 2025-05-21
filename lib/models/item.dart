class Item {
  final int? id;
  final String title;         // e.g. "Fender Stratocaster"
  final String description;   // e.g. "Classic electric guitar with vintage tone"
  final double price;         // e.g. 599.99
  final String imageUrl;      // e.g. "assets/images/stratocaster.png"
  final String category;      // e.g. "Electric Guitar"
  final String brand;         // e.g. "Fender"

  Item({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.brand,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
    'brand': brand,
  };

  factory Item.fromMap(Map<String, dynamic> m) => Item(
    id: m['id'],
    title: m['title'],
    description: m['description'],
    price: m['price'],
    imageUrl: m['imageUrl'],
    category: m['category'],
    brand: m['brand'],
  );
}
