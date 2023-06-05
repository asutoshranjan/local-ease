import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/seller_screens/choose_shop_from_map.dart';
import 'package:local_ease/seller_screens/manage_store_items.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/widgets/textfields.dart';

class StoreListingPage extends StatefulWidget {
  const StoreListingPage({Key? key}) : super(key: key);

  @override
  State<StoreListingPage> createState() => _StoreListingPageState();
}

class _StoreListingPageState extends State<StoreListingPage> {
  bool isOpen = true;
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();

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

  List outStock = [
    "Apricot",
    "Watermelon",
    "Pineapple",
  ];

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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        title: 'Store Name',
                        hintText: 'Hillside Fruits',
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 0.1,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseShopFromMap(),
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey),
                          ),
                          child: Center(child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 8),
                              Text("Location Data"),
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        title: 'About',
                        hintText: 'Get freshness of hillside fruits',
                        onChanged: (val) {},
                        maxLines: 3,
                        maxLength: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        title: 'Phone',
                        hintText: '+91 6370299855',
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        title: 'Email',
                        hintText: 'hillsidefruits@comp.in',
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Opens on',
                        timeLabelText: 'Time',
                        onChanged: (val) => print(val),
                        onSaved: (val) => print(val),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Closes on',
                        timeLabelText: 'Time',
                        onChanged: (val) {
                          print(DateTime.parse('var'));
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Store Items",
                        style: textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: <Widget>[
                          for (String item in storesItem)
                            Chip(
                              backgroundColor: AppColors.white,
                              side: const BorderSide(color: AppColors.grey),
                              avatar: outStock.contains(item)
                                  ? const CircleAvatar(
                                      backgroundColor: AppColors.orange,
                                      child: Text(
                                        'OUT',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ))
                                  : const CircleAvatar(
                                      backgroundColor: AppColors.green,
                                      child: Text(
                                        'IN',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                              label: Text(
                                item,
                                style: textTheme.displayLarge,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManageStoreItems(),
                              ));
                        },
                        child: Text("Manage Items"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Update Details"),
                      ),
                      const SizedBox(
                        height: 40,
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
