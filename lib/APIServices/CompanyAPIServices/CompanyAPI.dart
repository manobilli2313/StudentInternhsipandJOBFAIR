
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJobRequest.dart';
import 'dart:convert';

import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanySignUp.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Conductinginterview.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Event.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternFeedback.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/studentFeedback.dart';
class CompanyApiServices{



  static String baseurl = 'http://192.168.0.170/SIJBAPI/api/Company/';
  static String basicurl='http://192.168.0.170/SIJBAPI/api/FinalTask/';

   // Login API
 

static Future<bool> companysignup(SignupCompanyModel model) async {
  String url = '${baseurl}SignupCompany'; // Corrected URL
  
  final response = await http.post(Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  body:jsonEncode(model.toJson())
  );

   return response.statusCode == 200; // Return the full HTTP response
}

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

//submit request for jobfair from company side ok 

static Future<http.Response> submitrequest(jbRequest request)async{
  try{
    String url='${baseurl}CreateJobRequestWithTechnologies';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.tomap()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

// Get schule of a company for jobfair 

static Future<http.Response> fetchcompanyschedule(int companyID) async {
  String url = '${baseurl}GetCompanySchedule?companyID=$companyID';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// conduct interview and eveluation

static Future<http.Response> interviewconduct(ShortlistStudent student)async{
  try{
    String url='${baseurl}conductInterview';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(student.toJson()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

// submit student feedback to mentor from company side

static Future<http.Response> submitstudentfeedback(StudentFeedbackJB feedback)async{
  try{
    String url='${baseurl}StudentFeedback';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(feedback.toMap()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}


// process next student to interview for copany in kine
// static Future<http.Response> nextstudent(JoinCompany request)async{
//   try{
//     String url='${baseurl}ProcessNextInterviewss';
//     var response=await http.post(Uri.parse(url),
//     headers: {"Content-Type":"application/json"},
//     body: jsonEncode(request.toJson()),
//     );
//     return response;
  

//   }catch(e){
//     return http.Response('Error $e', 500);

//   }
// }

static Future<http.Response> nextstudent(JoinCompany request)async{
  try{
    String url='${baseurl}ProcessNextInterview';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.toJson()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

// internsrequest with technoogy and no of interns 

static Future<http.Response> internrequest(InternsWithTechnologies request)async{
  try{
    String url='${baseurl}CreateInternRequest';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.toJson()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

// shortlisted student for company
 // fetch hortlisted student latest compleetd 
  static Future<http.Response> Companyshortlistedstudent(int cid)async{
    try{
      String url='${baseurl}GetLatestShortlistedStudents?companyId=$cid';

      var response=await http.get(Uri.parse(url));
      return response;

    }catch(e){
      return http.Response('Error $e', 500);
    }
  }

  // shortlisted student for comny by year

    static Future<http.Response> Companyshortlistedstudentbyyear(int cid,int year)async{
    try{
      String url='${baseurl}GetLatestShortlistedStudentsbyyear?companyId=$cid&year=$year';

      var response=await http.get(Uri.parse(url));
      return response;

    }catch(e){
      return http.Response('Error $e', 500);
    }
  }

  // fetch all interns pending compaleted faild pased for company according to his own id 

  static Future<http.Response> fetchcompanyinterns(int companyID) async {
  String url = '${baseurl}GetCompanyInterns?companyId=$companyID';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// submit each inter feedback to mentor

static Future<http.Response> internrequessubmit(SubmitInternsFeedback request)async{
  try{
    String url='${baseurl}SubmitInternFeedback';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.tomap()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

//get student pptx


static Future<http.Response> getstudentpptx() async{
  try{
    String url='${baseurl}GetStudentPPT';
    var response= await http.get(Uri.parse(url));
    return response;

  }catch(e){
    return http.Response('Error $e', 500);
    

  }
}

// saved student after show his ppt for further final interview etc

static Future<http.Response> savedstudent(SavedStudent request)async{
  try{
    String url='${baseurl}SaveStudent';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.toMap()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}
 // fetch saved students from savedstudent table 

 
static Future<http.Response> fetchsavedstudent(int cid) async {
  String url = '${baseurl}GetsavedStuent?cid=$cid';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// fethcn length of active jobfair for badges notification 

 
static Future<http.Response> fetchactivejobfairlength() async {
  String url = '${baseurl}GetActiveJobFairslength';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// fucntion for notifiactio popup msg if copany not applied 

static Future<http.Response> fetchactivejobfairnotification(int companyId) async {
  String url = '${baseurl}CheckActiveJobFairRequest?companyId=$companyId';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// fetch group students 
static Future<http.Response>fetcgroupstudentposter() async {
  String url = '${baseurl}GetAppliedGroupPostersForActiveJobFairs';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// task start frim here 

// fetch group students images posterimages
static Future<http.Response>fetcgroupstudentposterimages() async {
  String url = '${baseurl}GetAppliedGroupPostersForActiveJobFairs';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}
// store EVentfeedback


static Future<http.Response> EventFeedbackcomp(Eventfeedbackcompany request)async{
  try{
    String url='${baseurl}StoreEventFeedback';
    var response=await http.post(Uri.parse(url),
    headers: {"Content-Type":"application/json"},
    body: jsonEncode(request.toMap()),
    );
    return response;
  

  }catch(e){
    return http.Response('Error $e', 500);

  }
}

// ftech on bas eof fyp technology search specific student 

static Future<http.Response>fetchstudentfypbase(String tecname,int cid) async {
  String url = '${basicurl}GetStudentsByFypTechnologyNotAppliedToCompany?technology=$tecname&companyId=$cid';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// serach in base of student skills technology

static Future<http.Response>fetchstudentskillstablebase(int cid,String techname)async {
  String url = '${basicurl}SearchStudentsByTechnology?companyId=$cid&technology=$techname';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// search n bas eof fyptitle and technogy both fypptitle fyptechnology
static Future<http.Response>fetchstudentfypandtechnologybase(String tecname,int cid,String project) async {
  String url = '${basicurl}SearchStudentsByProjectNameAndTechnology?technology=$tecname&companyId=$cid&projectKeyword=$project';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// search only on base of project title 

static Future<http.Response>fetchstudenttitlebasefyp(int cid,String title,) async {
  String url = '${basicurl}SearchStudentsByProjecttitle?companyId=$cid&projectKeyword=$title';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// search studnet on studentskill stable title base
// search n bas eof fyptitle and technogy both 
static Future<http.Response>SearchStudentsByTechnologytitle(String tecname,int cid,String project) async {
  String url = '${basicurl}SearchStudentsByTechnologyAndProjectName?technology=$tecname&companyId=$cid&projectKeyword=$project';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}















// Extra TAsk Material 


static Future<http.Response>AbsentStudent(int sid,int cid,int jid) async {
  String url = '${basicurl}HandleAbsentStudent?studentId=$sid&companyId=$cid&jobFairId=$jid';
  try {
    final response = await http.post(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}


// start break for company

static Future<http.Response>Startbreak(int cid) async {
  String url = '${basicurl}StartBreak?companyID=$cid';
  try {
    final response = await http.post(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// end break for company

static Future<http.Response>endbreak(int cid) async {
  String url = '${basicurl}ContinueAfterBreak?companyID=$cid';
  try {
    final response = await http.post(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}















}