class Guitar {
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String type; // acoustic, electric, classical, etc.
  final String description;
  final String? modelUrl; // URL to the 3D model

  Guitar({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.description,
    this.modelUrl,
  });
}

enum SortOption {
  nameAsc,
  nameDesc,
  priceHighToLow,
  priceLowToHigh,
  brand
}

// Sample guitar data
final List<Guitar> sampleGuitars = [
  Guitar(
    name: 'Stratocaster Professional II',
    brand: 'Fender',
    price: 1499.99,
    imageUrl: 'assets/images/start.jpg',
    type: 'Electric',
    description: 'Professional grade electric guitar with premium pickups and maple neck',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  Guitar(
    name: 'Les Paul Standard',
    brand: 'Gibson',
    price: 2699.99,
    imageUrl: 'assets/images/lespaul.jpg',
    type: 'Electric',
    description: 'Iconic electric guitar with dual humbucker pickups and mahogany body',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
  ),
  Guitar(
    name: 'GS Mini Mahogany',
    brand: 'Taylor',
    price: 699.99,
    imageUrl: 'assets/images/gsmini.png',
    type: 'Acoustic',
    description: 'Compact acoustic guitar with rich, full sound and solid mahogany top',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  Guitar(
    name: 'Classical CG162',
    brand: 'Yamaha',
    price: 499.99,
    imageUrl: 'assets/images/cg162c.jpg',
    type: 'Classical',
    description: 'Traditional classical guitar with nylon strings and spruce top',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
  ),
  Guitar(
    name: 'Telecaster Custom',
    brand: 'Fender',
    price: 1299.99,
    imageUrl: 'assets/images/custom.jpg',
    type: 'Electric',
    description: 'Versatile electric guitar with classic tone and modern playability',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Horse.glb',
  ),
  Guitar(
    name: 'SG Standard',
    brand: 'Gibson',
    price: 1899.99,
    imageUrl: 'assets/images/standart.jpg',
    type: 'Electric',
    description: 'Legendary electric guitar with aggressive tone and distinctive design',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  Guitar(
    name: 'Concert Series AC-150',
    brand: 'Martin',
    price: 1199.99,
    imageUrl: 'assets/images/concert.jpg',
    type: 'Acoustic',
    description: 'Professional acoustic guitar with solid spruce top and rosewood back',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
  ),
  Guitar(
    name: 'RG550 Genesis',
    brand: 'Ibanez',
    price: 999.99,
    imageUrl: 'assets/images/genesis.jpg',
    type: 'Electric',
    description: 'High-performance electric guitar for modern players and shredders',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Horse.glb',
  ),
  Guitar(
    name: 'Hummingbird',
    brand: 'Gibson',
    price: 3499.99,
    imageUrl: 'assets/images/hummingbird.jpg',
    type: 'Acoustic',
    description: 'Iconic acoustic guitar with rich tone and beautiful craftsmanship',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  Guitar(
    name: 'Classical GC82',
    brand: 'Cordoba',
    price: 849.99,
    imageUrl: 'assets/images/classical2.png',
    type: 'Classical',
    description: 'Professional classical guitar with solid cedar top and Indian rosewood',
    modelUrl: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
  ),
];

// Get unique guitar types
final List<String> guitarTypes = sampleGuitars
    .map((guitar) => guitar.type)
    .toSet()
    .toList();

// Get unique brands
final List<String> guitarBrands = sampleGuitars
    .map((guitar) => guitar.brand)
    .toSet()
    .toList();

// Price ranges for filtering
final List<Map<String, dynamic>> priceRanges = [
  {'min': 0, 'max': 500, 'label': 'Under \$500'},
  {'min': 500, 'max': 1000, 'label': '\$500 - \$1000'},
  {'min': 1000, 'max': 2000, 'label': '\$1000 - \$2000'},
  {'min': 2000, 'max': double.infinity, 'label': 'Over \$2000'},
]; 