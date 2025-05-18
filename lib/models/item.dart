class Item {
  final int? id;
  final String title;
  final String description;
  Item({this.id, required this.title, required this.description});
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
  };
  factory Item.fromMap(Map<String, dynamic> m) => Item(
      id: m['id'], title: m['title'], description: m['description']
  );
}

