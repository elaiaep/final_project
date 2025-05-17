import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';
import '../widgets/reusable_widgets.dart'; // ✅ Import your reusable widgets

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descController.text = widget.item!.description;
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newItem = Item(
      id: widget.item?.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
    );

    if (widget.item == null) {
      await DBService().addItem(newItem);
    } else {
      await DBService().updateItem(newItem);
    }

    await Future.delayed(const Duration(milliseconds: 300)); // slight delay
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Enter title' : null,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty ? 'Enter description' : null,
                  ),
                ),
                const SizedBox(height: 32),

                // ✅ Use AnimatedActionButton here
                _isSaving
                    ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
                    : AnimatedActionButton(
                  onPressed: _saveItem,
                  color: Colors.green,
                  child: Text(widget.item == null ? 'Add' : 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}