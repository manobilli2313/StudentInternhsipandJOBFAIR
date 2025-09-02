import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Screens/LoginPage.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/ApplyInternship.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/CompleteProfile.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/Dashboard11.dart';

import 'package:student_internship_and_jobfair_fyp/StudentScreens/InternshipRecord.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MatchedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/MySchedule.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDashboard.dart';

import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentHistory.dart';


class StudentdrawerScreen extends StatefulWidget {
  const StudentdrawerScreen({super.key});

  @override
  State<StudentdrawerScreen> createState() => _StudentdrawerScreenState();
}

class _StudentdrawerScreenState extends State<StudentdrawerScreen> {

  
  
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(218, 97, 233, 70)),
            child: Text('Student Drawer', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Apply Internship'),
            onTap: () {
              // Add navigation logic here
             Navigator.pushReplacement(context,MaterialPageRoute(
              builder: (context) => ApplytoInternship()),);

            },
          ),
          ListTile(
            leading: const Icon(Icons.watch),
            title: const Text('My Schedule'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return ScheduleInterview();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Complete Profile'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return StudentProfileScreen();
              }));
            },
          ),
           ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Apply Companies'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return MatchedCompanies();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return StudentHomePage
();
              }));
            },
          ),
            ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Track History'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return StudenttrackHistory();
              }));
            },
          ),

           ListTile(
            leading: const Icon(Icons.pending),
            title: const Text('Internship History'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return StudentInternshipRecord();
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
