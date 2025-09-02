import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Shortlistedstudent.dart';


class TotalInterviewdStudents extends StatefulWidget {
  const TotalInterviewdStudents({super.key});

  @override
  State<TotalInterviewdStudents> createState() => _TotalInterviewdStudentsState();
}

class _TotalInterviewdStudentsState extends State<TotalInterviewdStudents> {
  @override
  void initState() {
    super.initState();
    interviewedstudents();
  }
  List<Shortlisted> clist=[];
  List<Shortlisted> filtered=[];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

 void interviewedstudents() async {
   setState(() {
    isLoading = true;
  });
  try {
    var response = await AdminAPI.interviewedstudents();



    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        clist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data['Data']) {
          clist.add(Shortlisted.fromJson(i));
        }
        filtered = clist;  // Assign filtered list after updating slist
        isLoading = false;
      });
    }

    
    else {
      setState(() {
        clist = [];
        filtered = [];
        isLoading = false;
      });
    }
  } catch (e) {
   setState(() {
      clist = [];
      filtered = [];
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $e",), backgroundColor: Colors.red,) // Show only for unexpected errors
    );
  }
 }
 

 //search company by yearly 

  void searchinterviewed(int year) async {
  if (year==null|| year==0) {
    setState(() {
      filtered = clist;  // your full company list
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    var response = await AdminAPI.interviewedstudentyearly(year);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) ;
      setState(() {
        filtered=[];
        //clist=[];
        for(var i in data['Data']){
            filtered.add(Shortlisted.fromJson(i));
            

        }
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
    //  drawer: MentorDrawer(),
    drawer:AdminDrawer(),
      appBar: AppBar(
        title: Text('Interviewed Students'),
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: clist.isEmpty?Center(child: Text('Currently No Student for JobFair',style: Appconstant.appcardstyle,),
      ):Column(
        children: [

           TextFormField(
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Year',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {

                      String input = searchController.text.trim();
    int? year = int.tryParse(input);

    if (year == null || year == 0) {
      
        filtered = List.from(clist); // Reset the list
      
      
    } else {
      searchinterviewed(year);
    }
             
                  // searchcompany(int.parse(searchController.text));
                    
                    
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
           // here some changes
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
                    "No Student found currently",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )else

          Expanded(
            child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          Shortlisted company = filtered[index];
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
    Text('Student Name', style: Appconstant.appcardstyle),
    SizedBox(width: 10,),
    Flexible(
      flex: 2, // This is necessary
      child: Text(  
        company.studentname ?? '',
        style: Appconstant.appcardstyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
  ],
),
                                    const SizedBox(height: 3),
                                       Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Company Name', style: Appconstant.appcardstyle),
    SizedBox(width: 10,),
    Flexible(
      flex: 2, // This is necessary
      child: Text(  
        company.companyname?? '',
        style: Appconstant.appcardstyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
  ],
),
                                    
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Job Fair Status', style: Appconstant.appcardstyle),
                                        Text(company.jobfairstatus??'', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Year', style: Appconstant.appcardstyle),
                                        Text(company.year.toString(), style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Status', style: Appconstant.appcardstyle),
                                        Text(company.interview??'', style: Appconstant.appcardstyle),
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
      )
    ),
    );
  }
}