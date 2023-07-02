import 'package:flutter/material.dart';
import 'package:shopList/data/dummy_data.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Groceryies")),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: ((context, index) => ListTile(
                title: Text(groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: groceryItems[index].category.color,
                ),
                trailing: Text(groceryItems[index].quantity.toString()),
              ))),
    );
  }
}
