import 'instructor.dart';

class Course {
  final int courseId;
  final String courseName;
  final String courseDuration;
  final String courseDescription;
  final Instructor? instructor;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseDuration,
    required this.courseDescription,
    this.instructor,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseName: json['courseName'],
      courseDuration: json['courseDuration'],
      courseDescription: json['courseDescription'],
      instructor: json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'courseDuration': courseDuration,
      'courseDescription': courseDescription,
      'instructor': instructor?.toJson(),
    };
  }
}
