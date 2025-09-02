import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/EligibleInterns.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Internshipdrawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';

import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';

import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SearchEligibleIntern.dart';
  import 'package:shared_preferences/shared_preferences.dart';
    
class ELigibleInetrns extends StatefulWidget {
  int cid,requestid;
  String? cname;
  ELigibleInetrns({super.key,required this.cid,required this.requestid,this.cname});

  @override
  State<ELigibleInetrns> createState() => _ELigibleInetrnsState();
}

class _ELigibleInetrnsState extends State<ELigibleInetrns> {
  List<EligibeInternee> eligiblestudent = [];

  @override
  void initState() {
    super.initState();
    fetcheligiblestudents();
  }
 
// fetch available student 
  void fetcheligiblestudents() async {
   // int rid=widget.requestid;
    var response = await MemberApi.searcheligibleinterne(widget.requestid);
    if (response.statusCode==200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        eligiblestudent=[];
        //pendingRequests = data.map((e) => InternsWithTechnologies.fromJson(e)).toList();
        for(var i in data){
          eligiblestudent.add(EligibeInternee.fromJson(i));
        }
      });
    } 
    else if(response.statusCode==204){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No Student Matched'), backgroundColor: Colors.red,
      ));
    }
    
    else if(response.statusCode==404){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Currently No eligible Interns.'), backgroundColor: Colors.red,
      ));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load requests: ${response.body}'), backgroundColor: Colors.red,
      ));
    }
  }

  // provide intern to company methd

  void providestudent(int sid,int tid)async{

    int companyid=widget.cid!;
    //int rid=widget.requestid!;
    SharedPreferences pref= await SharedPreferences.getInstance();
    int? mentorid= pref.getInt('mentorid');

    Interns provide= Interns(
      mid: mentorid,
      companyID: companyid,
      studentID: sid,
      techid: tid,

      providestatus: 0
      
      
    );

    final response= await MemberApi.provideintern(provide);

    if(response.statusCode==200){
      setState(() {
        
        fetcheligiblestudents();
        
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Intern Provided Successfully",),backgroundColor: Colors.green,),);
    }else if(response.statusCode==409){
      setState(() {
        fetcheligiblestudents();
        
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Already Student provided to company",), backgroundColor: Colors.red,),);
    }
    else{
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Some Issue while provided Intern",), backgroundColor: Colors.red,),);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: InetrnsDrawer(),
      appBar: AppBar(title: Text("Eligible Students")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: eligiblestudent.isEmpty
              ? Center(child: Text("No Eligible Student found", style: Appconstant.appcardstyle))
              : Column(
                children: [
                  Text('Company Name: ${widget.cname}',style:Appconstant.appcardstyle,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: eligiblestudent.length,
                        itemBuilder: (context, index) {
                          final request =eligiblestudent[index];
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Student Name", style: Appconstant.appcardstyle),
                                      Text("${request.studentname}", style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("CGPA", style: Appconstant.appcardstyle),
                                      Text("${request.cgpa}", style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Reg-No", style: Appconstant.appcardstyle),
                                      Text("${request.regno}", style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Semester", style: Appconstant.appcardstyle),
                                       Text("${request.semester}", style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Technology", style: Appconstant.appcardstyle),
                                      Text("${request.techname}", style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  
                    
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 30,
                                      width: 110,
                                      child: ElevatedButton(onPressed: (){
                                        setState(() {
                                          providestudent(request.sid!,request.tid!);
                    
                                           
                                        });
                                      }, child: Text('Provide'))),
                                  )    
                                ],
                              ),
                            ), 
                          );
                        },
                      ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
