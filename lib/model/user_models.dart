class Student {
  final String rollNo;
  final String name;
  final String email;
  final String degree;
  final String dept;
  final String academicYear;
  final DateTime dateOfBirth;
  final String address;
  final String mobile;
  final String fatherName;
  final String motherName;
  final String fatherMobile;
  final String motherMobile;
  final String tutor;

  Student.name(
    this.rollNo,
    this.name,
    this.email,
    this.degree,
    this.dept,
    this.academicYear,
    this.dateOfBirth,
    this.address,
    this.mobile,
    this.fatherName,
    this.motherName,
    this.fatherMobile,
    this.motherMobile,
    this.tutor,
  );

  int getAge() {
    return (DateTime.now().year - dateOfBirth.year);
  }

  @override
  String toString() {
    return "Roll No: $rollNo\n Name: $name\n Email: $email\n Degree & Department: $degree - $dept\n "
        "Academy Year: $academicYear\n Age: ${getAge()}\n Address: $address\n Mobile: $mobile\n Tutor: $tutor\n";
  }
}
