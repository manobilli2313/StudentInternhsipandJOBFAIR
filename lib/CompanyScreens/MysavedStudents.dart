import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ConductInterview.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJbSchedule.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudents.dart';

class SavedStudentsJF extends StatefulWidget {
  const SavedStudentsJF({super.key});

  @override
  State<SavedStudentsJF> createState() => _SavedStudentsJFState();
}

class _SavedStudentsJFState extends State<SavedStudentsJF> {
  @override

  void initState(){
    super.initState();
    getsavedstudents();
  }
  List<SavedStudent> students=[];


void getsavedstudents()async{

  SharedPreferences pref=await SharedPreferences.getInstance();
  int? cid=await pref.getInt('companyid');

   var response = await CompanyApiServices.fetchsavedstudent(cid!);
   if(response.statusCode==200){
    
    setState(() {
      students=[];
      var data= jsonDecode(response.body.toString());
      for(var i in data){
        students.add(SavedStudent.fromJson(i));

      }

      
    });
   }
   else if(response.statusCode==404){
    setState(() {
      
    });
    students=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Company Found '),
     backgroundColor: Colors.red,));

  }
  else if(response.statusCode==500){
    setState(() {
      
    });
    students=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went Wrong.${response.body} '),
     backgroundColor: Colors.red,));

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
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('Saved Students'),

        
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: students.isEmpty?Center(child: Text('Currently No Saved Student  in this  JobFair',style: Appconstant.appcardstyle,),
      ):ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    SavedStudent data = students[index];
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
                                  Text('Student Name', style: Appconstant.appcardstyle),
                                  Text(data.studentName??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CGPA', style: Appconstant.appcardstyle),
                                  Text(data.studentCgpa.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reg-No', style: Appconstant.appcardstyle),
                                  Text(data.regNo??'--', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Gender', style: Appconstant.appcardstyle),
                                  Text(data.gender??'', style: Appconstant.appcardstyle),
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