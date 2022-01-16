import 'package:flutter/material.dart';
import '../components/grocery_tile.dart';
import '../models/models.dart';
import 'grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager manager;

  const GroceryListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1
    final groceryItems = manager.groceryItems;
// 2
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // 3
      child: ListView.separated(
        // 4
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          // 5
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            onDismissed: (direction) {
              manager.deleteItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} dismissed')));
            },
            child: InkWell(
              child: GroceryTile(
                key: Key(item.id),
                item: item,
                // 6
                onComplete: (change) {
                  // 7
                  if (change != null) {
                    manager.completeItem(index, change);
                  }
                },
              ),
              onTap: () {
                print('To to edit screen-----');
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return GroceryItemScreen(
                      originalItem: item,
                      onCreate: (p0) {},
                      onUpdate: (item) {
                        manager.updateItem(item, index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ));
              },
            ),
          );
        },
        // 8
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
