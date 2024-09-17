import 'package:testeur/domain/model/user.dart';

class Student {
  final int studentId;
  final String firstName;
  final String lastName;
  final String level;
  final User? user; 

  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.level,
    this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      level: json['level'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      'level': level,
      'user': user?.toJson(),
    };
  }
}