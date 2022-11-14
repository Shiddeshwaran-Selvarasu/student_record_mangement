import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({required this.tutorEmail, Key? key}) : super(key: key);

  final String tutorEmail;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _rollNo = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _dept = TextEditingController();
  final TextEditingController _academicYear = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _rollNoError;
  String? _emailError;
  String? _degreeError;
  String? _deptError;
  String? _academicYearError;
  String? _passError;

  bool isLoading = false;

  void _showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.blueAccent,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

  createUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _showToast('UserCreation Failed try again');
    }

    await app.delete();
  }

  storeData() {
    if (_rollNo.value.text.isNotEmpty &&
        _email.value.text.isNotEmpty &&
        _degree.value.text.isNotEmpty &&
        _dept.value.text.isNotEmpty &&
        _academicYear.value.text.isNotEmpty) {
      if (_password.value.text.length >= 8) {
        setState(() {
          isLoading = true;
        });
        Future.delayed(
          const Duration(seconds: 2),
        );
        FirebaseFirestore.instance.doc('/teacher/${widget.tutorEmail}').update({
          'students': FieldValue.arrayUnion([_email.value.text.trim()]),
        });
        FirebaseFirestore.instance
            .collection('/users')
            .doc(_email.value.text.trim())
            .set({
          'name': '-',
          'email': _email.value.text,
          'role': 'student',
        });
        FirebaseFirestore.instance
            .collection('/student')
            .doc(_email.value.text.trim())
            .set({
          'name': '-',
          'email': _email.value.text,
          'rollNo': _rollNo.value.text,
          'degree': _degree.value.text,
          'dept': _dept.value.text,
          'academicYear': _academicYear.value.text,
          'tutorEmail': widget.tutorEmail,
        });
        createUser(_email.value.text, _rollNo.value.text);
        _rollNo.clear();
        _email.clear();
        _showToast('Student created...');
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          _passError = 'Password Should have minimum 8 digits';
        });
        _showToast('Password Should have minimum 8 digits');
      }
    } else {
      _showToast('All fields should have value!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Add Students'),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            IconButton(
              onPressed: () {
                storeData();
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                          left: 25,
                          top: 25,
                          bottom: 10,
                        ),
                        child: TextField(
                          controller: _rollNo,
                          decoration: InputDecoration(
                            hintText: 'Enter Roll No',
                            label: const Text('Roll No'),
                            errorText: _rollNoError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            label: const Text('Email'),
                            errorText: _emailError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _degree,
                          decoration: InputDecoration(
                            hintText: 'Enter Degree',
                            label: const Text('Degree'),
                            errorText: _degreeError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _dept,
                          decoration: InputDecoration(
                            hintText: 'Enter Department',
                            label: const Text('Department'),
                            errorText: _deptError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _academicYear,
                          decoration: InputDecoration(
                            hintText: 'Enter Academic Year',
                            label: const Text('Academic Year'),
                            errorText: _academicYearError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _password,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            label: const Text('Password'),
                            errorText: _passError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
