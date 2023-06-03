import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
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

  var uuid = Uuid();

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

}
