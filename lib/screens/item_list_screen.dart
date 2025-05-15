import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';
import 'add_edit_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});
  @override State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<Item> items = [];
  @override void initState() {
    super.initState();
    _load();
  }
  Future<void> _load() async {
    items = await DBService().getItems();
    setState((){});
  }
  @override Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: items.isEmpty
          ? const Center(child: Text('No items'))
          : ListView.builder(
        itemCount: items.length,
        itemBuilder:(_,i){
          final it = items[i];
          return ListTile(
            title: Text(it.title),
            subtitle: Text(it.description),
            onTap: ()=> Navigator.push(c, MaterialPageRoute(
                builder: (_) => AddEditItemScreen(item: it)
            )).then((_)=>_load()),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color:Colors.red),
              onPressed: () async {
                await DBService().deleteItem(it.id!);
                _load();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.push(c, MaterialPageRoute(
            builder: (_) => const AddEditItemScreen()
        )).then((_)=>_load()),
        child: const Icon(Icons.add),
      ),
    );
  }
}