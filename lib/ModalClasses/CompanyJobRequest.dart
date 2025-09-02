import 'dart:convert';

class jbRequest{
  final int?rid;
  final int cid,jid,noOfInterviewers,slotTime;
  final String? arrivaltime,leavetime;
  final String status;
  List<int> selectedTechnologies;

  jbRequest
  ({
    this.rid,
    required this.cid,
    required this.jid,
    required this.noOfInterviewers,
    required this.slotTime,
    required this.selectedTechnologies,
    this.arrivaltime,
    this.leavetime,
    
    this.status='Pending'});

    Map<String,dynamic> tomap(){
      return{
        'cid':cid,
        'jid':jid,
        'Status':status,
        'arrivalTime':arrivaltime,
        'leaveTime':leavetime,
        'noOfInterviewers':noOfInterviewers,
        'slotTime':slotTime,
        'Technologies':selectedTechnologies

      };
    }



}