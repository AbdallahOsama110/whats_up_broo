// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:whats_up_broo/provider/user_provider.dart';
import 'package:whats_up_broo/screens/chat_screen.dart';
import 'package:whats_up_broo/screens/profile_screen.dart';
import '../classes/userData.dart';
import '../core/const/const.dart';
import '../widgets/logout_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    updateData();
    super.initState();
  }

  updateData() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<UserProvider>(context).getUser;
    var size = MediaQuery.of(context).size;

    return userData != null
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: userData.profileImageUrl == null
                    ? Icon(
                        Icons.account_circle,
                        size: 30,
                      )
                    : CircleAvatar(
                        backgroundColor: Color(0xffE5E6E8),
                        backgroundImage:
                            NetworkImage(userData.profileImageUrl!),
                        radius: 18,
                      ),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfileScreen())),
              ),
              centerTitle: true,
              title: Text(
                'WhatsUpBroo',
              ),
              actions: [
                LogoutIconButton(),
              ],
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcom ',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        userData.username,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                      height: size.height * 0.5,
                      child: Lottie.asset(
                          'images/143852-cute-chatbot-greeting-people-with-computer.json')),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.deepPurple;
                          }
                          return null;
                        },
                      ),
                      textStyle: MaterialStateProperty.resolveWith((states) =>
                          TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => kPrimaryColor),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(id: userData.uid))),
                    child: Text(
                      'Go to Chat',
                      style: TextStyle(fontFamily: 'Courgette'),
                    ),
                  ),
                ],
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'WhatsUpBroo',
              ),
              actions: [
                LogoutIconButton(),
              ],
            ),
            body: Center(
              child: Text(
                'Loding...',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          );
  }
}
