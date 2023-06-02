import 'package:flutter/material.dart';
import 'package:local_ease/theme/colors.dart';

class StoreListingPage extends StatefulWidget {
  const StoreListingPage({Key? key}) : super(key: key);

  @override
  State<StoreListingPage> createState() => _StoreListingPageState();
}

class _StoreListingPageState extends State<StoreListingPage> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Your Store"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOpen ? AppColors.tabPink :AppColors.tabGrey,
                  foregroundColor: isOpen ? AppColors.white :AppColors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isOpen = true;
                  });
                },
                child: Text("Opened"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOpen ? AppColors.tabGrey :AppColors.tabPink,
                  foregroundColor: isOpen ? AppColors.grey :AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    isOpen = false;
                  });
                },
                child: Text("Closed"),
              ),
              SizedBox(width: 100,),
            ],
          ),
        ),
      ),
      body: isOpen
          ? Column(
              children: [
                Text("This is feature 1"),
                Text("Feature 2"),
              ],
            )
          : Column(
              children: [
                Text("Closed"),
              ],
            ),
    );
  }
}
