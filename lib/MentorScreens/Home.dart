import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/PendingCompanyAccount.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/PendingInternshipRequest.dart';

class MentorHome extends StatelessWidget {
  const MentorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

               GestureDetector(
                onTap: (){
                    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompanyAccountsPending()),
          );

                },
                 child: Column(
                    children: [
                      Center(
                        child: Image.asset('assets/images/jobfair1.png', height: 180, width: 180),
                      ),
                      const Text('Job Fair', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
               ),
              
              const SizedBox(height: 15),

               GestureDetector(
                onTap: (){
                  
                    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PendingInternRequests()),
          );


                },
                 child: Column(
                    children: [
                      Center(
                        child: Image.asset('assets/images/jbfair2.png', height: 220, width: 220,),
                      ),
                      const Text('Internship', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
               ),

        ],
      ),
    );
  }
}