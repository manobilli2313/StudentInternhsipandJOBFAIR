import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/SubmitInternFeedback.dart';

import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Internshipdrawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternFeedback.dart';


class AllInterneeFeedback extends StatefulWidget {
  const AllInterneeFeedback({super.key});

  @override
  State<AllInterneeFeedback> createState() => _AllInterneeFeedbackState();
}

class _AllInterneeFeedbackState extends State<AllInterneeFeedback> {
  @override

  void initState(){
    super.initState();
    internfeedbacks();
  }


  List<SubmitInternsFeedback> feedbacklist=[];
     


void internfeedbacks()async{

 

   var response = await MemberApi.allinternsfeedback();
   if(response.statusCode==200){

   
    setState(() {
      feedbacklist=[];
      var data= jsonDecode(response.body.toString());
      for(var i in data){
        feedbacklist.add(SubmitInternsFeedback.fromJson(i));

      }

      
    });
   }
   else if(response.statusCode==400){
    setState(() {
      
    });
    feedbacklist=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Active Job Fair Yet '), backgroundColor: Colors.red,));

  }
  else if(response.statusCode==500){
    setState(() {
      
    });
    feedbacklist=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went Wrong.${response.body} '), backgroundColor: Colors.red,));

  }
  else{
    setState(() {
      
    });
    feedbacklist=[];
  }

    
   
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: InetrnsDrawer(),
      appBar: AppBar(
        title: Text('Intern Feedback'),

        
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: feedbacklist.isEmpty?Center(child: Text('Currently No Student Feedback ',style: Appconstant.appcardstyle,),
      ):ListView.builder(
                  itemCount: feedbacklist.length,
                  itemBuilder: (context, index) {
                    final data = feedbacklist[index];
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
                                  Text(data.companyname??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 5),
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Student Name', style: Appconstant.appcardstyle),
                                  Text(data.studentname??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Joining Date', style: Appconstant.appcardstyle),
                                  Text("${data.joiningDate != null ? data.joiningDate!.toLocal().toString().split(' ')[0] : 'N/A'}", style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Ending Date', style: Appconstant.appcardstyle),
                                  Text("${data.endingDate != null ? data.endingDate!.toLocal().toString().split(' ')[0] : 'N/A'}", style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Result', style: Appconstant.appcardstyle),
                                  Text(data.resultRemarks??' ', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Communication', style: Appconstant.appcardstyle),
                                  Text('${data.communicationRating}', style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 5),
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Skills', style: Appconstant.appcardstyle),
                                  Text('${data.skillsRating}', style: Appconstant.appcardstyle),
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