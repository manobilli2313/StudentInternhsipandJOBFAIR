class JoinCompany {
  int studentID;
  int companyID;
  int jobFairID;

  JoinCompany({
    required this.studentID,
    required this.companyID,
    required this.jobFairID,
  });

  // Convert JSON to Dart Object
  factory JoinCompany.fromJson(Map<String, dynamic> json) {
    return JoinCompany(
      studentID: json['studentID'],
      companyID: json['companyID'],
      jobFairID: json['JobFairID'],
    );
  }

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'studentID': studentID,
      'companyID': companyID,
      'JobFairID': jobFairID,
    };
  }
}
