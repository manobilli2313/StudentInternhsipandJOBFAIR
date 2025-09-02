import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/PendingCompnies.dart';

class ALLAppliedComapniesJB extends StatefulWidget {
  const ALLAppliedComapniesJB({super.key});

  @override
  State<ALLAppliedComapniesJB> createState() => _ALLAppliedComapniesJBState();
}

class _ALLAppliedComapniesJBState extends State<ALLAppliedComapniesJB> {
  @override
  void initState() {
    super.initState();
    getallrequests();
  }
  List<CompanyModel> clist=[];
  List<CompanyModel> filtered=[];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

 void getallrequests() async {
   setState(() {
    isLoading = true;
  });
  try {
    var response = await MemberApi.allappliedcompany();



    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        clist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data) {
          clist.add(CompanyModel.fromJson(i));
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
 

 //search company by name 

  void searchStudent(String name) async {
  if (name.isEmpty) {
    setState(() {
      filtered = clist;  // your full company list
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.searchspecificcomapny(name);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) as List;
      setState(() {
        filtered = data.map((json) => CompanyModel.fromJson(json)).toList();
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


  void blockcompany(int id) async {
    bool response = await MemberApi.deactivatecompany(id);
    if (response) {
      setState(() {
        filtered.remove(filtered.firstWhere((student) => student.companyId == id));
        filtered=clist;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Company deactivated successfully!',),backgroundColor: Colors.green,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deactivate Company. Try again!',), backgroundColor: Colors.red,),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(
        
      title: Text('Applied Companies'),
      //title: Text('Banned Companies'),
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: clist.isEmpty?Center(child: Text('Currently No Company for JobFair',style: Appconstant.appcardstyle,),
      ):Column(
        children: [

           TextFormField(
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                    searchStudent(searchController.text);
                    
                    
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
                    "No student found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )else

          Expanded(
            child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          CompanyModel company = filtered[index];
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
                                        Text('Contact', style: Appconstant.appcardstyle),
                                        Text(company.contact, style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Slot Time', style: Appconstant.appcardstyle),
                                        Text(company.slotTime.toString(), style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('No Of Interviewers', style: Appconstant.appcardstyle),
                                        Text(company.noOfInterviews.toString(), style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Arrival Time', style: Appconstant.appcardstyle),
                                        Text(company.arrivalTime??'--', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                     const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Leave Time', style: Appconstant.appcardstyle),
                                        Text(company.leaveTime??'--', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 30,
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm Deactivation'),
                                            content: Text('Are you sure you want to deactivate this Company?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    
                                                  });
                                                  blockcompany(company.companyId!);
                                                  Navigator.pop(context);
                                                 
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                   child: const Text('Deactivate'),
                                   //child:const Text('Activate'),
                                  ),
                                ),
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