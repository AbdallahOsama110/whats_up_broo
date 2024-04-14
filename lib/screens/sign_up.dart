// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../core/const/const.dart';
import '../functions/show_snack_bar.dart';
import '../resources/auth_methods.dart';
import '../widgets/sign_in_textField.dart';

class SignUpScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool inAsyncCall = false;

  GlobalKey<FormState> formKey = GlobalKey();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var rePasswordController = TextEditingController();
  String? email;
  String? password;
  String? name;

  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: size.height * 0.05, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: Lottie.asset('images/53395-login.json'),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.06,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Color(0xff2B475E),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: nameController,
                          label: 'Enter your name',
                          isEmail: false,
                          onChanged: (data) => name = data,
                          //onTap: () => formKey.currentState!.reset(),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: emailController,
                          label: 'Email',
                          isEmail: true,
                          onChanged: (data) => email = data,
                          //onTap: () => formKey.currentState!.reset(),
                        ),
                        SizedBox(height: 10),
                        CustomPasswordTextField(
                          controller: passwordController,
                          label: 'Enter new password',
                          onChanged: (data) => password = data,
                          //onTap: () => formKey.currentState!.reset(),
                        ),
                        SizedBox(height: 10),
                        CustomPasswordTextField(
                          controller: rePasswordController,
                          //onTap: () => formKey.currentState!.reset(),
                          label: 'Enter password again',
                          myFocusNode: myFocusNode,
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: signUpFunction,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Color(0xff2B475E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Back to the page of ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal)),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text('Sign In',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpFunction() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      //! this 'if' to check if the inputs of password_textFields are matched or not.
      if (passwordController.text == rePasswordController.text) {
        setState(() {
          inAsyncCall = true;
        });
        await AuthMethods().signUpUser(
            context, clearAll, customDialog, clearPasswordTextFields,
            email: email!, password: password!, name: name!);
        setState(() {
          inAsyncCall = false;
        });
        //*=======================================================================

        //!=======(this (else if) to make the user enter password again.)===========
      } else if (rePasswordController.text.isEmpty) {
        showSnackBar(context, 'Please enter password again!!', false);
        Timer(Duration(milliseconds: 600), () {
          setState(() {
            myFocusNode.requestFocus();
          });
        });
        //!=========================================================================
      } else {
        //* this will execute when the two password_textFields not matched.
        showSnackBar(context, 'password not matched!', false);
        clearPasswordTextFields();
      }
    } else {
      showSnackBar(context, 'Enter all inputs correctly!', false);
    }
  }

  void customDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.only(top: 30),
            contentPadding: EdgeInsets.only(bottom: 30),
            title: Center(
              child: Text(
                'account created successfully 🥳',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Lottie.asset('images/130209-congratulation.json'),
            ),
          );
        });
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void clearAll() {
    setState(() {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      rePasswordController.clear();
    });
  }

  void clearPasswordTextFields() {
    passwordController.clear();
    password = null;
    rePasswordController.clear();
  }
}
