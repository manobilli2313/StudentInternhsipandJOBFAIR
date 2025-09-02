import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/PendingCompnies.dart';

class CompaniesJobFairRequest extends StatefulWidget {
  const CompaniesJobFairRequest({super.key});

  @override
  State<CompaniesJobFairRequest> createState() => _CompaniesJobFairRequestState();
}

class _CompaniesJobFairRequestState extends State<CompaniesJobFairRequest> {
  @override
  void initState() {
    super.initState();
    getallrequests();
  }
  List<CompanyModel> clist=[];

 void getallrequests() async {
  try {
    var response = await MemberApi.companyjobfairrequest();

    if (response.statusCode == 200) {
      clist.clear();
      var data = jsonDecode(response.body.toString());
      for (var i in data) {
        clist.add(CompanyModel.fromJson(i));
      }
      setState(() {}); // Update UI
    } 
    else if (response.statusCode == 404) {
      setState(() {
        clist = [];  // UI will automatically show "No requests available"
      });
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch requests. Please try again later.",), backgroundColor: Colors.red,)
      );
    }
  } catch (e) {
    setState(() {
      clist = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $e",), backgroundColor: Colors.red,) // Show only for unexpected errors
    );
  }
 }
 // function to accept request rom company

  void acceptrequest(int rid)async{
    try{
      var response= await MemberApi.acceptcompanyjbrequest(rid);
      if(response.statusCode==200){
        setState(() {
          
        });
         clist.remove(clist.firstWhere((comp) => comp.requestId == rid));
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company Request Successfully Accepted",),backgroundColor: Colors.green,),
      );

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company Request Not Accepted",), backgroundColor: Colors.red,),);

      }

    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occur: $e',), backgroundColor: Colors.red,),);

    }
  }

  void rejectrequest(int rid)async{
    try{
      var response= await MemberApi.rejectcompanyjbrequest(rid);
      if(response.statusCode==200){
        setState(() {
          
        });
        clist.remove(clist.firstWhere((student) => student.requestId == rid));
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company Successfully Rejected",),backgroundColor: Colors.green,),
      );

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try Agin Later some issue Exist",), backgroundColor: Colors.red,),);

      }

    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occur: $e',), backgroundColor: Colors.red,),);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(
        title: Text('Companies Request'),
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: clist.isEmpty?Center(child: Text('Currently No Request for JobFair',style: Appconstant.appcardstyle,),
      ):ListView.builder(
                  itemCount: clist.length,
                  itemBuilder: (context, index) {
                    CompanyModel company = clist[index];
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
                                  Text(company.name, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Contact', style: Appconstant.appcardstyle),
                                  Text(company.contact, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Description', style: Appconstant.appcardstyle),
                                  Text(company.description, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Slot Time', style: Appconstant.appcardstyle),
                                  Text(company.slotTime.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('No Of Interviewers', style: Appconstant.appcardstyle),
                                  Text(company.noOfInterviews.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 30,
                                      child: ElevatedButton(onPressed: (){
                                          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Accept Company Request"),
          content: Text("Do you want to accept this company request for Fob Fair?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                acceptrequest(company.requestId!);  // Close the dialog
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
                                      }, child: Text('Accept')),
                                    ),
                                    const SizedBox(width: 5,),
                                    Container(
                                      width: 100,
                                      height: 30,
                                      child: ElevatedButton(onPressed: (){
                                          showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reject Company Request"),
          content: Text("Do you want to reject this company request?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                rejectrequest(company.requestId!);  // Close the dialog
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
                                      }, child: Text('Reject')),
                                    ),
                                  ],
                                )
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