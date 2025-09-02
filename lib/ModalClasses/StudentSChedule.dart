import 'package:student_internship_and_jobfair_fyp/StudentScreens/MySchedule.dart';

class StudentInterview {
  int?id;
   int companyID;
   String companyName;
   String intStime;  // Stored as String
   String intEtime;  // Stored as String
   String? roomNo;
   int numInQueue;
   int jid;

  StudentInterview({
    this.id,
    required this.companyID,
    required this.companyName,
    required this.intStime,
    required this.intEtime,
    this.roomNo,
    required this.numInQueue,
    required this.jid,
  });

  // Factory method to create object from JSON
  factory StudentInterview.fromJson(Map<String, dynamic> json) {
    return StudentInterview(
      id:json['id'],
      companyID: json['companyID'],
      companyName: json['CompanyName'],
      intStime: json['int_stime'], // Time(7) stored as String
      intEtime: json['int_etime'], // Time(7) stored as String
      roomNo: json['room_no'],
      numInQueue: json['numinQueue'],
      jid:json['jid']
    );
  }


}
