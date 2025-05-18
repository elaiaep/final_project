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
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DBService().getItems();
    setState(() => _items = items);
  }

  void _editItem(Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemScreen(item: item)),
    );
    _loadItems();
  }

  void _addItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
    );
    _loadItems();
  }

  void _deleteItem(int id) async {
    await DBService().deleteItem(id);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Items')),
      body: _items.isEmpty
          ? const Center(child: Text("No items yet"))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            onTap: () => _editItem(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(item.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
