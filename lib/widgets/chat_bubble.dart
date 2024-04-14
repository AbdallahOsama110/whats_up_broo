// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../classes/message.dart';
import '../classes/userData.dart';
import 'package:intl/intl.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../core/const/const.dart';
import '../screens/other_user_profiles_screen.dart';

class SenderBubble extends StatelessWidget {
  const SenderBubble({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    DateTime timeStamp = DateTime.timestamp();
    timeStamp = message.timeCreate.toDate();

    var messTime = new DateFormat('h:mm a').format(timeStamp).toString();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BubbleSpecialThree(
            text: message.message,
            textStyle: TextStyle(color: Colors.white, fontSize: 15),
            color: kPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              messTime,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

//!================================================================================================================================================================================
class OthersBubble extends StatelessWidget {
  const OthersBubble({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    DateTime timeStamp = DateTime.timestamp();
    timeStamp = message.timeCreate.toDate();

    var messTime = new DateFormat('h:mm a').format(timeStamp).toString();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> usersList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              if (snapshot.data!.docs[i].get('uid') == message.id) {
                usersList.add(UserData.fromJson(snapshot.data!.docs[i]));
              }
            }
            return Container(
              //color: Colors.red,
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              OtherUserProfileScreen(userData: usersList.first),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE5E6E8),
                        backgroundImage: usersList.first.profileImageUrl == null
                            ? AssetImage('images/blank_profile_image.jpg')
                            : NetworkImage(usersList.first.profileImageUrl!)
                                as ImageProvider,
                        radius: 20,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          usersList.first.username,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 15,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      BubbleSpecialThree(
                        isSender: false,
                        text: message.message,
                        textStyle: TextStyle(color: Colors.white, fontSize: 15),
                        color: kSecondryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          messTime,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
