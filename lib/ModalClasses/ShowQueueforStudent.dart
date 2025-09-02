class QueueInfo {
  final int? studentID;
  final int? jobfairID;
  final String? intStime;
  final String? intEtime;
  final int? numInQueue;
  final String? studentName;

  QueueInfo({
    this.studentID,
    this.jobfairID,
    this.intStime,
    this.intEtime,
    this.numInQueue,
    this.studentName,
  });

  factory QueueInfo.fromJson(Map<String, dynamic> json) {
    return QueueInfo(
      studentID: json['studentID'],
      jobfairID: json['jobfairID'],
      intStime: json['int_stime'],
      intEtime: json['int_etime'],
      numInQueue: json['numinQueue'],
      studentName: json['StudentName'],
    );
  }


}
