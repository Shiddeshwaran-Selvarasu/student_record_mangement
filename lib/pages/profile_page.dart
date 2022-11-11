import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: CircleAvatar(backgroundColor: Colors.green),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: (Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
                ),
                children: [
                  const TextSpan(
                    text: "Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: user!.email,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
