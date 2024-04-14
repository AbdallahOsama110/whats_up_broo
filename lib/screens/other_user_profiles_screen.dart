// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:whats_up_broo/classes/userData.dart';
import '../widgets/profile_data_display.dart';
import 'image_profile_screen.dart';

class OtherUserProfileScreen extends StatelessWidget {
  final UserData userData;
  const OtherUserProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('${userData.username}  Profile'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: () {
                if (userData.profileImageUrl != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageProfileScreen(
                          profileImageUrl: userData.profileImageUrl!)));
                }
              },
              child: CircleAvatar(
                backgroundColor: Color(0xffE5E6E8),
                backgroundImage: userData.profileImageUrl == null
                    ? AssetImage('images/blank_profile_image.jpg')
                    : NetworkImage(userData.profileImageUrl!) as ImageProvider,
                radius: 80,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              userData.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //color: Colors.blue,
            child: Column(
              children: [
                Divider(),
                dataDisplay(context, size, 'Bio : ', userData.bio!),
                Divider(),
                dataDisplay(context, size, 'User Name : ', userData.username),
                Divider(),
                dataDisplay(context, size, 'User Email : ', userData.email),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}