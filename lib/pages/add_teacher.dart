import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({required this.email, Key? key}) : super(key: key);

  final String email;

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final TextEditingController _staffNo = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _dept = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _staffNoError;
  String? _nameError;
  String? _emailError;
  String? _degreeError;
  String? _deptError;
  String? _mobileError;
  String? _passwordError;

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
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      _showToast('UserCreation Failed try again');
    }

    await app.delete();
  }

  storeData() {
    if (_staffNo.value.text.isNotEmpty &&
        _email.value.text.isNotEmpty &&
        _degree.value.text.isNotEmpty &&
        _dept.value.text.isNotEmpty &&
        _name.value.text.isNotEmpty &&
        _mobile.value.text.isNotEmpty) {
      if(_password.value.text.length >= 8){
        setState(() {
          isLoading = true;
        });
        Future.delayed(
          const Duration(seconds: 2),
        );
        FirebaseFirestore.instance.doc('/admin/${widget.email}').update({
          'teachers': FieldValue.arrayUnion([_email.value.text.trim()]),
        });
        FirebaseFirestore.instance
            .collection('/users')
            .doc(_email.value.text.trim())
            .set({
          'name': _name.value.text,
          'email': _email.value.text,
          'role': 'teacher',
        });
        FirebaseFirestore.instance
            .collection('/teacher')
            .doc(_email.value.text.trim())
            .set({
          'name': _name.value.text,
          'email': _email.value.text,
          'staffNo': _staffNo.value.text,
          'degree': _degree.value.text,
          'dept': _dept.value.text,
          'mobile': _mobile.value.text,
          'students': FieldValue.arrayUnion([]),
        });
        createUser(_email.value.text, _password.value.text);
        _staffNo.clear();
        _email.clear();
        _showToast('Teacher created...');
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          _passwordError = 'Password Should have minimum 8 digits';
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
          title: const Text('Add Teacher'),
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
                          controller: _staffNo,
                          decoration: InputDecoration(
                            hintText: 'Enter Staff No',
                            label: const Text('Staff No'),
                            errorText: _staffNoError,
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
                          controller: _name,
                          decoration: InputDecoration(
                            hintText: 'Enter Name',
                            label: const Text('Name'),
                            errorText: _nameError,
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
                          controller: _mobile,
                          decoration: InputDecoration(
                            hintText: 'Enter Mobile number',
                            label: const Text('Mobile'),
                            errorText: _mobileError,
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
                            errorText: _passwordError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text){
                            if(text.length >= 8){
                             setState(() {
                               _passwordError = null;
                             });
                            } else {
                              _passwordError = 'Password Should have minimum 8 digits';
                            }
                          },
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
