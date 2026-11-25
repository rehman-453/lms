class CourseDetailsModel {
  final int id;
  final int categoryId;
  final int instructorId;
  final String title;
  final String slug;
  final String shortDescription;
  final String description;
  final String? thumbnail;
  final String level;
  final String language;
  final String price;
  final String? discountPrice;
  final String currency;
  final int durationMinutes;
  final bool isFeatured;
  final CourseCategory? category;
  final CourseInstructor? instructor;
  final List<CourseSection> sections;

  CourseDetailsModel({
    required this.id,
    required this.categoryId,
    required this.instructorId,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.description,
    this.thumbnail,
    required this.level,
    required this.language,
    required this.price,
    this.discountPrice,
    required this.currency,
    required this.durationMinutes,
    required this.isFeatured,
    this.category,
    this.instructor,
    required this.sections,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id']),
      instructorId: _toInt(json['instructor_id']),
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      level: json['level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
      discountPrice: json['discount_price']?.toString(),
      currency: json['currency']?.toString() ?? 'PKR',
      durationMinutes: _toInt(json['duration_minutes']),
      isFeatured: json['is_featured'] == true,
      category: json['category'] is Map
          ? CourseCategory.fromJson(Map<String, dynamic>.from(json['category']))
          : null,
      instructor: json['instructor'] is Map
          ? CourseInstructor.fromJson(
              Map<String, dynamic>.from(json['instructor']),
            )
          : null,
      sections: (json['sections'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => CourseSection.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class CourseCategory {
  final int id;
  final String name;
  final String slug;

  CourseCategory({required this.id, required this.name, required this.slug});

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class CourseInstructor {
  final int id;
  final String name;
  final String? profileImage;
  final String? bio;
  final String? qualification;
  final String? specialization;

  CourseInstructor({
    required this.id,
    required this.name,
    this.profileImage,
    this.bio,
    this.qualification,
    this.specialization,
  });

  factory CourseInstructor.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};

    return CourseInstructor(
      id: _toInt(json['id']),
      name: user['name']?.toString() ?? 'Instructor',
      profileImage: json['profile_image']?.toString(),
      bio: json['bio']?.toString(),
      qualification: json['qualification']?.toString(),
      specialization: json['specialization']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class CourseSection {
  final int id;
  final String title;
  final String description;
  final int sortOrder;
  final List<CourseLesson> lessons;

  CourseSection({
    required this.id,
    required this.title,
    required this.description,
    required this.sortOrder,
    required this.lessons,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sortOrder: _toInt(json['sort_order']),
      lessons: (json['lessons'] as List? ?? [])
          .whereType<Map>()
          .map((item) => CourseLesson.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class CourseLesson {
  final int id;
  final int courseSectionId;
  final String title;
  final String slug;
  final String type;
  final String description;
  final String? content;
  final String? videoUrl;
  final int videoDurationSeconds;
  final bool isPreview;
  final bool isPublished;
  final int sortOrder;

  CourseLesson({
    required this.id,
    required this.courseSectionId,
    required this.title,
    required this.slug,
    required this.type,
    required this.description,
    this.content,
    this.videoUrl,
    required this.videoDurationSeconds,
    required this.isPreview,
    required this.isPublished,
    required this.sortOrder,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: _toInt(json['id']),
      courseSectionId: _toInt(json['course_section_id']),
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString(),
      videoUrl: json['video_url']?.toString(),
      videoDurationSeconds: _toInt(json['video_duration_seconds']),
      isPreview: json['is_preview'] == true,
      isPublished: json['is_published'] == true,
      sortOrder: _toInt(json['sort_order']),
    );
  }

  String get formattedDuration {
    final minutes = videoDurationSeconds ~/ 60;
    final seconds = videoDurationSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
