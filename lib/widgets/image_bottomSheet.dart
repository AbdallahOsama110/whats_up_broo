// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/const/const.dart';

Widget imageBottomSheet(
    BuildContext context, Function(ImageSource imageSource) takePhoto) {
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      children: [
        Text(
          'Choose profile photo',
          style: TextStyle(
              fontSize: 20, color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () async {
                takePhoto(ImageSource.camera);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.camera),
              label: Text('Camera'),
            ),
            TextButton.icon(
              onPressed: () async {
                takePhoto(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.image),
              label: Text('Gallery'),
            ),
          ],
        )
      ],
    ),
  );
}
