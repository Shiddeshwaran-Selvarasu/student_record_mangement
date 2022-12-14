import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_record_mangement/pages/add_teacher.dart';

import '../model/user_models.dart';
import '../utils/signinprovider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key, required this.user}) : super(key: key);

  final BasicUser user;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  showAlert(var provider, var context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 25,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("Log Out?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: const Text(
            "Are sure you want to log out?",
            style: TextStyle(fontSize: 17),
          ),
          actionsAlignment: MainAxisAlignment.end,
          elevation: 5,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    provider.logout();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showAlertDelete(var student, var context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 25,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("Delete?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: Text(
            "Are sure you want to delete the teacher with email $student ?",
            style: const TextStyle(fontSize: 17),
          ),
          actionsAlignment: MainAxisAlignment.end,
          elevation: 5,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('/users')
                        .doc(student.toString())
                        .delete();
                    FirebaseFirestore.instance
                        .collection('/admin')
                        .doc(widget.user.email)
                        .update({
                      'teachers': FieldValue.arrayRemove([student.toString()]),
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context, listen: false);
    final studentList = FirebaseFirestore.instance
        .collection('/admin')
        .doc('/${widget.user.email}')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showAlert(provider, context);
          },
          icon: const Icon(Icons.logout),
        ),
        title: const Text('Teacher List'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: studentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            LinkedList<StudentEmail> students = LinkedList();
            final list = snapshot.data!.data()!['teachers'];
            for (var ele in list) {
              students.add(
                StudentEmail(
                  email: ele.toString(),
                ),
              );
            }
            return Scrollbar(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(students.elementAt(index).toString()),
                          trailing: IconButton(
                            onPressed: () {
                              showAlertDelete(
                                  students.elementAt(index).toString(),
                                  context);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return const Center(
            child: Text('Something Went Wrong!!'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTeacher(email: widget.user.email)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
