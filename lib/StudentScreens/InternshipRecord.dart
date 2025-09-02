import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MyInternshipfeddback.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';

class StudentInternshipRecord extends StatefulWidget {
  @override
  _StudentInternshipRecordState createState() => _StudentInternshipRecordState();
}

class _StudentInternshipRecordState extends State<StudentInternshipRecord> {
  Map<String, dynamic>? internshipData;
  bool isLoading = true;
  String? message;

  @override
  void initState() {
    super.initState();
    loadInternshipRecord();
  }

  Future<void> loadInternshipRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int studentID = prefs.getInt('studentid') ?? 0;

    if (studentID == 0) {
      setState(() {
        message = 'Student ID not found in device.';
        isLoading = false;
      });
      return;
    }

    try {
      var response = await StudentApiService.fetchinternrecord(studentID);

      if (response is String) {
        setState(() {
          message = response;
          isLoading = false;
        });
      } else {
        setState(() {
          internshipData = response;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error fetching internship record.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(title: Text('Internship Status')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : internshipData == null
              ? Center(
                  child: Text(
                    message ?? 'No record found.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow('Company Name', internshipData!['CompanyName']),
                            buildRow('Mentor Name', internshipData!['MentorName']),
                            buildRow('Technology', internshipData!['techname']),
                            buildRow('Result Status', internshipData!['ResultStatus']),
                            buildRow('Start Date', formatDate(internshipData!['StartDate'])),
                            buildRow('End Date', formatDate(internshipData!['EndDate'])),
                            SizedBox(height: 10),

                            internshipData!['result']==1 || internshipData!['result']==2?
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return MyInternshipfeedback(sid: internshipData!['studentID'],);
                                       })) ;
                
                                //  loadInternshipRecord();
                                },
                                child: Text('Show Result'),
                              ),
                            ):SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget buildRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Appconstant.appcardstyle),
          Text(value ?? 'N/A', style: Appconstant.appcardstyle),
        ],
      ),
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    return dateString.split('T')[0];
  }
}
