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
  final List<String> subjects;
}
