import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopList/data/cataegory.dart';
import 'package:shopList/models/categories.dart';
import 'package:shopList/models/groceryitem.dart';
import 'dart:convert';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}
//yess

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _selectedCategory = categories[Categories.vegetables]!;
  var _enteredQuantity = 1; //it used here for not rebuilt is called
  var _isSending = false;
  void _saveItem() async {
    setState(() {
      _isSending = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https('flutterproject-34518-default-rtdb.firebaseio.com',
          'shoping-list.json');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'category': _selectedCategory.title,
            'name': _enteredName,
            'quantity': _enteredQuantity
          }));
      // print(response.body);
      // print(response.statusCode);
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return; //mounnted us for check the if the context is  not  the part the widget the it will return
      }
      Navigator.of(context).pop(GroceryItem(
          category: _selectedCategory,
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity));
      // .then((response) => null);
      // Navigator.of(context).pop(GroceryItem(
      //     category: _selectedCategory,
      //     id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: _enteredQuantity));
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
                        onPressed: _isSending
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: Text("Reset")),
                    ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : Text("Add item"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
