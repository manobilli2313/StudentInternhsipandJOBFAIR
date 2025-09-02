import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AppliedStudent.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Event.dart';

class EventFeedbackJobFair extends StatefulWidget {
  const EventFeedbackJobFair({super.key});

  @override
  State<EventFeedbackJobFair> createState() => _EventFeedbackJobFairState();
}

class _EventFeedbackJobFairState extends State<EventFeedbackJobFair> {
  List<Eventfeedbackcompany> slist = [];
  List<Eventfeedbackcompany> filtered = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getfeedback();
  }

  void getfeedback() async {
  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.eventfedback();
    print("API Response: ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        slist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data) {
          slist.add(Eventfeedbackcompany.fromJson(i));
        }
        filtered = slist;  // Assign filtered list after updating slist
        isLoading = false;
      });
    } else {
      setState(() {
        slist = [];
        filtered = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      slist = [];
      filtered = [];
      isLoading = false;
    });
  }
}


 void searchfeedbackbyyear(String year) async {
  if (year.isEmpty) {
    setState(() {
      filtered = slist;
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.eventfeedbackkbyear(year);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) as List;
      setState(() {
        filtered = data.map((json) => Eventfeedbackcompany.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        filtered = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      filtered = [];
      isLoading = false;
    });
  }
}


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(title: const Text('Event Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           


            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Year to Search',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                    searchfeedbackbyyear(searchController.text);
                    
                    
                  });
                    
                  },
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(218, 97, 233, 70), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (filtered.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No Feedback found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    Eventfeedbackcompany feedback = filtered[index];
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
                                  Text(feedback.companyname??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Managment Rating', style: Appconstant.appcardstyle),
                                  Text(feedback.managmentRating??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Faciities Rating', style: Appconstant.appcardstyle),
                                  Text(feedback.facilityRating??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Students Quality', style: Appconstant.appcardstyle),
                                  Text(feedback.studentquality??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Future Attandance', style: Appconstant.appcardstyle),
                                  Text(feedback.futureattandance??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                               const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Overall Rating', style: Appconstant.appcardstyle),
                                  Text(feedback.overallRating??'', style: Appconstant.appcardstyle),
                                ],
                              ),
                              
                             
                                 
                                                
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),

      
      
      
    );
    
  }
}

