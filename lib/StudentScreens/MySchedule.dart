import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/StudentSChedule.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';
import 'package:intl/intl.dart';

import '../ModalClasses/ShowQueueforStudent.dart';


class ScheduleInterview extends StatefulWidget {
  const ScheduleInterview({super.key});

  @override
  State<ScheduleInterview> createState() => _ScheduleInterviewState();
}

class _ScheduleInterviewState extends State<ScheduleInterview> {

  Timer? _timer;
  @override
  void initState() {
    super.initState();
   _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchMySchedule();
    });
      fetchMySchedule();
    fetchremainingpass();
  }
    @override
  void dispose() {
    // Stop the timer when leaving the page
    _timer?.cancel();
    super.dispose();
  }

  final TextStyle boldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  List<QueueInfo> queuelist=[];

  bool isLoading = true;
  List<StudentInterview> slist = [];
  late SharedPreferences pref;
  int remainspasses=0;
// fetch remaining passes for student  
 Future<void> fetchremainingpass() async {
  pref = await SharedPreferences.getInstance();
  try {
    int? studentId = pref.getInt('studentid');
    if (studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student ID not found. Please log in again."),
         backgroundColor: Colors.red,),
      );
      return;
    }

    int passes = await StudentApiService.fetchRemainingPasses(studentId);
    
    // Update remainspasses and refresh UI
    setState(() {
      remainspasses = passes;
    });

  } catch (e) {
    print("Error fetching remaining passes: $e");
  }
}
// fetch queue fro student 

 Future<void> fetchqueueforstudent(int cid,jid) async {
  pref = await SharedPreferences.getInstance();
  try {
    int? studentId = pref.getInt('studentid');
    if (studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student ID not found. Please log in again."),
         backgroundColor: Colors.red,),
      );
      return;
    }

    var response = await StudentApiService.showqueeu(studentId!,cid!,jid!);

    if(response.statusCode==200){
      queuelist=[];
      setState(() {
        
      });

      var data=jsonDecode(response.body.toString());
      for(var i in data){
        queuelist.add(QueueInfo.fromJson(i));

      }
      
      

    }else if(response.statusCode==404){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No Student for that Company"),
         backgroundColor: Colors.red,),
      );
    }
    
    // Update remainspasses and refresh UI
    

  } catch (e) {
    print("Error fetching remaining passes: $e");
  }
}
List<int> notifiedInterviewIds = [];


//fetch student schedule 

  Future<void> fetchMySchedule() async {
    pref = await SharedPreferences.getInstance();

    try {
      int? studentId = pref.getInt('studentid');

      // Check if studentId exists
      if (studentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Student ID not found. Please log in again."),
           backgroundColor: Colors.red,),
        );
        setState(() => isLoading = false);
        return;
      }

      var response = await StudentApiService.fetchstudentschedule(studentId);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        setState(() {
          slist.clear();
          if (data.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No interviews scheduled.",),
              backgroundColor: Colors.green,),
            );
          } else {
  for (var i in data) {
    slist.add(StudentInterview.fromJson(i));
  }

  // Call reminder checker here AFTER list is fully built
  for (var interview in slist) {
    print(interview.id);
    checkForUpcomingInterviewReminder(interview);
  }
}

          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          isLoading = false;
          slist.clear();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("No active job fair is ongoing.",)),
        // );
      } else {
        setState(() {
          isLoading = false;
          slist.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch data. Please try again.",),
           backgroundColor: Colors.red,),
        );
      }
    } catch (e) {
     if(!mounted)return;
      setState(() {
        isLoading = false;
        slist.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Some internal issue: $e",),
         backgroundColor: Colors.red,),
      );
    }
  }

// student notification system ok method

 void checkForUpcomingInterviewReminder(StudentInterview interview) {
  if (interview.id == null) return;

  if (notifiedInterviewIds.contains(interview.id)) return;

  try {
    final now = TimeOfDay.now();

    final timeParts = interview.intStime.split(":");
    if (timeParts.length < 2) return;

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final interviewTime = TimeOfDay(hour: hour, minute: minute);

    final nowInMinutes = now.hour * 60 + now.minute;
    final interviewInMinutes = interviewTime.hour * 60 + interviewTime.minute;
    final difference = interviewInMinutes - nowInMinutes;

    print("Current Time: ${now.format(context)}");
    print("Interview Time: ${interviewTime.format(context)}");
    print("Difference: $difference");

    if (difference >= 0 && difference <= 5) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Interview Reminder'),
          content: Text('Your interview is starting in $difference minute(s) in room ${interview.roomNo}. Please be ready.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );

      notifiedInterviewIds.add(interview.id!);
    }
  } catch (e) {
    print('Error in time parsing or reminder: $e');
  }
}



  //jump the queue for student in interview

  Future<void> jumpqueue(int cid,int jid)async{

     pref = await SharedPreferences.getInstance();

    try {
      int? studentId = pref.getInt('studentid');

      // Check if studentId exists
      if (studentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Student ID not found. Please log in again."), backgroundColor: Colors.red,),
        );
        setState(() => isLoading = false);
        return;
      }

      var response = await StudentApiService.jumpthequeue(studentId, cid, jid);

      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Student jump in Queue successfully",),
           backgroundColor: Colors.green,),
           
         );
         fetchMySchedule(); // Refresh schedule after jump
         fetchremainingpass(); 
          
          
        });



       
      } else if (response.statusCode == 500) {
        setState(() {
          
        });
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Some internal Issue check it again plz!.",),
            backgroundColor: Colors.red,),
         );
      } 
    } catch (e) {
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Some internal issue: $e",),
         backgroundColor: Colors.red,),
      );
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(
        title: Text('My Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : slist.isEmpty
                ? Center(
                    child: Text(
                      "No scheduled interviews for the job fair.",
                      //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 4),
                      remainspasses>0?
                      Text('Remaining Passes: $remainspasses',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)):SizedBox(),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: slist.length,
                          itemBuilder: (context, index) {
                            final StudentInterview schedule = slist[index];
                            return SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 7,
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Company Name', style: boldTextStyle),
                                          Text(schedule.companyName, style: boldTextStyle),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Start Time', style: boldTextStyle),
                                      //     Text(schedule.intStime, style: boldTextStyle),
                                      //   ],
                                      // ),
                                      // const SizedBox(height: 3),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('End Time', style: boldTextStyle),
                                      //     Text(schedule.intEtime, style: boldTextStyle),
                                      //   ],
                                      // ),
                                      Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Start Time', style: boldTextStyle),
    Text(DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedule.intStime)), style: boldTextStyle),
  ],
),
const SizedBox(height: 3),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('End Time', style: boldTextStyle),
    Text(DateFormat.jm().format(DateFormat("HH:mm:ss").parse(schedule.intEtime)), style: boldTextStyle),
  ],
),

                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Allocated Room', style: boldTextStyle),
                                          Text(
                                            schedule.roomNo != null && schedule.roomNo!.isNotEmpty
                                                ? schedule.roomNo!
                                                : 'Not Assigned Yet',
                                            style: boldTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Number in Queue', style: boldTextStyle),
                                          Text(schedule.numInQueue.toString(), style: boldTextStyle),
                                        ],
                                      ),
                                      const SizedBox(height: 5),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              height: 30,
                                              width: 130,
                                              child: ElevatedButton(onPressed: (){
                                                showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Show Queue"),
                                              content: Text("Do you want to see the Queue?"),
                                              actions: [
                                               Container(
                                                height: 40,
                                                width:80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.deepOrange,
                                                ),
                                                 child: TextButton(
                                                  
                                                  
                                                   onPressed: () async {
                                                     
                                                     // 1️⃣ Fetch queue info
                                                     await fetchqueueforstudent(schedule.companyID, schedule.jid);
                                                 
                                                     // 2️⃣ Show dialog with the list
                                                     showDialog(
                                                       context: context,
                                                       builder: (context) {
                                                         return AlertDialog(
                                                           title: Text('Queue Details',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                                                           content: Container(
                                                             width: double.maxFinite,
                                                             height: 300,
                                                             child: queuelist.isEmpty
                                                                 ? Center(child: Text('No queue info available'))
                                                                 :ListView.builder(
  shrinkWrap: true,
 // physics: NeverScrollableScrollPhysics(), // so it scrolls smoothly inside other scroll views
  itemCount: queuelist.length,
  itemBuilder: (context, index) {
    final qi = queuelist[index];
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qi.studentName ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: ${qi.intStime}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'End: ${qi.intEtime}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Queue No: ${qi.numInQueue}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
)

                                                                //  : ListView.builder(
                                                                //      shrinkWrap: true,
                                                                //      itemCount: queuelist.length,
                                                                //      itemBuilder: (context, index) {
                                                                //        final qi = queuelist[index];
                                                                //        return ListTile(
                                                                //          title: Text(qi.studentName!,style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold),),
                                                                //          subtitle: Text(
                                                                //            'Start: ${qi.intStime} • End: ${qi.intEtime}',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),
                                                                //          ),
                                                                //          trailing: Text('Queue Num:-${qi.numInQueue}',style: TextStyle(fontSize: 14,color: Colors.amber,fontWeight: FontWeight.bold),),
                                                                //        );
                                                                //      },
                                                                //    ),
                                                           ),
                                                           actions: [
                                                             Container(
                                                               width: 80,
                                                               height: 60,
                                                               decoration: BoxDecoration(
                                                                 borderRadius: BorderRadius.circular(10),
                                                                 color: Colors.deepOrange,
                                                               ),
                                                               
                                                               child: TextButton(
                                                                 onPressed: () {
                                                                   Navigator.of(context).pop();
                                                                   Navigator.of(context).pop();},
                                                                 
                                                                 child: Text('OK'),
                                                               ),
                                                             )
                                                           ],
                                                 
                                                         );
                                                       },
                                                     );
                                                     
                                                   },
                                                   child: Text("Yes"),
                                                 ),
                                               ),

                                                Container(
                                                  height: 40,
                                                width:80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.deepOrange,
                                                ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context); // Close dialog
                                                        // Go back to previous page
                                                    },
                                                    child: Text("No"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        
                                                
                                              }, child: Text('Show Queue')),
                                            
                                            ),
                                          ),
                                          const SizedBox(width: 10,),

                                          remainspasses>0&&schedule.numInQueue>1?
                                      
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          height: 30,
                                          width: 130,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Jump Queue"),
                                              content: Text("Do you want to jump in Queue?"),
                                              actions: [
                                                TextButton(
                                                 onPressed: () async {
                                          Navigator.of(context).pop(); // Close dialog first (optional)
                                        
                                           jumpqueue(schedule.companyID, schedule.jid); // Perform queue jump
                                        
                                          // Also refresh remaining passes
                                        },
                                        
                                                  child: Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context); // Close dialog
                                                      // Go back to previous page
                                                  },
                                                  child: Text("No"),
                                                ),
                                              ],
                                            ),
                                          );
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                              // Logic to jump in queue
                                            
                                            },
                                            child: const Text('Jump Queue'),
                                          ),
                                        ),
                                      ):SizedBox(),


                                        ],
                                      ),
                                     
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
              ),
            )
         ],
        ),
      ),
    );
  }
}
