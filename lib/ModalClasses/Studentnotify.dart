class StudentNotification {
  final int savedStudentId;
  final String companyName;
  final String interviewStartTime;
  final String interviewEndTime;
  final int queueNumber;
  final int sid;
  final int cid;
  final int jid;

  StudentNotification({
    required this.savedStudentId,
    required this.companyName,
    required this.interviewStartTime,
    required this.interviewEndTime,
    required this.queueNumber,
    required this.sid,
    required this.cid,
    required this.jid,
  });

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    return StudentNotification(
      savedStudentId: json['SavedStudentID'],
      companyName: json['CompanyName'],
      interviewStartTime: json['InterviewStartTime'],
      interviewEndTime: json['InterviewEndTime'],
      queueNumber: json['QueueNumber'],
      sid:json['StudentID'],
      cid:json['CompanyID'],
      jid:json['JobFairID']
    );
  }
}
