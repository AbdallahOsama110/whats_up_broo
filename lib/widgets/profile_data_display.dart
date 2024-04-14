// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

Widget dataDisplay(
    BuildContext context, Size size, String text1, String text2) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Text(
          text1,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Text(
          text2,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    ],
  );
}
