import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:local_ease/models/shop_model.dart';
import 'package:local_ease/models/user_model.dart';
import 'package:local_ease/utils/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class APIs {
  APIs._privateConstructor();
  static final APIs _instance = APIs._privateConstructor();
  static APIs get instance => _instance;
  static final Future<SharedPreferences> _prefs =
  SharedPreferences.getInstance();

  static final account = Account(client);

  static final databases = Databases(client);

  var uuid = Uuid(); // Generates UniqueIDs

  Future<String?> getUserID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userId');
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', value);
  }

  Future<bool> loginEmailPassword(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    try {
      final models.Session response =
      await account.createEmailSession(email: email, password: password);
      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUpEmailPassword(
      String email, String password, String name) async {
    final SharedPreferences prefs = await _prefs;
    try {
       await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      final models.Session response = await account.createEmailSession(
        email: email,
        password: password,
      );
      prefs.setString('userId', response.userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      setLoggedIn(true);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    final SharedPreferences prefs = await _prefs;
    setLoggedIn(false);
    prefs.remove('userId');
    prefs.remove('email');
    prefs.remove('password');
  }





  /// Database CRUD Operation Functions



  // if docid == null create else update

  // Create Store
  Future<void> createShop(
      {required ShopModel currentShop,}) async {
    try {
      await getUserID().then((userId) async {
        String docId = uuid.v1();
        ShopModel myShop = currentShop;
        myShop.ownerId = userId;
        myShop.subscribers =[];
        myShop.photo = "";
        myShop.outStock = [];
        myShop.isOpen = true;
        await databases.createDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: userId!,
          data: myShop.toJson(),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update Store
  updateShopInfo(ShopModel currentShop) async {
    try {
      await databases.updateDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentShop.ownerId!,
        data: currentShop.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete Account's Store
  deleteShop(ShopModel currentShop) async {
    try {
      await databases.deleteDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentShop.ownerId!,
      );
    } catch (e) {
      rethrow;
    }
  }





  // Create New User
  Future<void> createUser(
      {required MyUserModel currentUser,}) async {
    try {
      await getUserID().then((userId) async {
        String docId = uuid.v1();
        MyUserModel myUser = currentUser;
        myUser.docId = userId;
        myUser.following = [];
        myUser.notifications = [];
        myUser.photo = "";
        myUser.type = "";
        await databases.createDocument(
          databaseId: Credentials.DatabaseId,
          collectionId: Credentials.ShopsCollectionId,
          documentId: userId!,
          data: myUser.toJson(),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update User
  updateUserInfo(ShopModel currentShop) async {
    try {
      await databases.updateDocument(
        databaseId: Credentials.DatabaseId,
        collectionId: Credentials.ShopsCollectionId,
        documentId: currentShop.ownerId!,
        data: currentShop.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }



}
