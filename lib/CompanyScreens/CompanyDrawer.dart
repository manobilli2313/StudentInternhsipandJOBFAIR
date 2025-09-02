import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ActiveEvents.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDashboard.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyFeedbackActiveEvents.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanySchedule.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanySchedule2.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/EventFeedback.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/GroupPosterImagesearchbytechnology.dart';

import 'package:student_internship_and_jobfair_fyp/CompanyScreens/InternsRequestwithTechnlogy.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/MyInterns.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/MySHortlistedStudent.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/MysavedStudents.dart';



import 'package:student_internship_and_jobfair_fyp/Screens/LoginPage.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;


class CompanyDrawer extends StatefulWidget {
  const CompanyDrawer({super.key});

  @override
  State<CompanyDrawer> createState() => _CompanyDrawerState();
}

class _CompanyDrawerState extends State<CompanyDrawer> {

  
  void initState(){
    super.initState();
    fetchlength();
  }
  int activejobfairlength=0;

  void fetchlength()async {
   var response= await CompanyApiServices.fetchactivejobfairlength();
    if (!mounted) return; 

   if(response.statusCode==200){
    setState(() {
     var data = jsonDecode(response.body.toString()); // returns int (like 1)
     if (data is int) {
  activejobfairlength = data;
} else if (data is String && data == "No active events yet.") {
  activejobfairlength = 0;
} else if (data is List) {
  activejobfairlength = data.length;
}



      
    });
    print('Axtive jobfair length=${activejobfairlength}');
   }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(218, 97, 233, 70)),
            child: Text('Company Drawer', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
         

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return CompanyHomePage();
              }));
            },
          ),

          ListTile(
  leading: badges.Badge(
  showBadge: activejobfairlength > 0,
  badgeContent: Text(
    activejobfairlength.toString(),
    style: TextStyle(color: Colors.white),
  ),
  child: const Icon(Icons.event),
),
  title: const Text('Active Events'),
  onTap: () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ActiveEvent();
    }));
  },
),
          ListTile(
            leading: const Icon(Icons.watch),
            title: const Text('My Schedule'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ScheduleCompany();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.boy),
            title: const Text('Shortlist Students'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ShortlistStudentsCompany();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page_rounded),
            title: const Text('Interns request'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return InternshipRequestScreen();
              }));
            },
          ),

           ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Group Posters'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return GroupPostersImages();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Event Feedback'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ActiveEventsforfeedback();
              }));
            },
          ),

           ListTile(
            leading: const Icon(Icons.man),
            title: const Text('My Interns'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AllInterns();
              }));
            },
          ),

          

           ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Saved Students'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return SavedStudentsJF();
              }));
            },
          ),

           ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return LoginPage();
              }));
            },
          ),

          
           



        ],
      ),
    );
  }
}
