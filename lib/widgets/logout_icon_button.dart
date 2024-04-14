import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/const/const.dart';
import '../core/utils/cache_helper.dart';
import '../functions/show_snack_bar.dart';
import '../screens/sign_in.dart';

class LogoutIconButton extends StatelessWidget {
  const LogoutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Sign Out',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            content: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Are you sure ?',
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  showSnackBar(context, 'Signed Out Successfully...', true);
                  await CacheHelper.removeData(key: 'email');
                  await CacheHelper.removeData(key: 'password');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: const Text('OK', style: TextStyle(color: kPrimaryColor)),
              ),
            ],
          ),
        );
      },
      icon: const Icon(
        Icons.logout_outlined,
      ),
    );
  }
}
