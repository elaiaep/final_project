import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';
import 'add_edit_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final data = await DBService().getItems();
    setState(() {
      items = data;
    });
  }

  void deleteItem(int id) async {
    await DBService().deleteItem(id);
    fetchItems();
  }

  void navigateToEdit(Item? item) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AddEditItemScreen(item: item),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(animation),
            child: child,
          );
        },
      ),
    );
    fetchItems(); // Refresh after return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final i = items[index];
          return ListTile(
            title: Text(i.title),
            subtitle: Text(i.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteItem(i.id!),
            ),
            onTap: () => navigateToEdit(i),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToEdit(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}