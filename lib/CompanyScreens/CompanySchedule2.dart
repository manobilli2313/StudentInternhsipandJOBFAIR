// import 'dart:convert';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ConductInterview.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/EventFeedback.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJbSchedule.dart';

class ScheduleCompany2 extends StatefulWidget {
  const ScheduleCompany2({super.key});

  @override
  State<ScheduleCompany2> createState() => _ScheduleCompany2State();
}

class _ScheduleCompany2State extends State<ScheduleCompany2> {
  int? jobFairId;// for event feedback purpose to pass `

  List<MySchedule> schedule = [];
  int currentIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    companyschedule();
  }

  bool breaksend=false;


  // start break 

  
   void  startbreak()async{
     SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

     var response = await CompanyApiServices.Startbreak(cid!);

     if(response.statusCode==200){
      breaksend=true;
      setState(() {
        
      });
      companyschedule();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Break has been Started Successfully'), backgroundColor: Colors.green),
      );

     }

   }

   // end break 

     void  endbreak()async{
     SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

     var response = await CompanyApiServices.endbreak(cid!);

     if(response.statusCode==200){
      breaksend=false;
      companyschedule();
      setState(() {
        
      });
     // companyschedule();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Break has been Ended Successfully'), backgroundColor: Colors.green),
      );

     }

   }





  // handle abset students

   void  absentstudent(int sid,jid)async{
     SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

     var response = await CompanyApiServices.AbsentStudent(sid,cid!,jid);

     if(response.statusCode==200){
      setState(() {
        
      });
      companyschedule();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New Student Comes Seccussfully and time updated'), backgroundColor: Colors.green),
      );

     }

   }


   // fetch ckpany schedule

  void companyschedule() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    var response = await CompanyApiServices.fetchcompanyschedule(cid!);
    if (response.statusCode == 200) {
      setState(() {
        schedule = [];
        var data = jsonDecode(response.body.toString());
        for (var i in data) {
          schedule.add(MySchedule.fromJson(i));
        }
        if (schedule.isNotEmpty) {
        jobFairId = schedule[0].jobfairID; // 🔥 Save job fair ID here to pass oit in future for event feed back
      }

        currentIndex = 0;
        isLoading = false;
      });
    } else {
      setState(() {
        schedule = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Active Job Fair Yet'), backgroundColor: Colors.red),
      );
    }
  }
// increment the index for next studnet interview ok 
 void moveToNextStudent() {
  if (currentIndex < schedule.length - 1) {
    setState(() {
      currentIndex++;
    });
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Interviews Completed'),
        content: Text('Do you want to submit Event Feedback?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventFeedback(jid:jobFairId)), // Replace with your actual feedback screen
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('My Schedule'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : schedule.isEmpty
                  ? Center(
                      child: Text(
                        'Currently No Student in this JobFair',
                        style: Appconstant.appcardstyle,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConductInterviewJb(
                                  sid: schedule[currentIndex].studentID,
                                  jid: schedule[currentIndex].jobfairID,
                                  cid: schedule[currentIndex].companyID,
                                  stname: schedule[currentIndex].StudentName,
                                  regno: schedule[currentIndex].regno,
                                ),
                              ),
                            );

                            // 🔥 Automatically move to next student if interview is completed
                            if (result == 'next') {
                              moveToNextStudent();
                              companyschedule();
                            }
                          },
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRow('Student Name', schedule[currentIndex].StudentName),
                                  buildRow('Start Time', schedule[currentIndex].int_stime),
                                  buildRow('End Time', schedule[currentIndex].int_etime),
                                  buildRow('Reg-No', schedule[currentIndex].regno ?? "---"),
                                  buildRow('Allocated Room', schedule[currentIndex].room_no ?? "---"),
                                ],
                              ),
                            ),
                          ),
                        ),

                        ElevatedButton(onPressed: (
                          

                        ){
                          absentstudent(schedule[currentIndex].studentID,schedule[currentIndex].jobfairID);
                        }, child: Text('Mark Absent')),

                        SizedBox(height: 20,),
                        breaksend==false?ElevatedButton(onPressed: (){

                          startbreak();
                          setState(() {
                            
                            breaksend=true;
                            
                          });
                        }, child: Text('Start Break')):
                        ElevatedButton(onPressed: (){
                          setState(() {
                            breaksend=false;
                          });
                           endbreak();

                        }, child: Text('End Break'))
                      ],
                    ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Appconstant.appcardstyle),
          Text(value, style: Appconstant.appcardstyle),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
// import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
// import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ConductInterview.dart';
// import 'package:student_internship_and_jobfair_fyp/CompanyScreens/EventFeedback.dart';
// import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
// import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
// import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJbSchedule.dart';







// class ScheduleCompany extends StatefulWidget {
//   const ScheduleCompany({super.key});

//   @override
//   State<ScheduleCompany> createState() => _ScheduleCompanyState();
// }

// class _ScheduleCompanyState extends State<ScheduleCompany> {
//   List<MySchedule> schedule = [];
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     companyschedule();
//   }

//   void companyschedule() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     int? cid = pref.getInt('companyid');

//     var response = await CompanyApiServices.fetchcompanyschedule(cid!);
//     if (response.statusCode == 200) {
//       setState(() {
//         schedule = [];
//         var data = jsonDecode(response.body.toString());
//         for (var i in data) {
//           schedule.add(MySchedule.fromJson(i));
//         }
//         currentIndex = 0; // reset index
//       });
//     } else if (response.statusCode == 400) {
//       schedule = [];
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No Active Job Fair Yet'),
//          backgroundColor: Colors.red,),
//       );
//     } else if (response.statusCode == 500) {
//       schedule = [];
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Something went wrong. ${response.body}'),
//          backgroundColor: Colors.red,),
//       );
//     } else {
//       schedule = [];
//     }
//   }

//   // void nextstudent(int studentid, int jobfairId) async {
//   //   SharedPreferences pref = await SharedPreferences.getInstance();
//   //   int? cid = pref.getInt('companyid');
//   //   if (cid == null) return;

//   //   JoinCompany joinRequest = JoinCompany(
//   //     studentID: studentid,
//   //     companyID: cid,
//   //     jobFairID: jobfairId,
//   //   );

//   //   final response = await CompanyApiServices.nextstudent(joinRequest);

//   //   if (response.statusCode == 200) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Interview completed. Moving to next student."),
//   //       backgroundColor: Colors.green,),
//   //     );

//   //     setState(() {
//   //       if (currentIndex < schedule.length - 1) {
//   //         currentIndex++;
//   //       } else {
//   //         showDialog(
//   //           context: context,
//   //           builder: (context) => AlertDialog(
//   //             title: Text("All Interviews Done"),
//   //             content: Text("Do you want to submit feedback about the job fair?"),
//   //             actions: [
//   //               TextButton(
//   //                 onPressed: () {
//   //                   Navigator.pop(context);

//   //                   // Navigate to feedback screen if needed

//   //                     Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
//   //               return EventFeedback(jid:schedule[currentIndex].jobfairID ,);
//   //             }));
//   //                 },
//   //                 child: Text("Yes"),
//   //               ),
//   //               TextButton(
//   //                 onPressed: () => Navigator.pop(context),
//   //                 child: Text("Later"),
//   //               ),
//   //             ],
//   //           ),
//   //         );
//   //       }
//   //     });
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Failed to proceed. Try again."),
//   //        backgroundColor: Colors.red,),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CompanyDrawer(),
//       appBar: AppBar(
//         title: Text('My Schedule'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: schedule.isEmpty
//               ? Center(
//                   child: Text(
//                     'Currently No Student in this JobFair',
//                     style: Appconstant.appcardstyle,
//                   ),
//                 )
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                          Navigator.push(context, MaterialPageRoute(builder: (context){
//                          return ConductInterviewJb(sid: schedule[currentIndex].studentID,jid: schedule[currentIndex].jobfairID,cid: schedule[currentIndex].companyID,stname:schedule[currentIndex].StudentName,regno:schedule[currentIndex].regno);
//                        }));
//                       },

                      
//                       child: Card(
//                         elevation: 7,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Student Name', style: Appconstant.appcardstyle),
//                                   Text(schedule[currentIndex].StudentName,
//                                       style: Appconstant.appcardstyle),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Start Time', style: Appconstant.appcardstyle),
//                                   Text(schedule[currentIndex].int_stime,
//                                       style: Appconstant.appcardstyle),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('End Time', style: Appconstant.appcardstyle),
//                                   Text(schedule[currentIndex].int_etime,
//                                       style: Appconstant.appcardstyle),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Reg-No', style: Appconstant.appcardstyle),
//                                   Text(schedule[currentIndex].regno ?? "---",
//                                       style: Appconstant.appcardstyle),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Allocated Room', style: Appconstant.appcardstyle),
//                                   Text(schedule[currentIndex].room_no ?? "---",
//                                       style: Appconstant.appcardstyle),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Center(
//                     //   child: ElevatedButton(
//                     //     onPressed: () async {
//                     //       nextstudent(
//                     //         schedule[currentIndex].studentID,
//                     //         schedule[currentIndex].jobfairID,
//                     //       );
//                     //     },
//                     //     child: Text("Next"),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }



//================ previous screen as same to figma not much logoic all students sho in list no ione card no feedback

// class ScheduleCompany extends StatefulWidget {
//   const ScheduleCompany({super.key});

//   @override
//   State<ScheduleCompany> createState() => _ScheduleCompanyState();
// }

// class _ScheduleCompanyState extends State<ScheduleCompany> {
//   @override

//   void initState(){
//     super.initState();
//     companyschedule();
//   }
//   List<MySchedule> schedule=[];


// void companyschedule()async{

//   SharedPreferences pref=await SharedPreferences.getInstance();
//   int? cid=await pref.getInt('companyid');

//    var response = await CompanyApiServices.fetchcompanyschedule(cid!);
//    if(response.statusCode==200){
    
//     setState(() {
//       schedule=[];
//       var data= jsonDecode(response.body.toString());
//       for(var i in data){
//         schedule.add(MySchedule.fromJson(i));

//       }

      
//     });
//    }
//    else if(response.statusCode==400){
//     setState(() {
      
//     });
//     schedule=[];
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Active Job Fair Yet ')));

//   }
//   else if(response.statusCode==500){
//     setState(() {
      
//     });
//     schedule=[];
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went Wrong.${response.body} ')));

//   }
//   else{
//     setState(() {
      
//     });
//     schedule=[];
//   }

    
   
// }


// // next student to interview 
//   void nextstudent(int studentid, int jobfairId) async {
//       SharedPreferences pref=await SharedPreferences.getInstance();
//   int? cid=await pref.getInt('companyid');
//     if (cid == null) return;

//     JoinCompany joinRequest = JoinCompany(
//       studentID: studentid,
//       companyID: cid,
//       jobFairID: jobfairId,
//     );

//     final response = await CompanyApiServices.nextstudent(joinRequest);

//     if (response.statusCode==200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Successfully Iterviewed Student and turn to Next Student!",)),
//       );
      
//       companyschedule();

//       setState(() {
        
//       });

//       // here some issue while fetch list of updated scheule
      
        
    
 
      
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to turn Next Student in the company. Try again.",)),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CompanyDrawer(),
//       appBar: AppBar(
//         title: Text('My Schedule'),

        
//       ),
//       body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
//       child: schedule.isEmpty?Center(child: Text('Currently No Student  in this  JobFair',style: Appconstant.appcardstyle,),
//       ):ListView.builder(
//                   itemCount: schedule.length,
//                   itemBuilder: (context, index) {
//                     MySchedule data = schedule[index];
//                     return SizedBox(
//                       width: double.infinity,
//                       child: GestureDetector(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context){
//                             return ConductInterviewJb(sid: data.studentID,jid: data.jobfairID,cid: data.companyID,stname:data.StudentName,regno:data.regno);
//                           }));
//                         },
                        
//                         child: Card(
//                           elevation: 7,
//                           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Student Name', style: Appconstant.appcardstyle),
//                                     Text(data.StudentName, style: Appconstant.appcardstyle),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 3),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Start Time', style: Appconstant.appcardstyle),
//                                     Text(data.int_stime, style: Appconstant.appcardstyle),
//                                   ],
//                                 ),
                                
//                                 const SizedBox(height: 3),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('End Time', style: Appconstant.appcardstyle),
//                                     Text(data.int_etime, style: Appconstant.appcardstyle),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 3),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Reg-No', style: Appconstant.appcardstyle),
//                                     Text(data.regno!, style: Appconstant.appcardstyle),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Allocated Room', style: Appconstant.appcardstyle),
//                                     Text(data.room_no==null?'---':data.room_no!, style: Appconstant.appcardstyle),
//                                   ],
//                                 ),
//                                  const SizedBox(height: 5),
                        
//                                  Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Center(child: Container(
//                                       height: 30,
//                                       width: 90,
//                                       child: ElevatedButton(onPressed: ()async{
//                                         setState(() {
                                          
//                                         });
//                                          nextstudent(data.studentID, data.jobfairID);
//                                         //companyschedule();
//                                         // here write logic of nrxt button to process next student ok 
//                                       }, child: Text('Next'))),)
//                                   ],
//                                  )
                                
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       )
//     ),
//     );
//   }
// }