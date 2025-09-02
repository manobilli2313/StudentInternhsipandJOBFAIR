class ApplyToInternship {
  final int studentId;
  final int? requestId;
  final List<int> technologies;

  ApplyToInternship({
    required this.studentId,
    this.requestId,
    required this.technologies,
  });

  factory ApplyToInternship.fromJson(Map<String, dynamic> json) {
    return ApplyToInternship(
      studentId: json['studentID'],
      requestId: json['requestID'],
      technologies: List<int>.from(json['Technologies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentId,
      
      'Technologies': technologies,
    };
  }
}
