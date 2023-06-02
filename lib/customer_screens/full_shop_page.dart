import 'package:flutter/material.dart';
import 'package:local_ease/theme/app-theme.dart';

class FullShopViewPage extends StatefulWidget {
  final String name;
  final String about;
  const FullShopViewPage({Key? key, required this.name, required this.about}) : super(key: key);

  @override
  State<FullShopViewPage> createState() => _FullShopViewPageState();
}

class _FullShopViewPageState extends State<FullShopViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Text(
        widget.about,
        style: textTheme.displaySmall,
      ),
    );
  }
}
