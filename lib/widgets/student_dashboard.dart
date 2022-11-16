import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_record_mangement/model/user_models.dart';
import 'package:student_record_mangement/pages/update_details.dart';

import '../utils/signinprovider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key, required this.user}) : super(key: key);

  final BasicUser user;

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context, listen: false);
    final userMeta = FirebaseFirestore.instance
        .collection('/student')
        .doc(widget.user.email)
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
        title: const Text('Details'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateDetails(email: widget.user.email),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: userMeta,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              var da = snapshot.data!.data()!;

              Student student = Student(
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    showBottomBorder: true,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Property',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(Text('Name')),
                          DataCell(Text(student.name ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Roll No')),
                          DataCell(Text(student.rollNo))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Email')),
                          DataCell(Text(student.email))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Degree')),
                          DataCell(Text(student.degree))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Department')),
                          DataCell(Text(student.dept))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Mobile')),
                          DataCell(Text(student.mobile ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Date Of Birth')),
                          DataCell(
                            Text(student.dateOfBirth ?? "-"),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Year')),
                          DataCell(Text(student.academicYear))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Address')),
                          DataCell(Text(student.address ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Father Name')),
                          DataCell(Text(student.fatherName ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Father Mobile')),
                          DataCell(Text(student.fatherMobile ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Mother Name')),
                          DataCell(Text(student.motherName ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Mother Mobile')),
                          DataCell(Text(student.motherMobile ?? '-'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('Tutor Email')),
                          DataCell(Text(student.tutorEmail))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('Something Went Wrong!'),
            );
          },
        ),
      ),
    );
  }
}

/*
Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(),
                  textBaseline: TextBaseline.alphabetic,
                  defaultColumnWidth: FixedColumnWidth(
                      MediaQuery.of(context).size.width * 0.45),
                  children: [
                    TableRow(
                      children: [
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text('Name'),
                        ),
                        Table,
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(child: Text('Roll No')),
                        TableCell(child: Text(student.rollNo ?? '-')),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Email'),
                        Text(student.email ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Degree'),
                        Text(student.degree ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Department'),
                        Text(student.dept ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Mobile'),
                        Text(student.mobile ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Date Of Birth'),
                        Text(student.dateOfBirth == null
                            ? "-"
                            : student.dateOfBirth!.toDate().toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Year'),
                        Text(student.academicYear ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Address'),
                        Text(student.address ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Father Name'),
                        Text(student.fatherName ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Father Mobile'),
                        Text(student.fatherMobile ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Mother Name'),
                        Text(student.motherName ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Mother Mobile'),
                        Text(student.motherMobile ?? '-'),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text('Tutor Email'),
                        Text(student.tutorEmail ?? '-'),
                      ],
                    ),
                  ],
                )
 */
