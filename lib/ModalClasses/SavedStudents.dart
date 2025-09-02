class SavedStudent {
  final int? id;
  final int jobFairId;
  final int studentId;
  final int companyId;

  // Additional fields from JSON
  final String? studentName;
  final double? studentCgpa;
  final String? gender;
  final String? regNo;
  final int? semester;
  final int? year;

  SavedStudent({
    this.id,
    required this.jobFairId,
    required this.studentId,
    required this.companyId,
    this.studentName,
    this.studentCgpa,
    this.gender,
    this.regNo,
    this.semester,
    this.year,
  });

  /// From JSON
  factory SavedStudent.fromJson(Map<String, dynamic> json) {
    return SavedStudent(
      jobFairId: json['JobFairID'] ?? 0,
      studentId: json['StudentID'] ?? 0,
      companyId: json['CompanyID'] ?? 0,
      studentName: json['s_name'],
      studentCgpa: (json['s_cgpa'] as num?)?.toDouble(),
      gender: json['s_gender'],
      regNo: json['s_regno'],
      semester: json['s_semester'],
      year: json['year'],
    );
  }

  /// To JSON (for API sending, only relevant fields)
  Map<String, dynamic> toMap() {
    return {
      'JobFairID': jobFairId,
      'StudentID': studentId,
      'CompanyID': companyId,
    };
  }
}
