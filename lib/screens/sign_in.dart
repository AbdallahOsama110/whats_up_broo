// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:whats_up_broo/screens/sign_up.dart';
import 'package:whats_up_broo/widgets/sign_in_textField.dart';
import '../core/const/const.dart';
import '../resources/auth_methods.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> signInFormKey = GlobalKey();
  bool inAsyncCall = false;

  String? email;

  String? password;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

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
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: size.height * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: size.height * 0.3,
                      child: Lottie.asset('images/71230-sign-in-green.json'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          label: 'Email',
                          isEmail: true,
                          controller: emailController,
                          onChanged: (data) => email = data,
                        ),
                        SizedBox(height: 20),
                        CustomPasswordTextField(
                          label: 'Password',
                          controller: passwordController,
                          onChanged: (data) => password = data,
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: signInFunction,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Sign In',
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
                            Text("don't have an account ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                                FocusScope.of(context).unfocus();
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInFunction() async {
    FocusScope.of(context).unfocus();
    if (signInFormKey.currentState!.validate()) {
      setState(() {
        inAsyncCall = true;
      });
      await AuthMethods().signInUser(
          context, emailController, passwordController,
          email: email!, password: password!);
      setState(() {
        inAsyncCall = false;
      });
    }
  }
}