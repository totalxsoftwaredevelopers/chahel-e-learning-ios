import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MEssageState();
}

class _MEssageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Text(data.data.toString()),
    );
  }
}
