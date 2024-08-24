import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class AuthController{
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String accessToken = '';
  static UserModel? userData;


  static Future<void> saveUserAccessToken (String token) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken () async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(_accessTokenKey);
  }

  static Future<void> saveUserData (UserModel user) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(_userDataKey, jsonEncode(user.toJson()));
    userData = user;
  }
  static Future<UserModel?> getUserData () async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String? data = sharedPrefs.getString(_userDataKey);
    if (data == null) return null;
    UserModel userModel = UserModel.fromJson(jsonDecode(data));
    return userModel;
  }

  static Future<bool> checkAuthState()async{
    String? token = await getUserAccessToken();
    if(token == null)return false;
    accessToken = token;
    userData = await getUserData();
    return true;
  }

  static Future<void> clearAllData ()async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
  }

}