class Subject {
  Subject({required this.subjects});

  factory Subject.fromJson(Map<String, dynamic> json) {
    final subjectsMap = json['subjects'] != null
        ? Map<String, dynamic>.from(json['subjects'] as Map<String, dynamic>)
        : <String, dynamic>{};
    return Subject(
      subjects: subjectsMap.values.map((e) => e.toString()).toList(),
    );
  }

  static Map<String, dynamic> toMap(String subject) {
    return {
      'name': subject,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  final List<String> subjects;
}
