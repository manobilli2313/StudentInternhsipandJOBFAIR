import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AbsentCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AllRoomsandUpdate.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AppliedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AppliedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/Dashboard.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/RoomAssignment.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/TotalInterviewedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/TotalShortlistedStudent.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/SetPasses.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Screens/LoginPage.dart';

import 'AllVenue.dart';
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(218, 97, 233, 70)),
            child: Text('Admin Drawer', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              // Add navigation logic here
             Navigator.pushReplacement(context,MaterialPageRoute(
              builder: (context) => AdminHome()),);

            },
          ),

          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Applied Students'),
            onTap: () {
              // Add navigation logic here
             Navigator.pushReplacement(context,MaterialPageRoute(
              builder: (context) => AllAppliedStudents()),);

            },
          ),
          ListTile(
            leading: const Icon(Icons.hourglass_empty_outlined),
            title: const Text('Applied Companies'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AllAppliedCompanies();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Absent Companies'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AbsentCompanies();
              }));
            },
          ),
           ListTile(
            leading: const Icon(Icons.boy),
            title: const Text('Interviewed Students'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return TotalInterviewdStudents();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('Shortlisted Students'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AllShortlistedStudent();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Set Passes Slabs'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ActiveEvent();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.room_service),
            title: const Text('All Rooms'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ALlVenue();
              }));
            },
          ),

           ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Assign Rooms'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AssignRoomPage();
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
