// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '../core/const/const.dart';
import '../provider/myTheme.dart';

Container sendTextField(
    TextEditingController sendController,
    Size size,
    MyTheme myTheme,
    BuildContext context,
    void Function(BuildContext context, String data) sendMessages) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    height: size.height * 0.1,
    decoration: BoxDecoration(
      //color: kPrimaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: myTheme.isDark ? kDbodyColor : kBodyColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: myTheme.isDark
              ? []
              : [
                  BoxShadow(
                    color: kDarkShadowColor,
                    offset: Offset(2, 5.4),
                    blurRadius: 10,
                    spreadRadius: 0.0,
                  ),
                  BoxShadow(
                    color: kLightShadowColor,
                    offset: Offset(-7.4, -5.4),
                    blurRadius: 10,
                    spreadRadius: 0.0,
                  ),
                ],
        ),
        child: TextField(
          textInputAction: TextInputAction.send,
          controller: sendController,
          onSubmitted: (data) {
            sendMessages(context, data);
          },
          cursorColor: Colors.deepPurple,
          style: TextStyle(
              color: myTheme.isDark ? Colors.white : kPrimaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Send Message',
            hintStyle:
                TextStyle(color: myTheme.isDark ? Colors.grey : Colors.black54),
            suffixIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  sendMessages(context, sendController.text);
                },
                icon: Icon(Icons.send,
                    color: myTheme.isDark ? Colors.grey : kPrimaryColor)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: kBodyColor, width: 2)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
      ),
    ),
  );
}
