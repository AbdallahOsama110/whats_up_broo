import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/message.dart';
import '../core/const/const.dart';
import '../functions/chat_date.dart';
import '../provider/myTheme.dart';
import '../widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/logout_icon_button.dart';
import '../widgets/send_textField.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  final String? id;

  ChatScreen({super.key, required this.id});

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  var sendController = TextEditingController();
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var myTheme = Provider.of<MyTheme>(context);
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kTimeCreate, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJason(snapshot.data!.docs[i]));
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                ),
                centerTitle: true,
                title: const Text(
                  'WhatsUpBroo',
                ),
                actions: const [
                  LogoutIconButton(),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        var msDate = messagesList[index].timeCreate.toDate();

                        if (DateTime(msDate.day, msDate.month, msDate.year) ==
                            DateTime(DateTime.now().day, DateTime.now().month,
                                DateTime.now().year)) {
                          return messagesList[index].id == id
                              ? SenderBubble(message: messagesList[index])
                              : OthersBubble(message: messagesList[index]);
                        } else {
                          return Column(
                            children: [
                              chatDate(context, messagesList[index].timeCreate),
                              messagesList[index].id == id
                                  ? SenderBubble(message: messagesList[index])
                                  : OthersBubble(message: messagesList[index])
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  sendTextField(
                      sendController, size, myTheme, context, sendMessages),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                ),
              ),
              centerTitle: true,
              title: const Text(
                'WhatsUpBroo',
                style: TextStyle(color: Colors.white),
              ),
              actions: const [
                LogoutIconButton(),
              ],
            ),
            body: Center(
                child: Text(
              'Loding...',
              style: Theme.of(context).textTheme.headlineLarge,
            )),
          );
        }
      },
    );
  }

  void sendMessages(BuildContext context, String data) {
    if (data.isNotEmpty) {
      messages.add({
        kMessage: data,
        kTimeCreate: DateTime.now(),
        'senderId': id,
      });
      sendController.clear();
      scrollController.animateTo(0,
          duration: const Duration(seconds: 1), curve: Curves.easeIn);
    }
  }
}
