import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';
import 'add_edit_item_screen.dart';
import '../widgets/reusable_widgets.dart'; // For AnimatedActionButton, AnimatedEntrance

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
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await DBService().getItems();
    setState(() => items = data);
  }

  Future<void> _deleteItem(int id) async {
    await DBService().deleteItem(id);
    _loadItems();
  }

  void _openEditScreen([Item? item]) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AddEditItemScreen(item: item),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: items.isEmpty
          ? const Center(child: Text('No items'))
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return AnimatedEntrance(
            index: i,
            child: ListTile(
              title: Text(it.title),
              subtitle: Text(it.description),
              onTap: () => _openEditScreen(it),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(it.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: AnimatedActionButton(
        onPressed: () => _openEditScreen(),
        child: const Icon(Icons.add),
        color: Colors.green,
      ),
    );
  }
}