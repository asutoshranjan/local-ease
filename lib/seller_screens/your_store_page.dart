import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/helpers/dateTimeHelper.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/seller_screens/manage_store_items.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/widgets/itemstag.dart';
import 'package:local_ease/widgets/textfields.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../helpers/dialogs.dart';

class StoreListingPage extends StatefulWidget {
  const StoreListingPage({Key? key}) : super(key: key);

  @override
  State<StoreListingPage> createState() => _StoreListingPageState();
}

class _StoreListingPageState extends State<StoreListingPage> {
  bool? isOpen;
  TextEditingController storeNameController = TextEditingController();
  String currentAddress = "Pick Your Location";
  String lat = "";
  String long = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController addItemController = TextEditingController();
  String opens = "";
  String closes = "";

  List storesItem = [];

  List outStock = [];

  ShopModel? myCurrentShop;

  @override
  void initState() {
    super.initState();
    getShop();
  }

  getShop() async {
    myCurrentShop = await APIs.instance.getStore();

    if (myCurrentShop == null) {
      log("null found success");
      storeNameController = TextEditingController();
    } else {
      log(myCurrentShop!.name.toString());
      isOpen = myCurrentShop!.isOpen!;
      storeNameController = TextEditingController(text: myCurrentShop!.name);
      currentAddress = myCurrentShop!.address ?? "";
      lat = myCurrentShop!.lat ?? "";
      long = myCurrentShop!.long ?? "";
      emailController = TextEditingController(text: myCurrentShop!.email);
      phoneController = TextEditingController(text: myCurrentShop!.phone);
      photoUrlController = TextEditingController(text: myCurrentShop!.photo);
      aboutController = TextEditingController(text: myCurrentShop!.about);
      storesItem = myCurrentShop!.items ?? [];
      outStock = myCurrentShop!.outStock ?? [];
      opens = myCurrentShop!.opens ?? "";
      closes = myCurrentShop!.closes ?? "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: isOpen != null ? AppBar(
          title: Text("Manage Your Store"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child:  Row(
              children: [
                SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isOpen! ? AppColors.tabPink : AppColors.tabGrey,
                    foregroundColor: isOpen! ? AppColors.white : AppColors.grey,
                  ),
                  onPressed: isOpen! ? () {} : () {
                    bool clk = false;
                    Dialogs.showOpenCloseDialog(
                        context: context,
                        title: "Opening Store Now!",
                        description:
                        "Make sure you have set the store time and details correctly as this will send your subscribers a notification",
                        onBtnClk: () async{
                          isOpen = true;
                          myCurrentShop!.isOpen = isOpen;
                          await APIs.instance
                              .updateShopInfo(myCurrentShop!).then((value) {
                            Navigator.pop(context);
                          });
                          clk = true;
                          setState(() {});
                        },
                        icon: Icons.check);
                    if (clk) {
                      setState(() {
                        isOpen = true;
                      });
                    }

                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("Opened"),
                  ),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isOpen! ? AppColors.tabGrey : AppColors.tabPink,
                    foregroundColor: isOpen! ? AppColors.grey : AppColors.white,
                  ),
                  onPressed: isOpen! ? () {
                    bool clk = false;
                    Dialogs.showOpenCloseDialog(
                        context: context,
                        title: "Closing Store for today?",
                        description:
                        "Confirm if you want to close store now this will also send your subscribers a notification",
                        onBtnClk: () async{
                          isOpen = false;
                          myCurrentShop!.isOpen = isOpen;
                          await APIs.instance
                              .updateShopInfo(myCurrentShop!).then((value) {
                            Navigator.pop(context);
                          });
                          clk = true;
                          setState(() {});
                        },
                        icon: Icons.info_outline);
                    if (clk) {
                      setState(() {
                        isOpen = false;
                      });
                    }
                  }: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("Closed"),
                  ),
                ),
              ],
            ),
          ),
        ) : AppBar(
          title: Text("Open your store now"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isOpen == null
                    ? [
                        const SizedBox(
                          height: 20,
                        ),

                  Text(
                    'Location',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ChooseShopFromMap(),
                      //     ));

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              width: screenWidth,
                              height: screenWidth * 2,
                              child: OpenStreetMapSearchAndPick(
                                  center: LatLong(19.357640790268235,
                                      84.97573036558032),
                                  buttonTextColor: AppColors.white,
                                  buttonColor: AppColors.pink,
                                  zoomInIcon: CupertinoIcons.zoom_in,
                                  zoomOutIcon: CupertinoIcons.zoom_out,
                                  locationPinIconColor: AppColors.pink,
                                  buttonText: 'Set This Location',
                                  onPicked: (pickedData) {
                                    print(pickedData.latLong.latitude);
                                    print(pickedData.latLong.longitude);
                                    print(pickedData.address);

                                    lat = pickedData.latLong.latitude
                                        .toString();
                                    long = pickedData.latLong.longitude
                                        .toString();
                                    currentAddress = pickedData.address;
                                    setState(() {});
                                    Navigator.pop(context);
                                  }),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Center(
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 280,
                                child: Text(
                                  currentAddress,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                        const SizedBox(
                          height: 20,
                        ),
                  TextFieldInput(
                    controller: storeNameController,
                    title: 'Store Name',
                    hintText: 'Enter Store Name',
                    onChanged: (val) {},
                  ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: aboutController,
                          title: 'About',
                          hintText: 'About your store',
                          onChanged: (val) {},
                          maxLines: 3,
                          maxLength: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: photoUrlController,
                          title: 'Photo Link',
                          hintText: 'Paste photo url',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: phoneController,
                          title: 'Phone',
                          hintText: 'Phone number',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: emailController,
                          title: 'Email',
                          hintText: 'Your shop mail',
                          onChanged: (val) {},
                        ),
                        opens != ""
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Last Updated',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                          letterSpacing: 0.1,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text("Opens: ${opens}", style: textTheme.bodyMedium!.copyWith(color: Colors.deepPurple[700]),),
                                  Text("Closes: ${closes}", style: textTheme.bodyMedium!.copyWith(color: AppColors.orange),),
                                ],
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Update Timing',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).hintColor,
                                    letterSpacing: 0.1,
                                  ),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Opens on',
                          timeLabelText: 'Time',
                          onChanged: (val) {
                            opens = val;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Closes on',
                          timeLabelText: 'Time',
                          onChanged: (val) {
                            closes = val;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Store Items",
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldInput(
                          controller: addItemController,
                          title: 'Item Name',
                          hintText: 'Enter name of item',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            ElevatedButton(
                                child: Text('Add'),
                                onPressed: () {
                                  log("Adding item ${addItemController.text} and ${storesItem.length}");
                                  storesItem.add(addItemController.text);
                                  setState(() {});
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 320,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              for (var str in storesItem)
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(str),
                                      ),
                                      Row(
                                        children: [
                                          outStock.contains(str)
                                              ? IconButton(
                                                  onPressed: () {
                                                    outStock.remove(str);
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.xmark_circle,
                                                    color: AppColors.orange,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    outStock.add(str);
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .check_mark_circled,
                                                    color: AppColors.green,
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              storesItem.remove(str);
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List arr = currentAddress.split(", ");
                            print(arr[arr.length - 1]);
                            print(arr[arr.length - 2]);
                            print(arr[arr.length - 3]);
                            setState((){
                              isOpen = true;
                            });

                            if (myCurrentShop != null) {
                              myCurrentShop!.name = storeNameController.text;
                              myCurrentShop!.lat = lat;
                              myCurrentShop!.long = long;
                              myCurrentShop!.country = arr[arr.length - 1];
                              myCurrentShop!.pincode = arr[arr.length - 2];
                              myCurrentShop!.district = arr[arr.length - 3];
                              myCurrentShop!.photo = photoUrlController.text;
                              myCurrentShop!.address = currentAddress;
                              myCurrentShop!.email = emailController.text;
                              myCurrentShop!.phone = phoneController.text;
                              myCurrentShop!.items = storesItem;
                              myCurrentShop!.outStock = outStock;
                              myCurrentShop!.about = aboutController.text;
                              myCurrentShop!.opens = opens;
                              myCurrentShop!.closes = closes;
                              myCurrentShop!.isOpen = isOpen;
                              await APIs.instance
                                  .updateShopInfo(myCurrentShop!);
                            } else {
                              ShopModel newShop = ShopModel(
                                name: storeNameController.text,
                                lat: lat,
                                long: long,
                                country: arr[arr.length - 1],
                                pincode: arr[arr.length - 2],
                                district: arr[arr.length - 3],
                                photo: photoUrlController.text,
                                address: currentAddress,
                                email: emailController.text,
                                phone: phoneController.text,
                                items: storesItem,
                                outStock: outStock,
                                about: aboutController.text,
                                opens: opens,
                                closes: closes,
                                isOpen: isOpen,
                              );
                              Dialogs.showLoaderDialog(context, "Going Live");
                              await APIs.instance
                                  .createShop(currentShop: newShop).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text("Launch Store"),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ]
                    : isOpen!
                    ? [
                        const SizedBox(
                          height: 20,
                        ),

                  Text(
                    'Location',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ChooseShopFromMap(),
                      //     ));

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              width: screenWidth,
                              height: screenWidth * 2,
                              child: OpenStreetMapSearchAndPick(
                                  center: LatLong(19.357640790268235,
                                      84.97573036558032),
                                  buttonTextColor: AppColors.white,
                                  buttonColor: AppColors.pink,
                                  zoomInIcon: CupertinoIcons.zoom_in,
                                  zoomOutIcon: CupertinoIcons.zoom_out,
                                  locationPinIconColor: AppColors.pink,
                                  buttonText: 'Set This Location',
                                  onPicked: (pickedData) {
                                    print(pickedData.latLong.latitude);
                                    print(pickedData.latLong.longitude);
                                    print(pickedData.address);

                                    lat = pickedData.latLong.latitude
                                        .toString();
                                    long = pickedData.latLong.longitude
                                        .toString();
                                    currentAddress = pickedData.address;
                                    setState(() {});
                                    Navigator.pop(context);
                                  }),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Center(
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 280,
                                child: Text(
                                  currentAddress,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                        const SizedBox(
                          height: 20,
                        ),
                  TextFieldInput(
                    controller: storeNameController,
                    title: 'Store Name',
                    hintText: 'Enter Store Name',
                    onChanged: (val) {},
                  ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: aboutController,
                          title: 'About',
                          hintText: 'About your store',
                          onChanged: (val) {},
                          maxLines: 3,
                          maxLength: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: photoUrlController,
                          title: 'Photo Link',
                          hintText: 'Paste photo url',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: phoneController,
                          title: 'Phone',
                          hintText: 'Phone number',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldInput(
                          controller: emailController,
                          title: 'Email',
                          hintText: 'Your shop mail',
                          onChanged: (val) {},
                        ),
                        opens != ""
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Last Updated',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: Theme.of(context).hintColor,
                                letterSpacing: 0.1,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text("Opens: ${opens}", style: textTheme.bodyMedium!.copyWith(color: Colors.deepPurple[700]),),
                            Text("Closes: ${closes}", style: textTheme.bodyMedium!.copyWith(color: AppColors.orange),),
                          ],
                        )
                            : SizedBox(),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Update Timing',
                          style:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).hintColor,
                            letterSpacing: 0.1,
                          ),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Opens on',
                          timeLabelText: 'Time',
                          onChanged: (val) {
                            opens = val;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Closes on',
                          timeLabelText: 'Time',
                          onChanged: (val) {
                            closes = val;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Store Items",
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFieldInput(
                          controller: addItemController,
                          title: 'Item Name',
                          hintText: 'Enter name of item',
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            ElevatedButton(
                                child: Text('Add'),
                                onPressed: () {
                                  log("Adding item ${addItemController.text} and ${storesItem.length}");
                                  storesItem.add(addItemController.text);
                                  setState(() {});
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 320,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              for (var str in storesItem)
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10),
                                        child: Text(str),
                                      ),
                                      Row(
                                        children: [
                                          outStock.contains(str)
                                              ? IconButton(
                                            onPressed: () {
                                              outStock.remove(str);
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              CupertinoIcons.xmark_circle,
                                              color: AppColors.orange,
                                            ),
                                          )
                                              : IconButton(
                                            onPressed: () {
                                              outStock.add(str);
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .check_mark_circled,
                                              color: AppColors.green,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              storesItem.remove(str);
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete,
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List arr = currentAddress.split(", ");
                            print(arr[arr.length - 1]);
                            print(arr[arr.length - 2]);
                            print(arr[arr.length - 3]);
                            if (myCurrentShop != null) {
                              myCurrentShop!.name = storeNameController.text;
                              myCurrentShop!.lat = lat;
                              myCurrentShop!.long = long;
                              myCurrentShop!.country = arr[arr.length - 1];
                              myCurrentShop!.pincode = arr[arr.length - 2];
                              myCurrentShop!.district = arr[arr.length - 3];
                              myCurrentShop!.photo = photoUrlController.text;
                              myCurrentShop!.address = currentAddress;
                              myCurrentShop!.email = emailController.text;
                              myCurrentShop!.phone = phoneController.text;
                              myCurrentShop!.items = storesItem;
                              myCurrentShop!.outStock = outStock;
                              myCurrentShop!.about = aboutController.text;
                              myCurrentShop!.opens = opens;
                              myCurrentShop!.closes = closes;
                              myCurrentShop!.isOpen = isOpen;
                              Dialogs.showLoaderDialog(context, "Saving");
                              await APIs.instance
                                  .updateShopInfo(myCurrentShop!).then((value) {
                                    Navigator.pop(context);
                              });
                            } else {
                              ShopModel newShop = ShopModel(
                                name: storeNameController.text,
                                lat: lat,
                                long: long,
                                country: arr[arr.length - 1],
                                pincode: arr[arr.length - 2],
                                district: arr[arr.length - 3],
                                photo: photoUrlController.text,
                                address: currentAddress,
                                email: emailController.text,
                                phone: phoneController.text,
                                items: storesItem,
                                outStock: outStock,
                                about: aboutController.text,
                                opens: opens,
                                closes: closes,
                                isOpen: isOpen,
                              );
                              await APIs.instance
                                  .createShop(currentShop: newShop);
                            }
                          },
                          child: Text("Update Details"),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ]
                    : [
                          Text("Closed"),
                          const SizedBox(
                            height: 20,
                          ),

                  Text(
                    'Location',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ChooseShopFromMap(),
                      //     ));

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              width: screenWidth,
                              height: screenWidth * 2,
                              child: OpenStreetMapSearchAndPick(
                                  center: LatLong(19.357640790268235,
                                      84.97573036558032),
                                  buttonTextColor: AppColors.white,
                                  buttonColor: AppColors.pink,
                                  zoomInIcon: CupertinoIcons.zoom_in,
                                  zoomOutIcon: CupertinoIcons.zoom_out,
                                  locationPinIconColor: AppColors.pink,
                                  buttonText: 'Set This Location',
                                  onPicked: (pickedData) {
                                    print(pickedData.latLong.latitude);
                                    print(pickedData.latLong.longitude);
                                    print(pickedData.address);

                                    lat = pickedData.latLong.latitude
                                        .toString();
                                    long = pickedData.latLong.longitude
                                        .toString();
                                    currentAddress = pickedData.address;
                                    setState(() {});
                                    Navigator.pop(context);
                                  }),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Center(
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 280,
                                child: Text(
                                  currentAddress,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                          const SizedBox(
                            height: 20,
                          ),
                  TextFieldInput(
                    controller: storeNameController,
                    title: 'Store Name',
                    hintText: 'Enter Store Name',
                    onChanged: (val) {},
                  ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldInput(
                            controller: aboutController,
                            title: 'About',
                            hintText: 'About your store',
                            onChanged: (val) {},
                            maxLines: 3,
                            maxLength: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldInput(
                            controller: photoUrlController,
                            title: 'Photo Link',
                            hintText: 'Paste photo url',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldInput(
                            controller: phoneController,
                            title: 'Phone',
                            hintText: 'Phone number',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldInput(
                            controller: emailController,
                            title: 'Email',
                            hintText: 'Your shop mail',
                            onChanged: (val) {},
                          ),
                          opens != ""
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Last Updated',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  color: Theme.of(context).hintColor,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text("Opens: ${opens}", style: textTheme.bodyMedium!.copyWith(color: Colors.deepPurple[700]),),
                              Text("Closes: ${closes}", style: textTheme.bodyMedium!.copyWith(color: AppColors.orange),),
                            ],
                          )
                              : SizedBox(),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Update Timing',
                            style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 0.1,
                            ),
                          ),
                          DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Opens on',
                            timeLabelText: 'Time',
                            onChanged: (val) {
                              opens = val;
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Closes on',
                            timeLabelText: 'Time',
                            onChanged: (val) {
                              closes = val;
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Store Items",
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFieldInput(
                            controller: addItemController,
                            title: 'Item Name',
                            hintText: 'Enter name of item',
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              ElevatedButton(
                                  child: Text('Add'),
                                  onPressed: () {
                                    log("Adding item ${addItemController.text} and ${storesItem.length}");
                                    storesItem.add(addItemController.text);
                                    setState(() {});
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 320,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                for (var str in storesItem)
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10),
                                          child: Text(str),
                                        ),
                                        Row(
                                          children: [
                                            outStock.contains(str)
                                                ? IconButton(
                                              onPressed: () {
                                                outStock.remove(str);
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                CupertinoIcons.xmark_circle,
                                                color: AppColors.orange,
                                              ),
                                            )
                                                : IconButton(
                                              onPressed: () {
                                                outStock.add(str);
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                CupertinoIcons
                                                    .check_mark_circled,
                                                color: AppColors.green,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                storesItem.remove(str);
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                CupertinoIcons.delete,
                                                color: AppColors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              List arr = currentAddress.split(", ");
                              print(arr[arr.length - 1]);
                              print(arr[arr.length - 2]);
                              print(arr[arr.length - 3]);

                              if (myCurrentShop != null) {
                                myCurrentShop!.name = storeNameController.text;
                                myCurrentShop!.lat = lat;
                                myCurrentShop!.long = long;
                                myCurrentShop!.country = arr[arr.length - 1];
                                myCurrentShop!.pincode = arr[arr.length - 2];
                                myCurrentShop!.district = arr[arr.length - 3];
                                myCurrentShop!.photo = photoUrlController.text;
                                myCurrentShop!.address = currentAddress;
                                myCurrentShop!.email = emailController.text;
                                myCurrentShop!.phone = phoneController.text;
                                myCurrentShop!.items = storesItem;
                                myCurrentShop!.outStock = outStock;
                                myCurrentShop!.about = aboutController.text;
                                myCurrentShop!.opens = opens;
                                myCurrentShop!.closes = closes;
                                myCurrentShop!.isOpen = isOpen;
                                Dialogs.showLoaderDialog(context, "Saving");
                                await APIs.instance
                                    .updateShopInfo(myCurrentShop!).then((value) {
                                  Navigator.pop(context);
                                });
                              } else {
                                ShopModel newShop = ShopModel(
                                  name: storeNameController.text,
                                  lat: lat,
                                  long: long,
                                  country: arr[arr.length - 1],
                                  pincode: arr[arr.length - 2],
                                  district: arr[arr.length - 3],
                                  photo: photoUrlController.text,
                                  address: currentAddress,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  items: storesItem,
                                  outStock: outStock,
                                  about: aboutController.text,
                                  opens: opens,
                                  closes: closes,
                                  isOpen: isOpen,
                                );
                                await APIs.instance
                                    .createShop(currentShop: newShop);
                              }
                            },
                            child: Text("Update Details"),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                      ]
            ),
          ),
        ));
  }
}
