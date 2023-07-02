import 'package:shopList/models/categories.dart';

class GroceryItem {
  const GroceryItem({
    required this.category,
    required this.id,
    required this.name,
    required this.quantity,
  });

  final String name;
  final int quantity;
  final String id;
  final Category category;
}
