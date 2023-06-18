import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/apis/APIs.dart';
import 'package:local_ease/helpers/dateTimeHelper.dart';
import 'package:local_ease/models/item_model.dart';
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/seller_screens/manage_store_items.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';
import 'package:local_ease/widgets/itemstag.dart';
import 'package:local_ease/widgets/textfields.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:uuid/uuid.dart';

import '../helpers/dialogs.dart';
import '../main.dart';
import '../models/notification.model.dart';
import '../utils/credentials.dart';

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
  // Photo id
  String? photoUrl;
  TextEditingController aboutController = TextEditingController();
  TextEditingController addItemController = TextEditingController();
  String opens = "";
  String closes = "";

  List storesItem = [];
  List storesItemId = [];

  List outStock = [];
  List outStockItemId = [];

  ShopModel? myCurrentShop;
  var uuid = Uuid();
 final storage = Storage(client);

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
      photoUrl =  myCurrentShop!.photo;
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
        appBar: isOpen != null
            ? AppBar(
                title: Text("Manage Your Store"),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isOpen! ? AppColors.tabPink : AppColors.tabGrey,
                          foregroundColor:
                              isOpen! ? AppColors.white : AppColors.grey,
                        ),
                        onPressed: isOpen!
                            ? () {}
                            : () {
                                bool clk = false;
                                Dialogs.showOpenCloseDialog(
                                    context: context,
                                    title: "Opening Store Now!",
                                    description:
                                        "Make sure you have set the store time and details correctly as this will send your subscribers a notification",
                                    onBtnClk: () async {
                                      isOpen = true;
                                      myCurrentShop!.isOpen = isOpen;
                                      await APIs.instance
                                          .updateShopInfo(myCurrentShop!)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });

                                      NotificationModel myNotif =
                                      NotificationModel(
                                        title: "${storeNameController.text} Opening Now!",
                                        description: "Opens today check more details of the store",
                                        photo: photoUrlController.text,
                                      );
                                      await APIs.instance
                                          .createNotification(myNotif)
                                          .then((value) {
                                        log("notif sent as open");
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
                          foregroundColor:
                              isOpen! ? AppColors.grey : AppColors.white,
                        ),
                        onPressed: isOpen!
                            ? () {
                                bool clk = false;
                                Dialogs.showOpenCloseDialog(
                                    context: context,
                                    title: "Closing Store for today?",
                                    description:
                                        "Confirm if you want to close store now this will also send your subscribers a notification",
                                    onBtnClk: () async {
                                      isOpen = false;
                                      myCurrentShop!.isOpen = isOpen;
                                      await APIs.instance
                                          .updateShopInfo(myCurrentShop!)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });

                                      NotificationModel myNotif =
                                      NotificationModel(
                                        title: "${storeNameController.text} Closing Now!",
                                        description: "Closing for today will be back soon!",
                                        photo: photoUrlController.text,
                                      );
                                      await APIs.instance
                                          .createNotification(myNotif)
                                          .then((value) {
                                        log("notif sent as closed");
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
                              }
                            : () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text("Closed"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppBar(
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
                          height: 8,
                        ),
                        Text(
                          'Photo',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: Theme.of(context).hintColor,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),

                        photoUrl != null ? Container(
                            height: 250,
                            width: double.infinity,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.network(
                              photoUrl ?? 'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg' ,
                              fit: BoxFit.cover,
                            )): Text("Photo not selected yet"),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tabGrey,
                          ),
                          onPressed: () async{

                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'gif'],
                            );

                            String id = uuid.v1();

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              log(file.path);
                              String fileName = result.files.single.name;

                              Future result2 = storage.createFile(
                                bucketId: Credentials.PhotosBucketId,
                                fileId: id,
                                file: InputFile(
                                  path: file.path,
                                ),
                              );

                              result2.then((response) {
                                log("Pic Uploaded");
                                photoUrl = 'https://cloud.appwrite.io/v1/storage/buckets/${Credentials.PhotosBucketId}/files/${id}/view?project=${Credentials.ProjectID}';
                                setState(() {});
                                Dialogs.showSnackbar(context, "Picture updated successfully! Update to save");
                              }).catchError((error) {
                                print(error.response);
                                Dialogs.showSnackbar(context, "${error}");
                              });
                            } else {
                              // User canceled the picker
                              Dialogs.showSnackbar(context, "Unable to upload canceled in between");
                            }
                          },
                          child: Text("Upload Image", style: textTheme.titleSmall!.copyWith(color: AppColors.grey),),
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
                                  Text(
                                    "Opens: ${opens}",
                                    style: textTheme.bodyMedium!.copyWith(
                                        color: Colors.deepPurple[700]),
                                  ),
                                  Text(
                                    "Closes: ${closes}",
                                    style: textTheme.bodyMedium!
                                        .copyWith(color: AppColors.orange),
                                  ),
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
                            setState(() {
                              isOpen = true;
                            });

                            if (myCurrentShop != null) {
                              myCurrentShop!.name = storeNameController.text;
                              myCurrentShop!.lat = lat;
                              myCurrentShop!.long = long;
                              myCurrentShop!.country = arr[arr.length - 1];
                              myCurrentShop!.pincode = arr[arr.length - 2];
                              myCurrentShop!.district = arr[arr.length - 3];
                              myCurrentShop!.photo = photoUrl;
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
                                photo: photoUrl,
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
                                  .createShop(currentShop: newShop)
                                  .then((value) {
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                            zoomOutIcon:
                                                CupertinoIcons.zoom_out,
                                            locationPinIconColor:
                                                AppColors.pink,
                                            buttonText: 'Set This Location',
                                            onPicked: (pickedData) {
                                              print(
                                                  pickedData.latLong.latitude);
                                              print(
                                                  pickedData.latLong.longitude);
                                              print(pickedData.address);

                                              lat = pickedData.latLong.latitude
                                                  .toString();
                                              long = pickedData
                                                  .latLong.longitude
                                                  .toString();
                                              currentAddress =
                                                  pickedData.address;
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
                              height: 8,
                            ),
                              Text(
                                'Photo',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  color: Theme.of(context).hintColor,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),

                             photoUrl != null ? Container(
                                 height: 250,
                                 width: double.infinity,
                                 clipBehavior: Clip.antiAliasWithSaveLayer,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 child: Image.network(
                                   photoUrl ?? 'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg' ,
                                   fit: BoxFit.cover,
                                 )): Text("Photo not selected yet"),
                            const SizedBox(
                             height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tabGrey,
                              ),
                              onPressed: () async{

                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'gif'],
                                );

                                String id = uuid.v1();

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  log(file.path);
                                  String fileName = result.files.single.name;

                                  Future result2 = storage.createFile(
                                    bucketId: Credentials.PhotosBucketId,
                                    fileId: id,
                                    file: InputFile(
                                      path: file.path,
                                    ),
                                  );

                                  result2.then((response) {
                                    log("Pic Uploaded");
                                    photoUrl = 'https://cloud.appwrite.io/v1/storage/buckets/${Credentials.PhotosBucketId}/files/${id}/view?project=${Credentials.ProjectID}';
                                    setState(() {});
                                    Dialogs.showSnackbar(context, "Picture updated successfully! Update to save");
                                  }).catchError((error) {
                                    print(error.response);
                                    Dialogs.showSnackbar(context, "${error}");
                                  });
                                } else {
                                  // User canceled the picker
                                  Dialogs.showSnackbar(context, "Unable to upload canceled in between");
                                }
                              },
                              child: Text("Upload Image", style: textTheme.titleSmall!.copyWith(color: AppColors.grey),),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color:
                                                  Theme.of(context).hintColor,
                                              letterSpacing: 0.1,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Opens: ${opens}",
                                        style: textTheme.bodyMedium!.copyWith(
                                            color: Colors.deepPurple[700]),
                                      ),
                                      Text(
                                        "Closes: ${closes}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: AppColors.orange),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Update Timing',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                              height: SizeConfig.safeBlockHorizontal! * 40,
                              width: SizeConfig.safeBlockHorizontal! * 90,
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  for (var str in storesItem)
                                    Container(
                                      width: SizeConfig.safeBlockHorizontal! * 80,
                                      margin: EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border:
                                            Border.all(color: AppColors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: SizeConfig.safeBlockHorizontal! * 28,
                                            height: double.infinity,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft:  Radius.circular(10),),
                                            ),
                                            child: Image.network(
                                              'https://kinsta.com/wp-content/uploads/2020/09/imag-file-types-1024x512.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: SizeConfig.safeBlockHorizontal! * 46,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${str}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: textTheme.titleMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.1),
                                                      ),
                                                      const SizedBox(height: 3,),
                                                      Text(
                                                        "Create beautiful apps faster with Flutter’s collection of visual, structural, platform, and interactive widgets. In addition to browsing widgets by category, you can",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: textTheme.displayMedium!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*3.2),
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          outStock.contains(str)
                                                              ? IconButton(
                                                                  onPressed: () {
                                                                    outStock.remove(str);
                                                                    setState(() {});
                                                                  },
                                                                  icon: Icon(
                                                                    CupertinoIcons
                                                                        .xmark_circle,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),

                            // Add Item with Item Model
                            // ElevatedButton(
                            //   onPressed: () {
                            //     String name = "";
                            //     String desc = "";
                            //     String photo = "";
                            //
                            //     // passIt( NotificationModel myNotif) async {
                            //     //   await APIs.instance
                            //     //       .createNotification(myNotif)
                            //     //       .then((value) {
                            //     //     btn = true;
                            //     //     setState(() {});
                            //     //     updateUI();
                            //     //   });
                            //     //
                            //     // }
                            //
                            //     showDialog(
                            //       barrierDismissible: false,
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         bool clk2 = false;
                            //         return Material(
                            //           child: Container(
                            //             color: AppColors.scaffoldBackGround,
                            //             padding: const EdgeInsets.all(16.0),
                            //             width: double.infinity,
                            //             height: double.infinity,
                            //             child: Column(
                            //               children: <Widget>[
                            //                 Container(
                            //                   height: 20,
                            //                 ),
                            //                 TextFieldInput(
                            //                   title: 'Name',
                            //                   hintText: 'Enter name of item',
                            //                   maxLength: 30,
                            //                   onChanged: (val) {
                            //                     name = val;
                            //                   },
                            //                 ),
                            //                 Container(
                            //                   height: 10,
                            //                 ),
                            //                 TextFieldInput(
                            //                   title: 'Description',
                            //                   hintText: 'Item Description',
                            //                   maxLines: 4,
                            //                   maxLength: 200,
                            //                   onChanged: (val) {
                            //                     desc = val;
                            //                   },
                            //                 ),
                            //                 Container(
                            //                   height: 5,
                            //                 ),
                            //                 TextFieldInput(
                            //                   title: 'Photo Link',
                            //                   hintText:
                            //                       'Paste link of item image here',
                            //                   onChanged: (val) {
                            //                     photo = val;
                            //                   },
                            //                 ),
                            //                 SizedBox(
                            //                   height: 15,
                            //                 ),
                            //                 Row(
                            //                   children: <Widget>[
                            //                     Spacer(),
                            //                     TextButton(
                            //                         child: Text('Discard'),
                            //                         onPressed: () {
                            //                           Navigator.of(context)
                            //                               .pop();
                            //                         }),
                            //                     SizedBox(
                            //                       width: 20,
                            //                     ),
                            //                     TextButton(
                            //                       child:
                            //                           Text('Add'),
                            //                       onPressed: () async {
                            //                         String id = uuid.v1();
                            //
                            //                         ItemModel myItem =
                            //                             ItemModel(
                            //                           name: name,
                            //                           description: desc,
                            //                           photo: photo,
                            //                           itemId: id,
                            //                         );
                            //
                            //                         // Dialogs.showLoaderDialog(context, "Saving");
                            //
                            //                         try {
                            //                           await APIs.databases
                            //                               .createDocument(
                            //                             databaseId: Credentials
                            //                                 .DatabaseId,
                            //                             collectionId: Credentials
                            //                                 .ItemsCollectonId,
                            //                             documentId: id,
                            //                             data: myItem.toJson(),
                            //                           ).then((value) {
                            //                               storesItem.add(id);
                            //                               Navigator.pop(context);
                            //                               Dialogs.showOpenCloseDialog(context: context, onBtnClk: () {
                            //                                 setState(() {}); }, title: "New item added!", description: "You store gota new item added to save it you need to update store details", icon: Icons.done );
                            //                           });
                            //                         } catch (e) {
                            //                           Dialogs.showSnackbar(context, "${e}");
                            //                         }
                            //                       },
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            //   child: Text("Add Item"),
                            // ),

                            // Container(
                            //   height: 100,
                            //   width: 200,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: storesItemId.length,
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Container(
                            //           color: Colors.red,
                            //           child: Text(storesItemId[index]),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),

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
                                  myCurrentShop!.name =
                                      storeNameController.text;
                                  myCurrentShop!.lat = lat;
                                  myCurrentShop!.long = long;
                                  myCurrentShop!.country = arr[arr.length - 1];
                                  myCurrentShop!.pincode = arr[arr.length - 2];
                                  myCurrentShop!.district = arr[arr.length - 3];
                                  myCurrentShop!.photo = photoUrl;
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
                                      .updateShopInfo(myCurrentShop!)
                                      .then((value) {
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
                                    photo: photoUrl,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                            zoomOutIcon:
                                                CupertinoIcons.zoom_out,
                                            locationPinIconColor:
                                                AppColors.pink,
                                            buttonText: 'Set This Location',
                                            onPicked: (pickedData) {
                                              print(
                                                  pickedData.latLong.latitude);
                                              print(
                                                  pickedData.latLong.longitude);
                                              print(pickedData.address);

                                              lat = pickedData.latLong.latitude
                                                  .toString();
                                              long = pickedData
                                                  .latLong.longitude
                                                  .toString();
                                              currentAddress =
                                                  pickedData.address;
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
                              height: 8,
                            ),
                            Text(
                              'Photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: Theme.of(context).hintColor,
                                letterSpacing: 0.1,
                              ),
                            ),
                            const SizedBox(
                              height: 9,
                            ),

                            photoUrl != null ? Container(
                                height: 250,
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.network(
                                  photoUrl ?? 'https://imgv3.fotor.com/images/blog-cover-image/part-blurry-image.jpg' ,
                                  fit: BoxFit.cover,
                                )): Text("Photo not selected yet"),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tabGrey,
                              ),
                              onPressed: () async{

                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'gif'],
                                );

                                String id = uuid.v1();

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  log(file.path);
                                  String fileName = result.files.single.name;

                                  Future result2 = storage.createFile(
                                    bucketId: Credentials.PhotosBucketId,
                                    fileId: id,
                                    file: InputFile(
                                      path: file.path,
                                    ),
                                  );

                                  result2.then((response) {
                                    log("Pic Uploaded");
                                    photoUrl = 'https://cloud.appwrite.io/v1/storage/buckets/${Credentials.PhotosBucketId}/files/${id}/view?project=${Credentials.ProjectID}';
                                    setState(() {});
                                    Dialogs.showSnackbar(context, "Picture updated successfully! Update to save");
                                  }).catchError((error) {
                                    print(error.response);
                                    Dialogs.showSnackbar(context, "${error}");
                                  });
                                } else {
                                  // User canceled the picker
                                  Dialogs.showSnackbar(context, "Unable to upload canceled in between");
                                }
                              },
                              child: Text("Upload Image", style: textTheme.titleSmall!.copyWith(color: AppColors.grey),),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color:
                                                  Theme.of(context).hintColor,
                                              letterSpacing: 0.1,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Opens: ${opens}",
                                        style: textTheme.bodyMedium!.copyWith(
                                            color: Colors.deepPurple[700]),
                                      ),
                                      Text(
                                        "Closes: ${closes}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: AppColors.orange),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Update Timing',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                        border:
                                            Border.all(color: AppColors.grey),
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
                                                        CupertinoIcons
                                                            .xmark_circle,
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
                                  myCurrentShop!.name =
                                      storeNameController.text;
                                  myCurrentShop!.lat = lat;
                                  myCurrentShop!.long = long;
                                  myCurrentShop!.country = arr[arr.length - 1];
                                  myCurrentShop!.pincode = arr[arr.length - 2];
                                  myCurrentShop!.district = arr[arr.length - 3];
                                  myCurrentShop!.photo = photoUrl;
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
                                      .updateShopInfo(myCurrentShop!)
                                      .then((value) {
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
                                    photo:photoUrl,
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
                          ]),
          ),
        ));
  }
}
