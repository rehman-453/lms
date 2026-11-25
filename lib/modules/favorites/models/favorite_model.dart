class FavoriteModel {
  final int id;
  final int studentId;
  final int courseId;
  final Map<String, dynamic>? course;

  FavoriteModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.course,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,
      courseId: int.tryParse(json['course_id'].toString()) ?? 0,
      course: json['course'] is Map
          ? Map<String, dynamic>.from(json['course'])
          : null,
    );
  }
}
