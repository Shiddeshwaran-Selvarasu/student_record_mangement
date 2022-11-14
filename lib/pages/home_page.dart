import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_record_mangement/model/user_models.dart';
import 'package:student_record_mangement/widgets/student_dashboard.dart';
import 'package:student_record_mangement/widgets/teacher_dashboard.dart';

import '../widgets/admin_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userStream = FirebaseFirestore.instance.collection('/users').doc(user!.email).snapshots();
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          String role = snapshot.data?.data()!['role'];
          BasicUser user = BasicUser(
              name: snapshot.data?.data()!['name'],
              email: snapshot.data?.data()!['email'],
              role: role);
          if (role == 'admin') {
            return AdminDashboard(user: user);
          } else if (role == 'teacher') {
            return TeacherDashboard(user: user);
          } else {
            return StudentDashboard(user: user);
          }
        }

        return const Center(
          child: Text('Something Went Wrong!'),
        );
      },
    );
  }
}
