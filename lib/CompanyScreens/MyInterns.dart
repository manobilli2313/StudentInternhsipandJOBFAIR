import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/SubmitInternFeedback.dart';

import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';


class AllInterns extends StatefulWidget {
  const AllInterns({super.key});

  @override
  State<AllInterns> createState() => _AllInternsState();
}

class _AllInternsState extends State<AllInterns> {
  @override

  void initState(){
    super.initState();
    companyinterns();
  }
  List<Interns> internslist=[];
     


void companyinterns()async{

  SharedPreferences pref=await SharedPreferences.getInstance();
   int? cid= pref.getInt('companyid');

   var response = await CompanyApiServices.fetchcompanyinterns(cid!);
   if(response.statusCode==200){

   
    setState(() {
      internslist=[];
      var data= jsonDecode(response.body.toString());
      for(var i in data){
        internslist.add(Interns.fromJson(i));

      }

      
    });
   }
   else if(response.statusCode==400){
    setState(() {
      
    });
    internslist=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Active Job Fair Yet '),
     backgroundColor: Colors.red,));

  }
  else if(response.statusCode==500){
    setState(() {
      
    });
    internslist=[];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went Wrong.${response.body} '),
     backgroundColor: Colors.red,));

  }
  else{
    setState(() {
      
    });
    internslist=[];
  }

    
   
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('My Interns'),

        
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: internslist.isEmpty?Center(child: Text('Currently No Student assigned to you',style: Appconstant.appcardstyle,),
      ):ListView.builder(
                  itemCount: internslist.length,
                  itemBuilder: (context, index) {
                    final data = internslist[index];
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
                                  Text(data.sname!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CGPA', style: Appconstant.appcardstyle),
                                  Text('${data.scgpa!}', style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Semester', style: Appconstant.appcardstyle),
                                  Text('${data.semester}', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Gender', style: Appconstant.appcardstyle),
                                  Text(data.sgender!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reg-No', style: Appconstant.appcardstyle),
                                  Text(data.sregno!, style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 5),
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Internship Status', style: Appconstant.appcardstyle),
                                  Text(data.internshipStatus!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              data.resultStatus==0?  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Container(
                                      height: 30,
                                      width: 110,
                                      child: ElevatedButton(onPressed: ()async{
                                        setState(() {
                                          
                                        });
                                        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InternFeedback( 
                  cid: data.companyID!,
                  sid: data.studentID!,
                  sname: data.sname,
                  regno: data.sregno,// Your feedback screen here
                  
                  
                  
                ),
              ),
            );

                                   
                                         
                                        
                                      }, child: Text('Feedback'))),)
                                  ],
                                 ):SizedBox(),


                      
                              
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