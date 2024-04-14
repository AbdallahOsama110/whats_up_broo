import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomPasswordTextField extends StatefulWidget {
  final String label;
  late FocusNode? myFocusNode;
  TextEditingController? controller;
  Function(String)? onChanged;
  Function()? onTap;
  CustomPasswordTextField(
      {super.key,
      this.controller,
      this.onChanged,
      this.onTap,
      required this.label,
      this.myFocusNode});

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'Enter password!';
        }
        return null;
      },
      focusNode: widget.myFocusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      cursorColor: Colors.blue,
      obscureText: passwordVisible,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: passwordVisible
              ? const Icon(
                  Icons.visibility_off_outlined,
                  color: Color.fromARGB(255, 205, 205, 205),
                )
              : const Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                ),
          onPressed: () {
            setState(
              () {
                passwordVisible = !passwordVisible;
              },
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        labelText: widget.label,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 205, 205, 205),
            fontSize: 15,
            fontWeight: FontWeight.normal),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 3),
        ),
      ),
    );
  }
}

//!=====================================================================================================================================================
class CustomTextField extends StatelessWidget {
  final bool isEmail;
  final String label;
  TextEditingController? controller;
  Function(String)? onChanged;
  Function()? onTap;
  CustomTextField(
      {super.key,
      this.controller,
      this.onChanged,
      this.onTap,
      required this.label,
      required this.isEmail});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'Enter Email!';
        } else if (!RegExp(
                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                .hasMatch(data) &&
            isEmail == true) {
          return 'Enter valid email';
        }
        return null;
      },
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      cursorColor: Colors.blue,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        labelText: label,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 205, 205, 205),
            fontSize: 15,
            fontWeight: FontWeight.normal),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.blue, width: 3)),
      ),
    );
  }
}
