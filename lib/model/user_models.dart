import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Student extends LinkedListEntry<Student>{
  final String rollNo;
  final String? name;
  final String email;
  final String degree;
  final String dept;
  final String academicYear;
  final Timestamp? dateOfBirth;
  final String? address;
  final String? mobile;
  final String? fatherName;
  final String? motherName;
  final String? fatherMobile;
  final String? motherMobile;
  final String tutorEmail;

  // Student({
  //   required this.rollNo,
  //   required this.name,
  //   required this.email,
  //   required this.degree,
  //   required this.dept,
  //   required this.academicYear,
  //   required this.dateOfBirth,
  //   required this.address,
  //   required this.mobile,
  //   required this.fatherName,
  //   required this.motherName,
  //   required this.fatherMobile,
  //   required this.motherMobile,
  //   required this.tutorEmail,
  // });

  Student({
    required this.rollNo,
    this.name,
    required this.email,
    required this.degree,
    required this.dept,
    required this.academicYear,
    this.dateOfBirth,
    this.address,
    this.mobile,
    this.fatherName,
    this.motherName,
    this.fatherMobile,
    this.motherMobile,
    required this.tutorEmail,
  });

  int getAge() {
    return dateOfBirth == null ? -1 : (DateTime.now().year - dateOfBirth!.toDate().year);
  }

  @override
  String toString() {
    return "Roll No: $rollNo\n Name: $name\n Email: $email\n Degree & Department: $degree - $dept\n "
        "Academy Year: $academicYear\n Age: ${getAge()}\n Address: $address\n Mobile: $mobile\n Tutor: $tutorEmail\n";
  }
}

class BasicUser {
  final String name;
  final String email;
  final String role;

  BasicUser({
    required this.name,
    required this.email,
    required this.role,
  });
}

class Admin {
  final String name;
  final String email;
  final List<String> teachers;

  Admin({
    required this.name,
    required this.email,
    required this.teachers,
  });
}

class Tutor {
  final String staffNo;
  final String name;
  final String email;
  final String degree;
  final String dept;
  final String mobile;
  final List<String> students;

  Tutor({
    required this.staffNo,
    required this.name,
    required this.email,
    required this.degree,
    required this.dept,
    required this.mobile,
    required this.students,
  });
}
