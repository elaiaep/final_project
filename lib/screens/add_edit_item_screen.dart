import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';
import '../widgets/reusable_widgets.dart';

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
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descController.text = widget.item!.description;
      _priceController.text = widget.item!.price.toString();
      _imageUrlController.text = widget.item!.imageUrl;
      _categoryController.text = widget.item!.category;
      _brandController.text = widget.item!.brand;
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newItem = Item(
      id: widget.item?.id,
      title: _titleController.text,
      description: _descController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      category: _categoryController.text,
      brand: _brandController.text,
    );

    try {
      if (widget.item == null) {
        await DBService().addItem(newItem);
      } else {
        await DBService().updateItem(newItem);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving item')),
      );
      setState(() => _isSaving = false); // reset in case of error
    }
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
            child: ListView(
              children: [
                _buildField(_titleController, 'Title'),
                _buildField(_descController, 'Description'),
                _buildField(_priceController, 'Price', isNumber: true),
                _buildField(_imageUrlController, 'Image URL'),
                _buildField(_categoryController, 'Category'),
                _buildField(_brandController, 'Brand'),
                const SizedBox(height: 24),
                _isSaving
                    ? const Center(
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

  Widget _buildField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        child: TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(labelText: label),
          validator: (v) =>
          v == null || v.isEmpty ? 'Enter $label'.toLowerCase() : null,
        ),
      ),
    );
  }
}