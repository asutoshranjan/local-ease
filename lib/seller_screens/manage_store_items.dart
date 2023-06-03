import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/seller_screens/add_item_screen.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/widgets/store_item_card.dart';

class ManageStoreItems extends StatefulWidget {
  const ManageStoreItems({Key? key}) : super(key: key);

  @override
  State<ManageStoreItems> createState() => _ManageStoreItemsState();
}

class _ManageStoreItemsState extends State<ManageStoreItems> {
  List storesItem = [
    "Apples",
    "Apricot",
    "Plum",
    "Watermelon",
    "Orange",
    "Pineapple",
    "Blueberry",
    "Papaya",
    "Hihfhhq ehf",
    "ijfej9efj",
    "iojfiw",
    "kowj"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Store Items"),
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: storesItem.length,
          itemBuilder: (BuildContext context, int index) {
            return StoreItemCard(name: storesItem[index]);
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.pink,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddItemsScreen(),
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.add,
          size: 32,
          color: AppColors.white,
        ),
      ),
    );
  }
}
