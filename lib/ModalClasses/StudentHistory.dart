class StudentInterviewHistory {
  final int? id;
  final String? name;
  final String? description;
  final String? contact;
  final int? noOfEmployees;
  final int? jobFairId;
  final int? studentId;
  final int? year;
  final String? status;

  StudentInterviewHistory({
    this.id,
    this.name,
    this.description,
    this.contact,
    this.noOfEmployees,
    this.jobFairId,
    this.studentId,
    this.year,
    this.status,
  });

  factory StudentInterviewHistory.fromJson(Map<String, dynamic> json) {
    return StudentInterviewHistory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      contact: json['contact'],
      noOfEmployees: json['no_of_employees'],
      jobFairId: json['jobfairID'],
      studentId: json['studentID'],
      year: json['year'],
      status: json['status'],
    );
  }
}
