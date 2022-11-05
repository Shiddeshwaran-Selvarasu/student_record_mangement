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
    final provider = Provider.of<EmailSignIn>(context,listen: false);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          provider.logout();
        },
        child: Center(
          child: Text('hai ${user?.email}'),
        ),
      ),
    );
  }
}
