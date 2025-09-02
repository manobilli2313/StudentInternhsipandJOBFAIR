import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AddJobFair.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AddMentor.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AllAppliedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AllInterns.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AllMentors.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Alltechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/ApplieStudents.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Banned%20Students.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/CompanyJBRequest.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/EventFEedbackJB.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Home.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/InternsAllFeedback.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/PendingCompanyAccount.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/PendingInternshipRequest.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/RoomAssignment.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/ShoertlistStudent.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/StudentFeedbackJB.dart';
import 'package:student_internship_and_jobfair_fyp/Screens/LoginPage.dart';

class InetrnsDrawer extends StatelessWidget {
  const InetrnsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(218, 97, 233, 70)),
            child: Text('Mentor Drawer', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
         
          

          

           

        

            
          
         


       

           ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return MentorHome();
              }));
            },
          ),


          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('All Interns'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AllSelectedInterns();
              }));
            },
          ),
           ListTile(
            leading: const Icon(Icons.pending),
            title: const Text('Pending Internship Request'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return PendingInternRequests();
              }));
            },
          ),


        

          
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Intern Feedback'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return AllInterneeFeedback();
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
