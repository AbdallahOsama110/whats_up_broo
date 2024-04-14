// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:whats_up_broo/functions/show_snack_bar.dart';
import 'package:whats_up_broo/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_up_broo/screens/image_profile_screen.dart';
import '../classes/userData.dart';
import '../core/const/const.dart';
import '../provider/myTheme.dart';
import '../provider/user_provider.dart';
import '../resources/auth_methods.dart';
import '../widgets/image_bottomSheet.dart';
import '../widgets/logout_icon_button.dart';
import '../widgets/profile_data_display.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  XFile? imageFile;
  Uint8List? image;
  final ImagePicker picker = ImagePicker();

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool inAsyncCall = false;

  var user = FirebaseAuth.instance.currentUser;
  String? name;
  String? bio;

  void saveProfileImage() async {
    setState(() {
      inAsyncCall = true;
    });
    try {
      await AuthMethods()
          .updateProfilImage(context, updateData(), fileImage: image!);
      showSnackBar(context, 'Profile image changed successfully...', true);
    } catch (e) {
      showSnackBar(context, '$e', false);
    }
    setState(() {
      inAsyncCall = false;
    });
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var myTheme = Provider.of<MyTheme>(context);
    UserData? userData = Provider.of<UserProvider>(context).getUser;

    return Form(
      key: formKey,
      child: ModalProgressHUD(
        inAsyncCall: inAsyncCall,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            title: Text('Profile'),
            actions: [
              LogoutIconButton(),
            ],
          ),
          body: ListView(
            children: [
              SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (userData.profileImageUrl != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageProfileScreen(
                                  profileImageUrl: userData.profileImageUrl!)));
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE5E6E8),
                        backgroundImage: userData!.profileImageUrl == null
                            ? AssetImage('images/blank_profile_image.jpg')
                            : NetworkImage(userData.profileImageUrl!)
                                as ImageProvider,
                        radius: 80,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kSecondryColor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 25,
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                                context: context,
                                builder: ((builder) =>
                                    imageBottomSheet(context, takePhoto)));
                          },
                        ),
                      ),
                    ),
                  ],
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
                    Stack(
                      children: [
                        dataDisplay(context, size, 'Bio : ', userData.bio!),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit,
                                color: myTheme.isDark
                                    ? Colors.white
                                    : kPrimaryColor),
                            onPressed: () async {
                              showModalBottomSheet(
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((builder) =>
                                      changeBioBottomSheet(size, myTheme)));
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Stack(
                      children: [
                        dataDisplay(
                            context, size, 'User Name : ', userData.username),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit,
                                color: myTheme.isDark
                                    ? Colors.white
                                    : kPrimaryColor),
                            onPressed: () async {
                              showModalBottomSheet(
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((builder) =>
                                      changeNameBottomSheet(size, myTheme)));
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    dataDisplay(context, size, 'User Email : ', userData.email),
                    Divider(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Theme Mode',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          imageSwitch(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget changeNameBottomSheet(Size size, MyTheme myTheme) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Username',
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: size.width * 0.5,
                  child: Center(
                    child: TextFormField(
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'Enter name to change';
                        }
                        return null;
                      },
                      controller: nameController,
                      onChanged: (data) => name = data,
                      cursorColor: Colors.deepPurple,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Enter name to change',
                        hintStyle: TextStyle(
                            color:
                                myTheme.isDark ? Colors.grey : Colors.black54),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        inAsyncCall = true;
                      });
                      try {
                        await user!.updateDisplayName(name);
                        await AuthMethods().updateUserData(
                            context, 'username', name!, updateData());

                        setState(() {});
                        showSnackBar(
                            context, 'Name changed successfully...', true);
                        nameController.clear();
                        Navigator.of(context).pop();
                      } catch (e) {
                        showSnackBar(context, '$e', false);
                      }
                      setState(() {
                        inAsyncCall = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.redAccent; //<-- SEE HERE
                        return null; // Defer to the widget's default.
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    textStyle: MaterialStateProperty.resolveWith((states) =>
                        TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  child: Text('Change name'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget changeBioBottomSheet(Size size, MyTheme myTheme) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Bio',
              style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: size.width * 0.5,
                  child: Center(
                    child: TextFormField(
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'Enter Bio to change';
                        }
                        return null;
                      },
                      controller: bioController,
                      onChanged: (data) => bio = data,
                      cursorColor: Colors.deepPurple,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Enter name to change',
                        hintStyle: TextStyle(
                            color:
                                myTheme.isDark ? Colors.grey : Colors.black54),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        inAsyncCall = true;
                      });
                      try {
                        await AuthMethods()
                            .updateUserData(context, 'bio', bio!, updateData());
                        setState(() {});
                        showSnackBar(
                            context, 'Bio changed successfully...', true);
                        nameController.clear();
                        Navigator.of(context).pop();
                      } catch (e) {
                        showSnackBar(context, '$e', false);
                      }
                      setState(() {
                        inAsyncCall = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.redAccent; //<-- SEE HERE
                        return null; // Defer to the widget's default.
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    textStyle: MaterialStateProperty.resolveWith((states) =>
                        TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  child: Text('Change Bio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imageSwitch() {
    var myTheme = Provider.of<MyTheme>(context);
    return Transform.scale(
      scale: 1.2,
      child: Switch(
        //trackColor: MaterialStateProperty.all(Colors.black38),
        trackOutlineColor: myTheme.isDark
            ? MaterialStateProperty.all(kPrimaryColor)
            : MaterialStateProperty.all(Colors.white),
        inactiveTrackColor: Color(0xffC7E8FF),
        activeTrackColor: Color(0xff142766),
        activeColor: Colors.green.withOpacity(0.4),
        inactiveThumbColor: Colors.red.withOpacity(0.4),
        // when the switch is on, this image will be displayed
        activeThumbImage: const AssetImage('images/half-moon.png'),
        // when the switch is off, this image will be displayed
        inactiveThumbImage: const AssetImage('images/summer.png'),
        value: myTheme.isDark,

        onChanged: (value) => setState(() {
          //myTheme.isDark = value;
          myTheme.changeTheme(value);
        }),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final picked_File = await picker.pickImage(source: source);

    setState(() {
      imageFile = picked_File;
    });
    Uint8List img = await imageFile!.readAsBytes();
    setState(() {
      image = img;
    });

    saveProfileImage();
  }
}