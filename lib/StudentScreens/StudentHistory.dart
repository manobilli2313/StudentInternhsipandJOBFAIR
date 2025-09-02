import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ConductInterview.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJbSchedule.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/StudentHistory.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';

class StudenttrackHistory extends StatefulWidget {
  const StudenttrackHistory({super.key});

  @override
  State<StudenttrackHistory> createState() => _StudenttrackHistoryState();
}

class _StudenttrackHistoryState extends State<StudenttrackHistory> {
  @override

  void initState(){
    super.initState();
    getstudenthistory();
  }
  List<StudentInterviewHistory> students=[];


void getstudenthistory()async{

  SharedPreferences pref=await SharedPreferences.getInstance();
  int? sid=await pref.getInt('studentid');

   var response = await StudentApiService.fetcstudenthistory(sid!);
   if(response.statusCode==200){
    
    setState(() {
      students=[];
      var data= jsonDecode(response.body.toString());
      for(var i in data){
        students.add(StudentInterviewHistory.fromJson(i));

      }

      
    });
   }
   else if(response.statusCode==404){
    setState(() {
      
    });
    students=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Interview History Found '),
     backgroundColor: Colors.red,));

  }
  else if(response.statusCode==500){
    setState(() {
      
    });
    students=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went Wrong.${response.body} '),
     backgroundColor: Colors.red,),
    );

  }
  else{
    setState(() {
      
    });
    students=[];
  }

    
   
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(
        title: Text('Track History'),

        
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: students.isEmpty?Center(child: Text('Currently No Interview Recoed exist..',style: Appconstant.appcardstyle,),
      ):ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    StudentInterviewHistory data = students[index];
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
                                  Text(data.name??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Description', style: Appconstant.appcardstyle),
                                  Text(data.description??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Contact', style: Appconstant.appcardstyle),
                                  Text(data.contact??'--', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('No of Employees', style: Appconstant.appcardstyle),
                                  Text(data.noOfEmployees.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Year', style: Appconstant.appcardstyle),
                                  Text(data.year.toString(), style: Appconstant.appcardstyle),
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
    ),
    );
  }
}