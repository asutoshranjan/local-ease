import 'package:flutter/material.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/widgets/itemstag.dart';

class FullShopViewPage extends StatefulWidget {
  final Map<String, dynamic> current_obj;
  const FullShopViewPage({Key? key, required this.current_obj})
      : super(key: key);

  @override
  State<FullShopViewPage> createState() => _FullShopViewPageState();
}

class _FullShopViewPageState extends State<FullShopViewPage> {
  @override
  Widget build(BuildContext context) {
    List outStock = widget.current_obj['outstock'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.current_obj['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                widget.current_obj['photo'] ??
                    'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg',
                fit: BoxFit.cover,
              )),
              SizedBox(height: 15,),
              Text("About", style: textTheme.titleMedium,),
              Text(
                widget.current_obj['about'],
                style: textTheme.displaySmall,
              ),
              SizedBox(height: 15,),
              Text("Items", style: textTheme.titleMedium,),
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 2.0, // gap between lines
                children: <Widget>[
                  for (String item in widget.current_obj['items'])
                    MyTag(flag: outStock.contains(item), name: item)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
