import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/SetPassSlabsScreen.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/JobFairRequest.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/jobfair.dart';

class ActiveEvent extends StatefulWidget {
  const ActiveEvent({super.key});

  @override
  State<ActiveEvent> createState() => _ActiveEventState();
}

class _ActiveEventState extends State<ActiveEvent> {
  @override
  void initState(){
    super.initState();
    getactiveevent();

  }
  

  List<NewJobFair> activelist=[];
  String formatDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime); 
  return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
}



  void getactiveevent()async{
    var response=await AdminAPI.avtivejbfair();
    if(response.statusCode==200){
      setState(() {
        var data=jsonDecode(response.body.toString());
        for(var i in data){
          activelist.add(NewJobFair.fromJson(i));
        }
      });
    }else{
      setState(() {
        
      });
      activelist=[];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('Active Event'),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: activelist.isEmpty?Center(child: Text('No Job Fair Currently!')):ListView.builder(
        itemCount: activelist.length,
        itemBuilder: (context,index){
          NewJobFair list=activelist[index];
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
                                  Text('Year', style: Appconstant.appcardstyle),
                                  Text(list.year.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Venue', style: Appconstant.appcardstyle),
                                  Text(list.venue!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Start Date', style: Appconstant.appcardstyle),
                                  Text(formatDate(list.startdate!), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('End Date', style: Appconstant.appcardstyle),
                                  Text(formatDate(list.enddate!), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Job Fair Date', style: Appconstant.appcardstyle),
                                  Text(formatDate(list.jobfairdate!), style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Status', style: Appconstant.appcardstyle),
                                  Text(list.status!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 30,
                                      child: ElevatedButton(onPressed: (){
                                        setState(() {
                                          Navigator.push(context, MaterialPageRoute(builder:(context){
                                            return SetPassSlabsScreen(jobFairId:list.id!,);
                                          }));
                                          
                                        });
                                        
                                      }, child: Text('Set Passes')),
                                    ),
                                    
                                  ],
                                )
                              ),

                              
                            ],
                          ),
                        ),
                      ),
                    );
                  
          

      }
      ),
      ),
    );
  }
}