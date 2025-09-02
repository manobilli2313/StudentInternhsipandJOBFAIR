import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternshipAPply.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ManageStudentProfile.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/MatchedCompanies.dart';

class StudentApiService {
   static String baseurl = 'http://192.168.0.170/SIJBAPI/api/Student/';
   static String interviewurl='http://192.168.0.170/SIJBAPI/api/Interview/';
   static String basicurl='http://192.168.0.170/SIJBAPI/api/FinalTask/';


   // function to complete the student profile

static Future<bool> manageStudentProfile(StudentProfileModel student) async {
  try {
    String url = '${baseurl}ManageStudentProfile';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Required fields
    request.fields["sid"] = student.sid.toString();
    request.fields["fyp_title"] = student.fypTitle ?? "";
    request.fields["fyp_technology"] = student.fypTechnology ?? "";
    request.fields["IsFypChecked"] = student.isFypChecked.toString();
    request.fields["Technologies"] = jsonEncode(student.selectedTechnologies);

    // === Attach CV file if available ===
    if (student.cvFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          's_cv',
          student.cvFile!.path,
        ),
      );
    }

    // === Attach PPT file if available === ✅ NEW
    if (student.pptFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'pptFile',
          student.pptFile!.path,
        ),
      );
    }

    // Send request and handle response
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print("Profile updated successfully");
      return true;
    } else {
      print("Failed: ${responseData.body}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

// fuctin to populate dropdoen for student from technologues 
    static Future<List<TechnologyModel>> fetchTechnologies() async {
      String url = '${baseurl}GetTechnologies'; 
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => TechnologyModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // get nternship record for student

  static Future<dynamic> fetchinternrecord(int studentID) async {
       String url = '${baseurl}GetInternshirecord?studentID=$studentID'; 

     

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load internship record');
    }
  }

  
  // get nternship feedback for student

  static Future<dynamic> fetchinternrecordfeedback(int studentID) async {
       String url = '${baseurl}GetStudentInternFeedback?studentID=$studentID'; 

     

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load internship record');
    }
  }

  // function to fetch mathed companies for student 

static Future<http.Response> fetchCompany(int sid) async {
  String url = '${baseurl}GetAllMatchingCompanies?studentId=$sid';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// filter compnies specific 

 // function to fetch mathed companies for student 

static Future<http.Response> filtermatchedCompany(int sid,String techname) async {
  String url = '${baseurl}FilterCompaniesByTechnologyName?studentId=$sid&techName=$techname';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// join company for student

static Future<http.Response> companysignup(JoinCompany join) async {
  String url = '${interviewurl}JoinCompany'; // Corrected URL
  
  final response = await http.post(Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  body:jsonEncode(join.toJson())
  );

   return response; // Return the full HTTP response
}


// jumpqueue for student 

// static Future<http.Response> jumpthequeue(int sid,int cid,int jid)async {
//   try{
//     String url= '${interviewurl}JumpTheQueueForStudent?studentID=$sid&companyID=$cid&jobFairID=$jid';

//     var response= await http.get(Uri.parse(url));
//     return response;
//   }catch(e){
//     return http.Response('Error: $e',500);

//   }
  
// }



static Future<http.Response> jumpthequeue(int sid, int cid, int jid) async {
  try {
    String url = '${interviewurl}JumpQueueWithCGPAClashHandlingFCFSwithCGPA?studentID=$sid&companyID=$cid&jobFairID=$jid';

    var response = await http.post(
      Uri.parse(url),
     
    );

    return response;
  } catch (e) {
    return http.Response('Error: $e', 500);
  }
}


//fetch student schedule for intrview


static Future<http.Response> fetchstudentschedule(int sid)async {
  try{
    String url= '${baseurl}GetStudentSchedule?studentID=$sid';

    var response= await http.get(Uri.parse(url));
    return response;
  }catch(e){
    return http.Response('Error: $e',500);

  }
  
}

// fetch past interview schedule
static Future<http.Response> fetchstudentpastschedule(int sid)async {
  try{
    String url= '${baseurl}GetStudentpastSchedule?studentID=$sid';

    var response= await http.get(Uri.parse(url));
    return response;
  }catch(e){
    return http.Response('Error: $e',500);

  }
  
}




// TO fetch student remaingpasses for jobfair scheduke to jump queue 
static Future<int> fetchRemainingPasses(int studentId) async {
  try {
    String url='${baseurl}GetStudentPasses?studentId=$studentId';
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['RemainingPasses'] ?? 0; // Default to 0 if null
    }
  } catch (e) {
    // If an error occurs, return 0
  }
  return 0;
}

// apply to internship 

static Future<http.Response> internshipApply(ApplyToInternship apply) async {
  String url = '${baseurl}applytointernship'; // Corrected URL
  
  final response = await http.post(Uri.parse(url),
    headers: {"Content-Type": "application/json"},
  body:jsonEncode(apply.toJson())
  );

   return response; // Return the full HTTP response
}

//  fetach student history wehere he give interview

static Future<http.Response> fetcstudenthistory(int sid)async {
  try{
    String url= '${baseurl}GetStudentSuccessHistory?studentId=$sid';

    var response= await http.get(Uri.parse(url));
    return response;
  }catch(e){
    return http.Response('Error: $e',500);

  }
  
}

// show queue for student 

static Future<http.Response> showqueeu(int sid,int cid,int jid) async {
  String url = '${baseurl}GetQueueInfo?sid=$sid&cid=$cid&jid=$jid';
  try {
    final response = await http.get(Uri.parse(url));
    return response;
  } catch (e) {
    // Return an HTTP response with an error status code (e.g., 500)
    return http.Response('Error: $e', 500);
  }
}

// notfication for studet for accept reject 


  /// ✅ Get all new notifications for the student
  static Future<http.Response> getNewNotifications(int studentId) async {
    String url = '${basicurl}GetAllNotificationsForStudentsssss?sid=$studentId';
    try {
      final response = await http.get(Uri.parse(url));
      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  

  /// ✅ Reject student request (Reject button)
  static Future<http.Response> rejectStudentRequest(int savedStudentId) async {
    String url = '${basicurl}RejectStudentRequest?savedStudentId=$savedStudentId';
    try {
      final response = await http.post(Uri.parse(url));
      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }

  /// ✅ (Optional) Accept student request (if you add Accept API later)
  static Future<http.Response> acceptStudentRequest(int savedStudentId) async {
    String url = '${basicurl}MarkNotificationAsShown?savedStudentId=$savedStudentId';
    try {
      final response = await http.post(Uri.parse(url));
      return response;
    } catch (e) {
      return http.Response('Error: $e', 500);
    }
  }



  /////      accpet reject on base of student k marzi par okkk task posisihility 
  ///
  ///
  

}



