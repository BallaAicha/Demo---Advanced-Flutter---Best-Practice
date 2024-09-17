import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testeur/domain/model/login_response.dart';
import 'package:testeur/domain/model/logged_user.dart';

class TokenManager {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _loggedUserKey = 'loggedUser';

  Future<void> saveTokens(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, loginResponse.accessToken);
    await prefs.setString(_refreshTokenKey, loginResponse.refreshToken);
  }

  Future<void> saveLoggedUser(LoggedUser loggedUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedUserKey, jsonEncode(loggedUser.toJson()));
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_loggedUserKey);
  }
}