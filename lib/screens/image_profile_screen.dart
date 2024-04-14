// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/myTheme.dart';

class ImageProfileScreen extends StatelessWidget {
  final String profileImageUrl;
  const ImageProfileScreen({super.key, required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var myTheme = Provider.of<MyTheme>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: size.width,
                child: Image.network(profileImageUrl),
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: myTheme.isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
