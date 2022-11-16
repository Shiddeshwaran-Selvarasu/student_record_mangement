import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_record_mangement/pages/add_student.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import 'package:open_file/open_file.dart';

import '../model/user_models.dart';
import '../pages/update_details.dart';
import '../utils/signinprovider.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key, required this.user}) : super(key: key);

  final BasicUser user;

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  void _showToast(String text, bool isError) {
    String color = isError ? "#ff3333" : "#4caf50";
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: isError ? Colors.red : Colors.green,
      webBgColor: color,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 25,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(" Delete?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: Text(
            "Are sure you want to delete the student with email $student ?",
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
                        .collection('/teacher')
                        .doc(widget.user.email)
                        .update({
                      'students': FieldValue.arrayRemove([student.toString()]),
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

  generateExcel() async {
    // Create a new Excel Document.
    final xl.Workbook workbook = xl.Workbook();

    // Accessing worksheet via index.
    final xl.Worksheet sheet = workbook.worksheets[0];

    // Set the text value.
    sheet.getRangeByName('A1').setText('S.No');
    sheet.getRangeByName('B1').setText('Roll No');
    sheet.getRangeByName('C1').setText('Name');
    sheet.getRangeByName('D1').setText('Email');
    sheet.getRangeByName('E1').setText('Degree');
    sheet.getRangeByName('F1').setText('Department');
    sheet.getRangeByName('G1').setText('Academic Year');
    sheet.getRangeByName('H1').setText('Date Of Birth');
    sheet.getRangeByName('I1').setText('Address');
    sheet.getRangeByName('J1').setText('Mobile');
    sheet.getRangeByName('K1').setText('Father Name');
    sheet.getRangeByName('K1').setText('Father Mobile');
    sheet.getRangeByName('K1').setText('Mother Name');
    sheet.getRangeByName('K1').setText('Mother Mobile');
    sheet.getRangeByName('L1').setText('Tutor Email');

    _showToast('Generating Excel File', false);

    List<Map<String, dynamic>> totalList = [];
    List<dynamic> idList = [];
    await FirebaseFirestore.instance
        .collection('/teacher')
        .doc(widget.user.email)
        .get()
        .then((value) {
      idList = value.data()!['students'];
    }).whenComplete(() {
      _showToast('Done', false);
    }).onError((error, stackTrace) {
      _showToast(error.toString(), true);
    });

    for (var i in idList) {
      await FirebaseFirestore.instance
          .collection('/student')
          .doc(i)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data()!;
        totalList.add(data);
      });
    }

    for (int i = 0; i < totalList.length; i++) {
      var data = totalList[i];
      sheet.getRangeByName('A${2 + i}').setText('${1 + i}');
      sheet.getRangeByName('B${2 + i}').setText(data['rollNo'] ?? "-");
      sheet.getRangeByName('C${2 + i}').setText(data['name'] ?? "-");
      sheet.getRangeByName('D${2 + i}').setText(data['email'] ?? "-");
      sheet.getRangeByName('E${2 + i}').setText(data['degree'] ?? "-");
      sheet.getRangeByName('F${2 + i}').setText(data['dept'] ?? "-");
      sheet.getRangeByName('G${2 + i}').setText(data['academicYear'] ?? "-");
      sheet.getRangeByName('H${2 + i}').setText(data['dateOfBirth'] ?? "-");
      sheet.getRangeByName('I${2 + i}').setText(data['address'] ?? "-");
      sheet.getRangeByName('J${2 + i}').setText(data['mobile'] ?? "-");
      sheet.getRangeByName('K${2 + i}').setText(data['fatherName'] ?? "-");
      sheet.getRangeByName('K${2 + i}').setText(data['fatherMobile'] ?? "-");
      sheet.getRangeByName('K${2 + i}').setText(data['motherName'] ?? "-");
      sheet.getRangeByName('K${2 + i}').setText(data['motherMobile'] ?? "-");
      sheet.getRangeByName('L${2 + i}').setText(data['tutorEmail'] ?? "-");
    }

    // Save and dispose the document.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Get external storage directory
    final directory = await getExternalStorageDirectory();

    // Get directory path
    final path = directory?.path;

    // Create an empty file to write Excel data
    File file = File("$path/${widget.user.name}'s students.xlsx");

    // Write Excel data
    await file.writeAsBytes(bytes, flush: true);

    // Open the Excel document in mobile
    OpenFile.open("$path/${widget.user.name}'s students.xlsx");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context, listen: false);
    final studentList = FirebaseFirestore.instance
        .collection('/teacher')
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
        title: const Text('Student List'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              generateExcel();
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: studentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              LinkedList<StudentEmail> students = LinkedList();
              final list = snapshot.data!.data()!['students'];
              for (var ele in list) {
                students.add(
                  StudentEmail(
                    email: ele.toString(),
                  ),
                );
              }
              return Scrollbar(
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
                          leading: IconButton(
                            onPressed: () {
                              showAlertDelete(
                                students.elementAt(index).toString(),
                                context,
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDetails(
                                      email:
                                          students.elementAt(index).toString()),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(
              child: Text('Something Went Wrong!!'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudent(tutorEmail: widget.user.email),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
