import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopList/data/cataegory.dart';
import 'package:shopList/models/categories.dart';
import 'package:shopList/models/groceryitem.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _selectedCategory = categories[Categories.vegetables]!;
  var _enteredQuantity = 1; //it used here for not rebuilt is called
  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          category: _selectedCategory,
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey, ///////
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length >= 50) {
                      return 'Must be between 1 to 50 character. ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ///onSve come  with .save is called
                    _enteredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        initialValue: _enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be Positive number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final categored in categories.entries)
                              DropdownMenuItem(
                                value: categored.value,
                                child: Row(children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: categored.value.color,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(categored.value.title)
                                ]),
                              )
                          ],
                          onChanged: (value) {
                            setState(() {});
                            _selectedCategory = value!;
                          }),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: Text("Reset")),
                    ElevatedButton(
                        onPressed: _saveItem, child: Text("Add item"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
