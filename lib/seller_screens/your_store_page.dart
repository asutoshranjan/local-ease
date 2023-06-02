import 'package:flutter/material.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';

class StoreListingPage extends StatefulWidget {
  const StoreListingPage({Key? key}) : super(key: key);

  @override
  State<StoreListingPage> createState() => _StoreListingPageState();
}

class _StoreListingPageState extends State<StoreListingPage> {
  bool isOpen = true;
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();


  List storesItem = ["Apples", "Apricot", "Plum", "Watermelon", "Orange", "Pineapple", "Blueberry", "Papaya", "Hihfhhq ehf", "ijfej9efj", "iojfiw", "kowj"];



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
                    backgroundColor:
                        isOpen ? AppColors.tabPink : AppColors.tabGrey,
                    foregroundColor: isOpen ? AppColors.white : AppColors.grey,
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
                    backgroundColor:
                        isOpen ? AppColors.tabGrey : AppColors.tabPink,
                    foregroundColor: isOpen ? AppColors.grey : AppColors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isOpen = false;
                    });
                  },
                  child: Text("Closed"),
                ),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isOpen
                  ? [
                      // Center(
                      //   child: Text(
                      //     'Login',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .titleLarge
                      //         ?.copyWith(color: AppColors.pink, fontSize: 35),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          controller: storeNameController,
                          decoration: InputDecoration(
                            labelText: 'Store Name',
                            hintText: 'Hillside Fruits',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          controller: storeLocationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: '47 W 13th St, NYC',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      Text(
                        "Store Items",
                        style: textTheme.titleMedium,
                      ),

                      Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: <Widget>[
                          for(String item in storesItem)
                            Chip(
                              avatar: CircleAvatar(
                                  backgroundColor: Colors.blue.shade900,
                                  child: const Text('ML')),
                              label: Text(item, style: textTheme.displayLarge,),
                            ),
                        ],
                      ),

                ElevatedButton(onPressed: (){}, child: Text("Manage Items")),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){}, child: Text("Update")),

                      // SizedBox(
                      //   width: 0.5 * screenWidth,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       //we don't want to come back to the login screen
                      //     },
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         vertical: 5,
                      //       ),
                      //       child: Text(
                      //         'Login',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .titleSmall
                      //             ?.copyWith(
                      //                 color: AppColors.white, fontSize: 24),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(
                        height: 30,
                      ),
                    ]
                  : [
                      Text("Closed Page"),
                    ],
            ),
          ),
        ));
  }
}
