import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/theme/colors.dart';

class StoreItemCard extends StatefulWidget {
  final String name;
  const StoreItemCard({Key? key, required this.name}) : super(key: key);

  @override
  State<StoreItemCard> createState() => _StoreItemCardState();
}

class _StoreItemCardState extends State<StoreItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.name),
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.xmark_circle),),
              IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.delete),),
            ],
          ),
        ],
      ),
    );
  }
}

