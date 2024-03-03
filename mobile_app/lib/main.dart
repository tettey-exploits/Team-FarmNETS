import 'package:flutter/material.dart';
import 'package:test_1/themes/light_mode.dart';
import 'package:test_1/screens/user_chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const UserChatScreen(),
    );
  }
}


