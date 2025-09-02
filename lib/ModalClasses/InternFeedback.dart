class SubmitInternsFeedback {
  final int companyID;
  final int studentID;
  final DateTime? joiningDate;
  final DateTime? endingDate;
  final int? communicationRating;
  final int? skillsRating;
  final String? resultRemarks;
  final String? companyname;
  final String? studentname;

  SubmitInternsFeedback({
    required this.companyID,
    required this.studentID,
    this.joiningDate,
    this.endingDate,
    this.communicationRating,
    this.skillsRating,
    this.resultRemarks,
    this.companyname,
    this.studentname
  });

  Map<String, dynamic> tomap() {
    return {
      'companyID': companyID,
      'studentID': studentID,
      'joiningDate': joiningDate?.toIso8601String(),
      'endingDate': endingDate?.toIso8601String(),
      'communicationRating': communicationRating,
      'skillsRating': skillsRating,
      'resultRemarks': resultRemarks,
    };
  }

  factory SubmitInternsFeedback.fromJson(Map<String, dynamic> json) {
    return SubmitInternsFeedback(
      companyID: json['companyID'],
      studentID: json['studentID'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
      endingDate: json['endingDate'] != null
          ? DateTime.parse(json['endingDate'])
          : null,
      communicationRating: json['communicationRating'],
      skillsRating: json['skillsRating'],
      resultRemarks: json['resultRemarks'],
      companyname: json['CompanyName'],
      studentname: json['StudentName']
      
    );
  }
}
