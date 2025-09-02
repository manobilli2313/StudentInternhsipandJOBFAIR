import 'package:flutter/foundation.dart';

class Interns{
  final int? companyID;
  final int? studentID;
  final int? resultStatus;
  final int? semester;
  final String? sname;
  final double? scgpa;
  final String?sgender;
  final String? sregno;
  final String? companyname;
  final String? internshipStatus;
  final int? mid;
  final int? providestatus;
  final int?techid;

  Interns({
  this.companyID,
  this.studentID,
  this.resultStatus,
  this.semester,
  this.sname,
  this.scgpa,
  this.sgender,
  this.sregno,
  this.companyname,
  this.internshipStatus,
  this.mid,
  this.techid,
  this.providestatus=0});

  factory Interns.fromJson(Map<String,dynamic> map){
    return Interns(
      companyID: map['companyID'],
      studentID: map['studentID'],
      resultStatus: map['resultStatus'],
      sname:map['s_name'],
      scgpa: map['s_cgpa'],
      semester: map['s_semester'],
      sgender: map['s_gender'],
      sregno:map['s_regno'],
      companyname:map['companyname'],
      internshipStatus:map['InternshipStatus'],
      



      

    );

    

    
  }

  Map<String,dynamic> tomap(){
    return{
      'studentID':studentID,
      'companyID':companyID,
      'societyMemberID':mid,
      'resultStatus':providestatus,
      'technologyID':techid

    };
  }

}

