import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/db_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  const AddEditItemScreen({super.key, this.item});
  @override State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _f = GlobalKey<FormState>();
  late TextEditingController tC, dC;

  @override void initState(){
    super.initState();
    tC = TextEditingController(text: widget.item?.title);
    dC = TextEditingController(text: widget.item?.description);
  }

  Future<void> _save() async {
    if (!_f.currentState!.validate()) return;
    final it = Item(
        id: widget.item?.id,
        title: tC.text, description: dC.text
    );
    if (widget.item == null) {
      await DBService().addItem(it);
    } else {
      await DBService().updateItem(it);
    }
    Navigator.pop(context);
  }

  @override Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.item==null?'Add Item':'Edit Item')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key:_f,
          child: Column(children:[
            TextFormField(
              controller:tC,
              decoration: const InputDecoration(labelText:'Title'),
              validator:(v)=>v==null||v.isEmpty?'Required':null,
            ),
            TextFormField(
              controller:dC,
              decoration: const InputDecoration(labelText:'Description'),
              validator:(v)=>v==null||v.isEmpty?'Required':null,
            ),
            const SizedBox(height:20),
            ElevatedButton(onPressed:_save, child: const Text('Save')),
          ]),
        ),
      ),
    );
  }
}