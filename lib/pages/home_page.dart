import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../utils/signinprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Student Details'),
        actions: [
          IconButton(
            onPressed: () {
              provider.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                child: CircleAvatar(backgroundColor: Colors.green),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20,color: (Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white), ),
                children:  [
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
