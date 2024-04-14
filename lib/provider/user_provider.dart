import 'package:flutter/widgets.dart';
import 'package:whats_up_broo/classes/userData.dart';
import 'package:whats_up_broo/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  UserData? user;
  final AuthMethods authMethods = AuthMethods();

  UserData? get getUser => user;
  Future<void> refreshUser() async {
    UserData userData = await authMethods.getUserData();
    user = userData;
    notifyListeners();
  }
}
