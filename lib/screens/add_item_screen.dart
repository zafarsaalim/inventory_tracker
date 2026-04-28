import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';

class AddItemScreen extends StatefulWidget {
  final Item? item;
  AddItemScreen({this.item});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.item != null ? widget.item!.name : '');
    _quantityController =
        TextEditingController(text: widget.item != null ? widget.item!.quantity.toString() : '');
  }

  void saveItem() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final quantity = int.parse(_quantityController.text);

      if (widget.item == null) {
        await DatabaseHelper().insertItem(Item(name: name, quantity: quantity));
      } else {
        await DatabaseHelper().updateItem(
            Item(id: widget.item!.id, name: name, quantity: quantity));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? "Add Item" : "Edit Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Item Name"),
                validator: (value) => value == null || value.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter quantity" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveItem,
                child: Text("Save"),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
