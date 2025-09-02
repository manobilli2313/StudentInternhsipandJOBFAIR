import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
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

class PastInterview extends StatefulWidget {

  int? sid;
  String? sname;
  PastInterview({super.key,this.sid,this.sname});

  @override
  State<PastInterview> createState() => _PastInterviewState();
}

class _PastInterviewState extends State<PastInterview> {
 Timer? _timer;
  @override
  void initState() {
    super.initState();
   _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchMySchedule();
    });
    fetchMySchedule();
   // fetchremainingpass();
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

    int passes = await StudentApiService.fetchRemainingPasses(widget.sid!);
    
    // Update remainspasses and refresh UI
    setState(() {
      remainspasses = passes;
    });

  } catch (e) {
    print("Error fetching remaining passes: $e");
  }
}
// fetch queue fro student 

 


//fetch student schedule 

  Future<void> fetchMySchedule() async {
    pref = await SharedPreferences.getInstance();

    try {
   //   int? studentId = pref.getInt('studentid');

      // Check if studentId exists
      if (widget.sid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Student ID not found. Please log in again."),
           backgroundColor: Colors.red,),
        );
        setState(() => isLoading = false);
        return;
      }

      var response = await StudentApiService.fetchstudentpastschedule(widget.sid!);

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





  //jump the queue for student in interview

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  drawer: StudentdrawerScreen(),
      appBar: AppBar(
        title: Text('Past Interview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : slist.isEmpty
                ? Center(
                    child: Text(
                      "No Past interviews for this fair.",
                      //style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 4),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: 
                            Text('Student Name:-${widget.sname!}',style: Appconstant.appcardstyle,),
                          )
                        ],
                      ),
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
