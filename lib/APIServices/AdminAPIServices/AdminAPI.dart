import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AddJobFair.dart';
import 'dart:convert';

import 'package:student_internship_and_jobfair_fyp/ModalClasses/AddSocietyMember.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AssignPassesJF.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Rooms.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/jobfair.dart';
import 'dart:io';
class AdminAPI{
  static String baseurl = 'http://192.168.0.170/SIJBAPI/api/SocietyMember/';

    // dashbord fucntion for admin 

  static Future<http.Response> admindashboard() async{
    try
    {
      String url = '${baseurl}GetDashboardCounts';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }
  }

  // all applied companies for admin

  static Future<http.Response> appliedcopanies() async{
    try
    {
      String url = '${baseurl}Totalappliedcomapnies';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

   

    
  }
   // total applied comapnies by yearly
  static Future<http.Response> appliedcompaniesyearly(int year) async{
    try
    {
      String url = '${baseurl}Totalappliedcomapniesyearly?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

  }

  // get all absent companies in jobfair

  
  static Future<http.Response> absentcompanies() async{
    try
    {
      String url = '${baseurl}GetAbsentCompanies';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

   

    
  }
  // total absent comapnies by yearly
  static Future<http.Response> absentcompaniesyearly(int year) async{
    try
    {
      String url = '${baseurl}GetAbsentCompaniesyearly?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

  }


   // get all applied students in jobfair

  
  static Future<http.Response> appliedstudents() async{
    try
    {
      String url = '${baseurl}TotalAppliedStudents';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

   

    
  }
  // total absent comapnies by yearly
  static Future<http.Response> appliedstudentyearly(int year) async{
    try
    {
      String url = '${baseurl}TotalAppliedStudentsyearly?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

  }


   // get all ashortlisted students in jobfair

  
  static Future<http.Response> shortlistedstudent() async{
    try
    {
      String url = '${baseurl}TotalShortlistedStudents';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

   

    
  }
  // total shortlisted students by yearly
  static Future<http.Response> shortlistedyeaarly(int year) async{
    try
    {
      String url = '${baseurl}TotalShortlistedStudentsyearly?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

  }

   // get all interviewed students in jobfair

  
  static Future<http.Response> interviewedstudents() async{
    try
    {
      String url = '${baseurl}TotalInterviewedStudents';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

   

    
  }
  // total all intervieewed  students by yearly
  static Future<http.Response> interviewedstudentyearly(int year) async{
    try
    {
      String url = '${baseurl}TotalInterviewedStudentsyearly?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e)
    {
      return http.Response('Error: $e', 500);

    }

  }

  // active jpbfair for set passes

  //  Get Active Events for company 

static Future<http.Response> avtivejbfair() async{
  try{
    String url='${baseurl}GetActiveJobFairs';
    var response= await http.get(Uri.parse(url));
    return response;

  }catch(e){
    return http.Response('Error $e', 500);
    

  }
}
// set passes fro jbfair slabs
  static Future<http.Response> setPassSlabs(AssignPassesJF request) async {
    String url='${baseurl}SetPassSlabs';// Replace with your actual endpoint

    final response = await http.post(Uri.parse(url),
      
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    return response;
  }

  // fetch all technolgies to edit or delete 
    static Future<http.Response> fetchrooms() async {
      
    try {
      String url = '${baseurl}GetAlrooms'; 
      final response = await http.get(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }

  // edit existing Rooms
  static Future<http.Response> editroom(int id,String name) async {
    
    try {
        String url = '${baseurl}EditRoom?id=$id&roomname=$name'; 
      final response = await http.post(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }
  static Future<http.Response> addroom(RoomModel modell) async {
     
    try {
       String url = '${baseurl}AddRoom'; 
      var response=await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body:jsonEncode(modell.toMap())
  
      );
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }
}

  
