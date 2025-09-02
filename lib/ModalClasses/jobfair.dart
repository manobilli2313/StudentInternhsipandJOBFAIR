import 'package:flutter/foundation.dart';

class NewJobFair{
  int? id;
  int? year;
  String? venue;
  String? startdate;
  String? enddate;
  String? jobfairdate;
  String? createdate;
  String?status;

  DateTime crdate=DateTime.now();


  NewJobFair({this.id, this.year,this.venue,this.startdate,this.enddate,this.jobfairdate,this.createdate,this.status});
  
  factory NewJobFair.fromJson(Map<String,dynamic> json){
    return NewJobFair(
      id:json['id'],
      year:json['year'],
      venue:json['venue'],
      startdate: json['startDate'],
      enddate: json['endDate'],
      jobfairdate: json['dateOfJobFair'],
      createdate: json['createDate'],
      status: json['status']



    );
  }

  Map<String,dynamic> tomap(){
    return{
      'year':year,
      'venue':venue,
      'startDate':startdate,
      'endDate':enddate,
      'dateOfJobFair':jobfairdate,
      'createDate':createdate,

      



    };
  }


}