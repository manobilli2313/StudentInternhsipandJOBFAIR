import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/JobFairRequest.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/jobfair.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    fetchjbnotificatin();

  }


  bool alreadyapplied=true;
  

  List<NewJobFair> activelist=[];
  String formatDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime); 
  return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
}


 void fetchjbnotificatin()async{
       SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');


    var response = await CompanyApiServices.fetchactivejobfairnotification(cid!);

if (response.statusCode == 202) {
  setState(() {
    
  });

  alreadyapplied=false;
  // Company has NOT applied yet -> Show popup
  var responseBody = jsonDecode(response.body);
  
  
}  else {
  // Some other error
  print('Error: ${response.statusCode}');
}

  }



 void getactiveevent() async {
  var response = await CompanyApiServices.avtivejbfair();
  
  if (response.statusCode == 200) {
    setState(() {
      var data = jsonDecode(response.body.toString());

      if (data is List) {
        activelist.clear(); // Optional: clear old data
        for (var i in data) {
          activelist.add(NewJobFair.fromJson(i));
        }
      } else if (data is String && data == "No active events yet.") {
        // If API returns "No active events yet."
        activelist = [];
        print('No active events.');
      }
    });
  } else {
    setState(() {
      activelist = [];
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('Active Event'),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: activelist.isEmpty?Center(child: Text('No Active Job Fair Currently!')):ListView.builder(
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
                              alreadyapplied==false? Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 105,
                                      height: 30,
                                      child: ElevatedButton(onPressed: (){
                                        setState(() {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                                            return CompanyJbRequest(jid:list.id!,);
                                          }));
                                          
                                        });
                                        
                                      }, child: Text('Request')),
                                    ),
                                    
                                  ],
                                )
                              ):SizedBox()

                              
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