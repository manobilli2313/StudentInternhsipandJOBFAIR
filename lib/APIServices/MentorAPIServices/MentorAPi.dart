import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AddJobFair.dart';
import 'dart:convert';

import 'package:student_internship_and_jobfair_fyp/ModalClasses/AddSocietyMember.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/jobfair.dart';
class MemberApi{
  static String baseurl = 'http://192.168.0.170/SIJBAPI/api/SocietyMember/';


  static Future<http.Response> getappliedstudent() async{
    try{
      String url = '${baseurl}AllStudents';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  static Future<http.Response> studentsearching(String regno)async {
    try{
      String url='${baseurl}Searchstudent?regno=$regno';
      final response= await http.get(Uri.parse(url));
      return response;
      

    }catch(e){
      return http.Response('Error: $e', 500);
    }
  }

  // deactvate student status

  static Future<bool> deactivatestudent(int id) async {
    try {
      String url = '${baseurl}DeactivateStudent?id=$id';

      var response = await http.post(
        Uri.parse(url),
         // Sending ID in the request body
      );

      print('Deactivate Student Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  /// Accept Company - Now using POST
  static Future<http.Response> acceptcompany(int cid) async {
    try {
      String url = '${baseurl}AcceptCompany?id=$cid';

      var response = await http.post(
        Uri.parse(url),
         // Sending Company ID
      );

      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  /// Reject Company - Now using POST
  static Future<http.Response> rejectcompany(int cid) async {
    try {
      String url = '${baseurl}RejectCompany?id=$cid';

      var response = await http.post(
        Uri.parse(url),
      // Sending Company ID
      );

      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }
  static Future<http.Response> pendingrequest()async{
    try{
      String url='${baseurl}Pendingcompanies';

      var response = await http.get(Uri.parse(url));
      return response;

    }catch(e){
      return  http.Response('Error: $e', 500);

    }
  }

  // company pending jobfair request
  static Future<http.Response> companyjobfairrequest() async{
    try{
      String url = '${baseurl}GetPendingRequestsJF';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  static Future<http.Response> acceptcompanyjbrequest(int cid) async {
    try {
      String url = '${baseurl}AcceptRequest?rid=$cid';

      var response = await http.post(
        Uri.parse(url),
         // Sending Company ID
      );

      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

   static Future<http.Response> rejectcompanyjbrequest(int cid) async {
    try {
      String url = '${baseurl}AcceptRequest?rid=$cid';

      var response = await http.post(
        Uri.parse(url),
         // Sending Company ID
      );

      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  static Future<http.Response> addmember(Mentor mentor)async{
    try{
      String url = '${baseurl}Addsm';
      var response=await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
         body:jsonEncode(mentor.toMap())
  
      );
      return response;

    }catch(e){
      return http.Response('Error $e', 500);

    }
  }

  static Future<http.Response> Allmentors()async{
    try{
      String url = '${baseurl}Allsm';
      var response=await http.get(Uri.parse(url),);
      return response;

    }catch(e){
      return http.Response('Error $e', 500);

    }
  }

  // fetch all technolgies to edit or delete 
    static Future<http.Response> fetchTechnology() async {
      
    try {
      String url = '${baseurl}Alltechnologies'; 
      final response = await http.get(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }

  // delete technology
   static Future<http.Response> deletetechnology(int id) async {
      
    try {
      String url = '${baseurl}DeleteTechnology?id=$id'; 
      final response = await http.post(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }

// edit existing technologies
  static Future<http.Response> edittechnology(int id,String name) async {
    
    try {
        String url = '${baseurl}EditTechnology?id=$id&techname=$name'; 
      final response = await http.post(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }
  static Future<http.Response> addtechnology(Addtechnology modell) async {
     
    try {
       String url = '${baseurl}AddTechnology'; 
      var response=await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body:jsonEncode(modell.tomap())
  
      );
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }

  // fetch hortlisted student latest compleetd 
  static Future<http.Response> getshortlistedstu()async{
    try{
      String url='${baseurl}GetLatestJobFairShortlistedStudents';

      var response=await http.get(Uri.parse(url));
      return response;

    }catch(e){
      return http.Response('Error $e', 500);
    }
  }

  // search by year shortlist students
  static Future<http.Response> searchshortlistyear(int year) async {
      
    try {
      String url = '${baseurl}GetShortlistedStudentsByYear?year=$year'; 
      final response = await http.get(Uri.parse(url));
      return response;

     
    } catch (e) {
      return http.Response('Error $e',500);
    }
  }
  

// all applied companies for jobfair 
  static Future<http.Response> allappliedcompany() async{
    try{
      String url = '${baseurl}AppliedCompanies';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // deactivate company account 

  static Future<bool> deactivatecompany(int id) async {
    try {
      String url = '${baseurl}deactivateRequest?cid=$id';

      var response = await http.post(
        Uri.parse(url),
         // Sending ID in the request body
      );

      print('Deactivate Student Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // search specifci ccompany for deactivated the account 

  static Future<http.Response> searchspecificcomapny(String name)async {
    try{
      String url='${baseurl}searchCompanies?name=$name';
      final response= await http.get(Uri.parse(url));
      return response;
      

    }catch(e){
      return http.Response('Error: $e', 500);
    }
  }

 

  // all banned student for mentor

  static Future<http.Response> Allbannedstudents() async{
    try{
      String url = '${baseurl}Allbannedstudents';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }
// search banned students

 static Future<http.Response> studentbanned(String regno)async {
    try{
      String url='${baseurl}Searchstudent?regno=$regno';
      final response= await http.get(Uri.parse(url));
      return response;
      

    }catch(e){
      return http.Response('Error: $e', 500);
    }
  }


  //unbanned student from banned status 
  static Future<bool> activatestudent(int id) async {
    try {
      String url = '${baseurl}ActivateStudent?id=$id';

      var response = await http.post(
        Uri.parse(url),
         // Sending ID in the request body
      );

      print('Deactivate Student Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


  // Assign Rooms to each company for jobfair




  static Future<Map<String, dynamic>> getAvailableRoomsAndCompanies() async {
    try {
      String url='${baseurl}GetAvailableRoomsAndCompanies';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<bool> assignRoomToCompany(int companyId, int roomId) async {
    try {
      String url='${baseurl}AssignRoomToCompany?companyID=$companyId&roomID=$roomId';
      final response = await http.post(
        Uri.parse(url),
       
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to assign room. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning room: $e');
    }
  }

  // add new jobafir

  static Future<http.Response> addjobfair(NewJobFair jf)async{
    try{
      String url='${baseurl}AddJobFair';

      var response=await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
        body:jsonEncode(jf.tomap())
      
      );
      return response;

    }catch(e){
      return http.Response('Error $e', 500);
    }

  }

  // fetch allpending internship request from comany side
  static Future<http.Response> peninginternrequest() async{
    try{
      String url = '${baseurl}GetAllInternRequests';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // search eligible interns forcompany request 

  static Future<http.Response> searcheligibleinterne(int rid)async {
    try{
      String url='${baseurl}SearchEligibleStudentsForInternship?requestId=$rid';
      final response= await http.get(Uri.parse(url));
      return response;
      

    }catch(e){
      return http.Response('Error: $e', 500);
    }
  }

  // provide interns to copany 
   static Future<http.Response> provideintern(Interns intern)async{
    try{
      String url='${baseurl}ProvideIntern';

      var response=await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
        body:jsonEncode(intern.tomap())
      
      );
      return response;

    }catch(e){
      return http.Response('Error $e', 500);
    }

  }

  // get all interns for society member

   static Future<http.Response> allinterns() async{
    try{
      String url = '${baseurl}GetAllInterns';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // allintern feedback 

  static Future<http.Response> allinternsfeedback() async{
    try{
      String url = '${baseurl}GetAllInternFeedbacks';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // all student jobfair feedbacks 

  static Future<http.Response> studentfeedbackk() async{
    try{
      String url = '${baseurl}GetLatestStutentFeeedback';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // student feedback by  regno 

   static Future<http.Response> studentfeedbackkbtregno(String regno) async{
    try{
      String url = '${baseurl}GetStudentFeedbackByRegNo?reNo=$regno';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

   static Future<http.Response> eventfedback() async{
    try{
      String url = '${baseurl}GetLatestJobFairFeedbacks';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  // student feedback by  regno 

   static Future<http.Response> eventfeedbackkbyear(String year) async{
    try{
      String url = '${baseurl}GetJobFairFeedbacksByYear?year=$year';
      final response= await http.get(Uri.parse(url));
      return response;

    }catch(e){
       return http.Response('Error: $e', 500);

    }
  }

  
}

// 



