import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/PendingCompnies.dart';

class CompanyAccountsPending extends StatefulWidget {
  const CompanyAccountsPending({super.key});

  @override
  State<CompanyAccountsPending> createState() => _CompanyAccountsPendingState();
}

class _CompanyAccountsPendingState extends State<CompanyAccountsPending> {
  @override
  void initState() {
    super.initState();
    getallcompanies();
  }
  int cl=0;
  List<CompanyModel> clist=[];


  void getallcompanies()async{
    try{
      var response=await MemberApi.pendingrequest();
      if(response.statusCode==200){
        var data=jsonDecode(response.body.toString());
        setState(() {
          clist.clear();
          for(var i in data){
            clist.add(CompanyModel.fromJson(i));
          }
        });

      }else{
        setState(() {
          
        });
        clist.clear();
      }

    }catch(e){
      // setState(() {
        
      // });
      clist.clear();

    }
  }

  void accept(int cid)async{
    try{
      var response= await MemberApi.acceptcompany(cid);
      if(response.statusCode==200){
        setState(() {
          
        });
         clist.remove(clist.firstWhere((student) => student.companyId == cid));
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company Successfully Accepted",),backgroundColor: Colors.green,),
      );

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Company Not Accepted",), backgroundColor: Colors.red,),);

      }

    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occur: $e',), backgroundColor: Colors.red,),);

    }
  }

  void reject(int cid)async{
    try{
      var response= await MemberApi.rejectcompany(cid);
      if(response.statusCode==200){
        setState(() {
          
        });
        clist.remove(clist.firstWhere((student) => student.companyId == cid));
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
        title: Text('Companies'),
      ),
      body: clist.isEmpty?Center(child: Text('No Pending Request of Company Yet!',style: Appconstant.appcardstyle,),):
      Padding(padding: EdgeInsets.all(16),
      child:ListView.builder(
                  itemCount:clist.length,
                  itemBuilder: (context, index) {
                    final company = clist[index];
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
                                  Text('Description', style: Appconstant.appcardstyle),
                                  Text(company.description, style: Appconstant.appcardstyle),
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
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Container(
                                  
                                    
                                    child: SizedBox(
                                            height: 30,
                                            width: 100,
                                            child: ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Accept Company Account"),
          content: Text("Do you want to accept this company account?"),
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
                accept(company.companyId!);  // Close the dialog
              },
              child: Text("Yes"),
            ),
           
          ],
        );
      },
    );
  },
  child: const Text('Accept'),
),

                                          ),
                                  ),
                                  const SizedBox(width: 10,),

                                        Container(
                                          
                                          child: SizedBox(
                                            height: 30,
                                            width: 100,
                                            
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reject Company Account"),
          content: Text("Do you want to reject this company account?"),
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
                reject(company.companyId!);  // Close the dialog
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
                                              },
                                              child: const Text('Reject'),
                                            ),
                                          ),
                                        ),

                              ],)
                             
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),)

    


    );
    
  }
}