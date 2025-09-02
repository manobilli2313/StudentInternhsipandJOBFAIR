class MySchedule{
  final int companyID;
  final int jobfairID;
  final int studentID;
  final String StudentName;
  final String? room_no;
  final String int_stime;
  final String int_etime;
  final String? regno;
  final String?status;

  MySchedule({required this.companyID,required this.jobfairID,
  required this.studentID, required this.StudentName,this.room_no,
  required this.int_stime,required this.int_etime,
  this.status,
  this.regno
  }); 

  factory MySchedule.fromJson(Map<String,dynamic> json){
    return MySchedule(
    companyID: json['companyID'], 
    jobfairID: json['jobfairID'], 
    studentID: json['studentID'], 
    StudentName: json['StudentName'], 
    int_stime: json['int_stime'], 
    int_etime: json['int_etime'],
    room_no: json['room_no'],
    regno: json['regno'],
    status:json['status']
    );
  }


}