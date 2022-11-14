import 'dart:collection';
import 'package:flutter/material.dart';

class Student extends LinkedListEntry<Student>{
  final String rollNo;
  String? name;
  final String email;
  final String degree;
  final String dept;
  final String academicYear;
  String? dateOfBirth;
  String? address;
  String? mobile;
  String? fatherName;
  String? motherName;
  String? fatherMobile;
  String? motherMobile;
  final String tutorEmail;

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

  @override
  String toString() {
    return "Roll No: $rollNo\n Name: $name\n Email: $email\n Degree & Department: $degree - $dept\n "
        "Academy Year: $academicYear\n Age: $dateOfBirth\n Address: $address\n Mobile: $mobile\n Tutor: $tutorEmail\n";
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

class StudentEmail extends LinkedListEntry<StudentEmail> {
  final String email;
  StudentEmail({required this.email});

  @override
  String toString() {
    return email;
  }
}

class TextFieldHelper {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  String get text => _controller.value.text;

  TextEditingController get controller => _controller;

  String? get error => _error;

  set error(String? value) {
    _error = value;
  }

  void initialValue(String? value) {
    _controller.text = value ?? "";
  }
}