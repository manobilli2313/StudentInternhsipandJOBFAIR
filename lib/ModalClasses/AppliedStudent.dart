class appliedStudent{
  final int? id;
  final int? companyId;
  final String? companyName;
  final String? studentName;
  final int? jid;

  final int? sid;
  final String?  name;
  final String? regno;
  final int? semester;
  final double? cgpa;
  final String? gender;
  final String? status;
  final String? JobFairStatus;
  final int? year;

  appliedStudent({
    this.studentName,
    this.id,
    this.companyId,
    this.companyName,
    this.jid,
    this.JobFairStatus,
    this.year,

    this.sid,
    this.name,
    this.regno,
    this.semester,
    this.cgpa,
    this.gender,
    this.status
  });

  factory appliedStudent.fromJson(Map<String,dynamic> json){
    return appliedStudent(
      id:json['id'],
      companyId: json['companyID'],
      studentName: json['studentName'],
      
     sid: json['sid'],
     companyName: json['CompanyName'],
     jid: json['jobFairID'],
     JobFairStatus:json['JobFairStatus'],
     year: json['year'],
     
     name: json['s_name'],
     regno: json['s_regno'], 
     semester: json['s_semester'],
     cgpa: json['s_cgpa'],
     gender: json['s_gender'],
     status: json['status']
    );
  }
}