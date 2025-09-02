import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AppliedStudent.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/studentFeedback.dart';

class StudentFeedbackJobbFair extends StatefulWidget {
  const StudentFeedbackJobbFair({super.key});

  @override
  State<StudentFeedbackJobbFair> createState() => _StudentFeedbackJobbFairState();
}

class _StudentFeedbackJobbFairState extends State<StudentFeedbackJobbFair> {
  List<StudentFeedbackJB> slist = [];
  List<StudentFeedbackJB> filtered = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getstu();
  }

  void getstu() async {
  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.studentfeedbackk();
    print("API Response: ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        slist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data) {
          slist.add(StudentFeedbackJB.fromJson(i));
        }
        filtered = slist;  // Assign filtered list after updating slist
        isLoading = false;
      });
    } else {
      setState(() {
        slist = [];
        filtered = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      slist = [];
      filtered = [];
      isLoading = false;
    });
  }
}


 void searchStudent(String regno) async {
  if (regno.isEmpty) {
    setState(() {
      filtered = slist;
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.studentfeedbackkbtregno(regno);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) as List;
      setState(() {
        filtered = data.map((json) => StudentFeedbackJB.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        filtered = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      filtered = [];
      isLoading = false;
    });
  }
}


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(title: const Text('Student Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           


            TextFormField(
  //             onChanged: (value) {
  //   if (value.isEmpty) {
  //     setState(() {
  //       filtered = slist; // Restore original list
  //     });
  //   } else {
  //    // filterMatchedCompanies(value.trim());
  //    searchStudent(value.trim());
  //   }
  // },
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Reg-No',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                    searchStudent(searchController.text);
                    
                    
                  });
                    
                  },
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(218, 97, 233, 70), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (filtered.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No student found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    StudentFeedbackJB student = filtered[index];
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
                                  Text('Company Name', style: Appconstant.appcardstyle),
                                  Text(student.companyname??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Student Name', style: Appconstant.appcardstyle),
                                  Text(student.studentname??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Interview Skills', style: Appconstant.appcardstyle),
                                  Text(student.interviewSkills, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Confidence', style: Appconstant.appcardstyle),
                                  Text(student.confidence, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Dressing', style: Appconstant.appcardstyle),
                                  Text(student.dressing, style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Knowledge', style: Appconstant.appcardstyle),
                                  Text(student.knowledge, style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Problem Solving', style: Appconstant.appcardstyle),
                                  Text(student.problemSolving, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Year', style: Appconstant.appcardstyle),
                                  Text(student.year.toString()??'', style: Appconstant.appcardstyle)
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
              ),
          ],
        ),
      ),

      
      
      
    );
    
  }
}

