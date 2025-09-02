import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ActiveEvents.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanySchedule.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/InternsRequestwithTechnlogy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {


  @override
  void initState() {
    super.initState();
   // fetchjbnotificatin();
  }

  void fetchjbnotificatin()async{
       SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');


    var response = await CompanyApiServices.fetchactivejobfairnotification(cid!);

if (response.statusCode == 202) {
  // Company has NOT applied yet -> Show popup
  var responseBody = jsonDecode(response.body);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Active Job Fair'),
      content: Text(responseBody['message']),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}  else {
  // Some other error
  print('Error: ${response.statusCode}');
}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:CompanyDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            GestureDetector(
              onTap: (){
                
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return InternshipRequestScreen();
              }));

                
              },
              child: Column(
                children: [
                  Center(child: Image.asset('assets/images/pic2.png',height: 180,width: 180,)),
                   Text('Intern Request',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.black)),
                ],
              ),
            ),
           
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                
                   Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ScheduleCompany();
              }));
                
              },
              child: Column(
                children: [
                  Center(child: Image.asset('assets/images/pic333.png',height: 180,width: 180,)),
                  Text('My Schedule',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.black)),
                ],
              ),
            ),
            
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                  return ActiveEvent();
                }));
                
                
              },
              child: Column(
                children: [
                  Center(child: Image.asset('assets/images/pic444.png',height: 180,width: 300,)),
                  Text('Active Events',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.black))
              
                ],
              ),
            ),
            
            
        
          ],
        ),
      )
     
        

      
    );
  }
}