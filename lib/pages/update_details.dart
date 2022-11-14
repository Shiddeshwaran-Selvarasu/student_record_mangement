import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_record_mangement/model/user_models.dart';

class UpdateDetails extends StatefulWidget {
  const UpdateDetails({required this.email, Key? key}) : super(key: key);

  final String email;

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  late Student student;
  TextFieldHelper name = TextFieldHelper();
  TextFieldHelper mobile = TextFieldHelper();
  TextFieldHelper dob = TextFieldHelper();
  TextFieldHelper address = TextFieldHelper();
  TextFieldHelper fatherName = TextFieldHelper();
  TextFieldHelper fatherMobile = TextFieldHelper();
  TextFieldHelper motherName = TextFieldHelper();
  TextFieldHelper motherMobile = TextFieldHelper();

  @override
  void initState() {
    FirebaseFirestore.instance.collection('/student').doc(widget.email).get().then((value) {
      final da = value.data()!;
      Student temp = Student(
        rollNo: da['rollNo'],
        name: da['name'],
        email: da['email'],
        degree: da['degree'],
        dept: da['dept'],
        academicYear: da['academicYear'],
        dateOfBirth: da['dateOfBirth'],
        address: da['address'],
        mobile: da['mobile'],
        fatherName: da['fatherName'],
        motherName: da['motherName'],
        fatherMobile: da['fatherMobile'],
        motherMobile: da['motherMobile'],
        tutorEmail: da['tutorEmail'],
      );
      student = temp;
    }).whenComplete((){
      setInitialValue();
    });
    super.initState();
  }

  void _showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.blueAccent,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

  updateValues(){
    FirebaseFirestore.instance.collection('/student').doc(widget.email).update({
      'name' : name.text,
      'mobile' : mobile.text,
      'dateOfBirth' : dob.text,
      'address' : address.text,
      'fatherName' : fatherName.text,
      'fatherMobile' : fatherMobile.text,
      'motherName' : motherName.text,
      'motherMobile' : motherMobile.text,
    }).whenComplete((){
      _showToast('Details Updated...');
    });
  }

  setInitialValue(){
    setState(() {
      name.initialValue(student.name);
      mobile.initialValue(student.mobile);
      dob.initialValue(student.dateOfBirth);
      address.initialValue(student.address);
      fatherName.initialValue(student.fatherName);
      fatherMobile.initialValue(student.fatherMobile);
      motherName.initialValue(student.motherName);
      motherMobile.initialValue(student.motherMobile);
    });
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
            title: Text(widget.email),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            actions: [
              IconButton(
                onPressed: () {
                  updateValues();
                },
                icon: const Icon(Icons.done),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                    controller: name.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: name.error,
                      hintText: 'Enter Name',
                      label: const Text('Name'),
                    ),
                    onChanged: (text){
                      student.name = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: mobile.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: mobile.error,
                      hintText: 'Enter Mobile',
                      label: const Text('Mobile'),
                    ),
                    onChanged: (text){
                      student.mobile = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: dob.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: dob.error,
                      hintText: 'Enter Date of Birth in DD-MM-YYYY format',
                      label: const Text('Date Of Birth'),
                    ),
                    onChanged: (text){
                      student.dateOfBirth = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: address.controller,
                    minLines: 2,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: address.error,
                      hintText: 'Enter address',
                      label: const Text('Address'),
                    ),
                    onChanged: (text){
                      student.address = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: fatherName.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: fatherName.error,
                      hintText: 'Enter Father Name',
                      label: const Text('Father Name'),
                    ),
                    onChanged: (text){
                      student.fatherName = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: fatherMobile.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: fatherMobile.error,
                      hintText: 'Enter Father Mobile',
                      label: const Text('Father Mobile'),
                    ),
                    onChanged: (text){
                      student.fatherName = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: motherName.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: motherName.error,
                      hintText: 'Enter Mother Name',
                      label: const Text('Mother Name'),
                    ),
                    onChanged: (text){
                      student.motherName = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: TextField(
                    controller: motherMobile.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: motherMobile.error,
                      hintText: 'Enter Mother Mobile',
                      label: const Text('Mother Mobile'),
                    ),
                    onChanged: (text){
                      student.motherMobile = text;
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
