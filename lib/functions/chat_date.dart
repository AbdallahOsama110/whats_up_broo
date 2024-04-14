// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget chatDate(BuildContext context, Timestamp date) {
  DateTime timeStamp = DateTime.timestamp();
  timeStamp = date.toDate();
  var messTime = new DateFormat('d/M/yyyy').format(timeStamp).toString();

  final todayDate = DateTime.now();

  final today = DateTime(todayDate.day, todayDate.month, todayDate.year);
  final yesterday =
      DateTime(todayDate.day - 1, todayDate.month, todayDate.year);

  String dateChip = '';

  final aDate = DateTime(timeStamp.day, timeStamp.month, timeStamp.year);

  if (aDate == today) {
    dateChip = 'Today';
  } else if (aDate == yesterday) {
    dateChip = 'Yesterday';
  } else {
    dateChip = messTime;
  }

  return Align(
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Color(0x558AD3D5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              dateChip,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    ),
  );
}
