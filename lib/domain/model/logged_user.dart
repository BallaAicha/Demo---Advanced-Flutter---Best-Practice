import 'package:testeur/domain/model/student.dart';
import 'instructor.dart';

class LoggedUser {
  final String userId;
  final List<String> roles;
  final String accessToken;
  final DateTime expirationDate;
  Student? student;
  Instructor? instructor;

  LoggedUser(
      this.userId,
      this.roles,
      this.accessToken,
      this.expirationDate, [
        this.student,
        this.instructor,
      ]);

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'roles': roles,
    'accessToken': accessToken,
    'expirationDate': expirationDate.toIso8601String(),
    'student': student?.toJson(),
    'instructor': instructor?.toJson(),
  };

  factory LoggedUser.fromJson(Map<String, dynamic> json) {
    return LoggedUser(
      json['userId'],
      List<String>.from(json['roles']),
      json['accessToken'],
      DateTime.parse(json['expirationDate']),
      json['student'] != null ? Student.fromJson(json['student']) : null,
      json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
    );
  }

  @override
  String toString() {
    return 'LoggedUser{userId: $userId, roles: $roles, accessToken: $accessToken, expirationDate: $expirationDate, student: $student, instructor: $instructor}';
  }
}