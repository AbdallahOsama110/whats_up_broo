import 'package:flutter/material.dart';
import '../core/utils/cache_helper.dart';

class MyTheme extends ChangeNotifier {
  bool isDark = false;  
  Future<void> changeTheme(bool value) async {
    isDark = value;
    await CacheHelper.putData(key: 'isDark', value: isDark);
    notifyListeners();
  }
}