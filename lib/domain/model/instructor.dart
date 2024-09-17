import 'package:testeur/domain/model/user.dart';

class Instructor {
  final int instructorId;
  final String firstName;
  final String lastName;
  final String summary;
  final User? user; // Changed to User? to handle null values

  Instructor({
    required this.instructorId,
    required this.firstName,
    required this.lastName,
    required this.summary,
    this.user,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      instructorId: json['instructorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      summary: json['summary'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instructorId': instructorId,
      'firstName': firstName,
      'lastName': lastName,
      'summary': summary,
      'user': user?.toJson(),
    };
  }
}
