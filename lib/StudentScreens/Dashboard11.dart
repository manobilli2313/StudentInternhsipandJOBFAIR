import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Studentnotify.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/CompleteProfile.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MatchedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MySchedule.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StuDashboard extends StatefulWidget {
  const StuDashboard({super.key});

  @override
  State<StuDashboard> createState() => _StuDashboardState();
}

class _StuDashboardState extends State<StuDashboard> {
   List<StudentNotification> notifications = [];
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchJobNotification();
      }
    });
  }

  // // accept reuest of inetrview 

  void acceptrequest(int savedStudentId)async {

    var result= await StudentApiService.acceptStudentRequest(savedStudentId);

    if(result.statusCode==200){
  //    fetchJobNotification();
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
// reject reuqest and update timr 

 void rejectrequest(int savedStudentId)async {

    var result= await StudentApiService.rejectStudentRequest(savedStudentId);

    if(result.statusCode==200){
   //   fetchJobNotification();
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
    builder: (context) => AlertDialog(
      title: Text('Interview Request'),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 400),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company: ${notif.companyName}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}'),
                    Text('Queue Number: ${notif.queueNumber}'),
                    Container(
                      width: 80,
                      child: ElevatedButton(onPressed: (){
                        setState(() {
                          acceptrequest(notif.savedStudentId);
                          
                        });
                      }, child: Text('Accept'))),

                      SizedBox(height: 10,),

                       Container(
                      width: 80,
                      child: ElevatedButton(onPressed: (){
                        setState(() {
                          rejectrequest(notif.savedStudentId);
                          
                        });
                      }, child: Text('Reject'))),
                      
                   
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}


  
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


    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Active Job Fair Notifications'),
    //     content: Container(
    //       width: double.maxFinite,
    //       constraints: BoxConstraints(
    //         maxHeight: 400,
    //       ),
    //       child: ListView.builder(
    //         shrinkWrap: true,
    //         itemCount: notifications.length,
    //         itemBuilder: (context, index) {
    //           final notif = notifications[index];
    //           return Card(
    //             margin: EdgeInsets.symmetric(vertical: 8),
    //             child: Padding(
    //               padding: EdgeInsets.all(8),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text('Company: ${notif.companyName}', style: TextStyle(fontWeight: FontWeight.bold)),
    //                   Text('Interview Time: ${notif.interviewStartTime} - ${notif.interviewEndTime}'),
    //                   Text('Queue Number: ${notif.queueNumber}'),
    //                   SizedBox(height: 10),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       ElevatedButton(
    //                         onPressed: () async {
    //                           await StudentApiService.acceptStudentRequest(notif.savedStudentId);
    //                           if (!context.mounted) return;
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                             SnackBar(content: Text('Request Accepted')),
    //                           );
    //                           Navigator.of(context).pop();
    //                           fetchJobNotification();
    //                         },
    //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    //                         child: Text('Accept'),
    //                       ),
    //                       SizedBox(width: 10),
    //                       ElevatedButton(
    //                         onPressed: () async {
    //                           await StudentApiService.rejectStudentRequest(notif.savedStudentId);
    //                           if (!context.mounted) return;
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                             SnackBar(content: Text('Request Rejected')),
    //                           );
    //                           Navigator.of(context).pop();
    //                           fetchJobNotification();
    //                         },
    //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    //                         child: Text('Reject'),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  

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

