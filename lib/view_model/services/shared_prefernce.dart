import 'package:shared_preferences/shared_preferences.dart';

Future<void> writeUid(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

Future<void> devicetoken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceToken', token);
}

Future<bool> removeuser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  return true;
}
