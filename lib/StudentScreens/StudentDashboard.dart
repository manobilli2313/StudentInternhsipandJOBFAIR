import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Studentnotify.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/CompleteProfile.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MatchedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MySchedule.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {

  Timer? _notificationTimer;

  List<StudentNotification> notifications = [];

@override
void initState() {
  super.initState();

  // ✅ Fetch immediately on page load
 // fetchJobNotification();

  // ✅ Start periodic notification checker 
  // _notificationTimer = Timer.periodic(Duration(seconds: 30), (timer) {
  //   if (mounted) {
  //     fetchJobNotification();
  //   }
  // });
}

@override
void dispose() {
  _notificationTimer?.cancel(); // ✅ Always cancel timer to prevent memory leaks
  super.dispose();
}




// accept function on studnet marzi and set time 

Future<void> acceptInterview({
  required int savedStudentId,
  required int studentId,
  required int companyId,
  required int jobFairId,
}) async {
  try {
    final url = Uri.parse("http://10.130.184.162/SIJBAPI/api/FinalTask/AcceptInterview");

    final body = {
      "Id": savedStudentId,
      "JobFairID": jobFairId,
      "StudentID": studentId,
      "CompanyID": companyId,
      
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Interview accepted successfully')),
      );
    } else if (response.statusCode == 406) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid data provided')),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved student not found')),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No available slots or company not found')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept interview')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

// rejevt request 

Future<void> rejectInterview({
  required int savedStudentId,
  required int studentId,
  required int companyId,
  required int jobFairId,
}) async {
  try {
    final url = Uri.parse("http://10.130.184.162/SIJBAPI/api/FinalTask/RejectInterview");

    final body = {
      "Id": savedStudentId,
      "StudentID": studentId,
      "CompanyID": companyId,
      "JobFairID": jobFairId,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Interview request rejected successfully')),
      );
    } else if (response.statusCode == 406) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid data provided')),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved student not found')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject interview')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}



  // reject request only status change and confirm only 
  void rejectrequest(int savedStudentId)async {

    var result= await StudentApiService.rejectStudentRequest(savedStudentId);

    if(result.statusCode==200){
    //  fetchJobNotification();
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Rejected Successfully."),
         backgroundColor: Colors.green,),
      );
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request not Accepted Some Issue."),
         backgroundColor: Colors.green,),
      );
      

    }
  }

  // // accept reuest of inetrview 

  void acceptrequest(int savedStudentId)async {

    var result= await StudentApiService.acceptStudentRequest(savedStudentId);

    if(result.statusCode==200){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Accepted Successfully."),
         backgroundColor: Colors.green,),
      );
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request not Accepted Some Issue."),
         backgroundColor: Colors.green,),
      );
      

    }
  }

  void fetchJobNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? sid = pref.getInt('studentid');

    var response = await StudentApiService.getNewNotifications(sid!);

    if (response.statusCode == 200) {
     // fetchJobNotification();

      print(response.body);
      notifications = [];
      var responseBody = jsonDecode(response.body.toString());

      for (var i in responseBody) {
        notifications.add(StudentNotification.fromJson(i));
      }

      if (notifications.isNotEmpty && context.mounted) {
        showNotificationDialog();
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }
 void showNotificationDialog() {
  if (notifications.isEmpty) return;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('Interview Requests'),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(maxHeight: 400),
            child: notifications.isEmpty
                ? Center(child: Text('No Notifications'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${notif.companyName} sent you a request to attend an interview.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Queue Number: ${notif.queueNumber}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 12),
                              // ✅ Use Wrap instead of Row here
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      acceptInterview(
                                        savedStudentId: notif.savedStudentId,
                                        studentId: notif.sid,
                                        companyId: notif.cid,
                                        jobFairId: notif.jid,
                                      );
                                      setStateDialog(() {
                                        notifications.removeAt(index);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    child: Text('Accept'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      rejectInterview(
                                        savedStudentId: notif.savedStudentId,
                                        studentId: notif.savedStudentId,
                                        companyId: notif.cid,
                                        jobFairId: notif.jid,
                                      );
                                      setStateDialog(() {
                                        notifications.removeAt(index);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    child: Text('Reject'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}


//   void showNotificationDialog() {
//   if (notifications.isEmpty) return;

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Interview Request'),
//       content: Container(
//         width: double.maxFinite,
//         constraints: BoxConstraints(maxHeight: 400),
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: notifications.length,
//           itemBuilder: (context, index) {
//             final notif = notifications[index];
//             return Card(
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Company: ${notif.companyName} send You request to attend Interview.'),
//                     Text('Company: ${notif.companyName}', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text('Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}'),
//                     Text('Queue Number: ${notif.queueNumber}'),
//                     Container(
//                       width: 80,
//                       child: ElevatedButton(onPressed: (){
//                         setState(() {
//                           acceptrequest(notif.savedStudentId);
                       
                          
//                         });
//                       }, child: Text('OK'))),
//                        Container(
//                       width: 100,
//                       child: ElevatedButton(onPressed: (){
//                         setState(() {
//                           // acceptrequest(notif.savedStudentId);
//                             acceptInterview(savedStudentId: notif.savedStudentId, studentId: notif.sid, 
//                           companyId: notif.cid, jobFairId: notif.jid);
                        
//                            notifications.removeAt(index); // 🔥 Remove the current card
                          
//                         });
//                       }, child: Text('Accept'))),

//                       SizedBox(height: 10,),

//                        Container(
//                       width: 100,
//                       child: ElevatedButton(onPressed: (){
//                         setState(() {
//                         //  rejectrequest(notif.savedStudentId);
//                          rejectInterview(savedStudentId: notif.savedStudentId, studentId: notif.savedStudentId, 
//                           companyId: notif.cid, jobFairId: notif.jid);
//                            notifications.removeAt(index);
                          
//                         });
//                       }, child: Text('Reject'))),
                   
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('OK'),
//         ),
//       ],
//     ),
//   );
// }


  
//     void showNotificationDialog() {
//   if (notifications.isEmpty) return;

//   final notif = notifications[0]; // Just show first notification
//   print('Company: ${notif.companyName}');
//   print('Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}');
//   print('Queue Number: ${notif.queueNumber}');

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Job Fair Notification'),
//       content: Text(
//         'Company: ${notif.companyName}\n'
//         'Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}\n'
//         'Queue Number: ${notif.queueNumber}',
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('OK'),
//         ),
//       ],
//     ),
//   );
// }


    
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MatchedCompanies();
                  }));
                },
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('assets/images/company1.png', height: 180, width: 180),
                    ),
                    const Text('Companies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return ScheduleInterview();
                  }));
                },
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('assets/images/pic333.png', height: 180, width: 180),
                    ),
                    const Text('My Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return StudentProfileScreen();
                  }));
                },
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('assets/images/profile.png', height: 180, width: 180),
                    ),
                    const Text('Complete Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
