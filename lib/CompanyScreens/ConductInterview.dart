import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ShowPPtxduringinterviewscreen.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/Studentfeedback.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Conductinginterview.dart';

import '../ModalClasses/ApplytoCompany.dart';

class ConductInterviewJb extends StatefulWidget {
  int? cid,jid,sid;
  String ? stname,regno;
  ConductInterviewJb({super.key,this.cid,this.jid,this.sid,this.stname,this.regno});

  @override
  State<ConductInterviewJb> createState() => _ConductInterviewJbState();
}

class _ConductInterviewJbState extends State<ConductInterviewJb> {
  List<double> marks=[0,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];
  double? selectedcommunication;
  double? personality;
  double? problem;
  double? skills;
  bool isshortlist=false;
  String? shortlisted;
  String interview='interviewed'; 

  Future<void> nextstudent() async {
    JoinCompany joinRequest = JoinCompany(
      studentID: widget.sid!,
      companyID: widget.cid!,
      jobFairID: widget.jid!,
    );
  final response = await CompanyApiServices.nextstudent(joinRequest);
  if (response.statusCode != 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to turn Next Student. Try again."), backgroundColor: Colors.red),
    );
  }
}


  void conductinterview() async {
     
 
  if(isshortlist){
    setState(() {
      
    });
    shortlisted='shortlisted';
  
  }
  ShortlistStudent stu= ShortlistStudent(
    companyID: widget.cid!,
    studentID: widget.sid!,
    jobfairID: widget.jid!,
    communicationRating: selectedcommunication!,
    personalityRating: personality,
    skillRating: skills,
    problemSolvingRating: problem,
    sShortlist: shortlisted,
    sInterviewed: interview
    
    



  );

    final response = await CompanyApiServices.interviewconduct(stu);
    if (response.statusCode == 200) {

  await nextstudent(); 
  setState(() {
        isshortlist=false;
        
      });
      

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Interview Conducted Successfully"),
      content: Text("Do you want to submit feedback for this student?"),
      actions: [
      TextButton(
  onPressed: () {
    Navigator.pop(context); // Close the "Interview Conducted" dialog

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFeedbackPage(cid: widget.cid, sid: widget.sid, jid: widget.jid),
      ),
    ).then((result) {
      if (result == 'next') {
        Navigator.pop(context, 'next'); // Close ConductInterviewJb and pass 'next' to ScheduleCompany
      }
    });
  },
  child: Text("Yes"),
),


        // TextButton(
        //   onPressed: () {
        //     Navigator.pop(context); // Close dialog
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => StudentFeedbackPage(
        //           cid: widget.cid,
        //           sid: widget.sid,
        //           jid: widget.jid,
        //         ),
        //       ),
        //     ).then((_) {
        //       Navigator.pop(context, 'next'); // 🔥 Automatically go to next card after feedback
        //     });
        //   },
        //   child: Text("Yes"),
        // ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context, 'next'); // 🔥 Move to next student without feedback
          },
          child: Text("No"),
        ),
      ],
    ),
  );
}


//     if (response.statusCode == 200) {
//       await nextstudent(); 
//       setState(() {
//         isshortlist=false;
        
//       });
      
      
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Interview Conducted Successfully"),
//       content: Text("Do you want to submit feedback for this student?"),
//       actions: [
//         TextButton(
//           onPressed: () {
//             setState(() {
              
//             });
//             Navigator.pop(context); // Close dialog
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => StudentFeedbackPage( // Your feedback screen here
//                   cid: widget.cid,
//                   sid: widget.sid,
//                   jid: widget.jid,
//                 ),
//               ),
//             );
//           },
//           child: Text("Yes"),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context); // Close dialog
//             Navigator.pop(context); // Go back to previous page
//           },
//           child: Text("No"),
//         ),
//       ],
//     ),
//   );
// }

      
      
     else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to turn Next Student in the company. Try again.",),
         backgroundColor: Colors.red,),
      );
    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('Evaluation Form'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              
                    
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Text('Student Name:${widget.stname}',style: Appconstant.appcardstyle,),
                SizedBox(height: 10,),
                Text('Reg-No: ${widget.regno}',style: Appconstant.appcardstyle,)
                
                  ],
                ),
                SizedBox(height: 25,),
                DropdownButtonFormField<double>(
            decoration: InputDecoration(
              labelText: 'Communication Marks',
              border: OutlineInputBorder(),
            ),
            value: selectedcommunication,
            items: marks.map((double value) {
              return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (double? newValue) {
              selectedcommunication = newValue;
            
            },
                    ),
                    SizedBox(height: 10,),
                    
             SizedBox(height: 5,),
                DropdownButtonFormField<double>(
            decoration: InputDecoration(
              labelText: 'Personality Marks',
              border: OutlineInputBorder(),
            ),
            value: personality,
            items: marks.map((double value) {
              return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (double? newValue) {
               personality= newValue;
            
            },
                    ),
                    SizedBox(height: 10,),
                    
             SizedBox(height: 5,),
                DropdownButtonFormField<double>(
            decoration: InputDecoration(
              labelText: 'Problem Solving Marks',
              border: OutlineInputBorder(),
            ),
            value:problem,
            items: marks.map((double value) {
              return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (double? newValue) {
              problem = newValue;
            
            },
                    ),
                    SizedBox(height: 10,),
                    
             SizedBox(height: 5,),
                DropdownButtonFormField<double>(
            decoration: InputDecoration(
              labelText: 'Skills Marks',
              border: OutlineInputBorder(),
            ),
            value: skills,
            items: marks.map((double value) {
              return DropdownMenuItem<double>(
                    value: value,
                    child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (double? newValue) {
              skills = newValue;
            
            },
                    ),
                    SizedBox(height: 10,),
                    
                    CheckboxListTile(
            title: Text('Shortlisted'),
            value: isshortlist, onChanged: (bool? val){
            setState(() {
              isshortlist=!isshortlist;
            });
                    }),


                    SizedBox(height: 10,),

                    // this work is done for show ppt while interview tie if copany want to see ppt
                    // and save students etc 
            //         ElevatedButton(onPressed: (){
            // setState(() {
            //    Navigator.push(context, MaterialPageRoute(builder:(context){
            //     return showppt(sid: widget.sid,jid:widget.jid,cid: widget.cid,);
            //   }));
              
              
            // });
                    
            //         }, child: Text('Show PPT')),
                    
                    SizedBox(height: 40,),
                    ElevatedButton(onPressed: (){
            
              conductinterview();
              
              
            
                    
                    }, child: Text('Save')),
                    
                
                
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}