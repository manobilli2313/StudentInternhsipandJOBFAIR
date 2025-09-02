import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AppliedStudent.dart';

class BannedStudents extends StatefulWidget {
  const BannedStudents({super.key});

  @override
  State<BannedStudents> createState() => _BannedStudentsState();
}

class _BannedStudentsState extends State<BannedStudents> {
  List<appliedStudent> slist = [];
  List<appliedStudent> filtered = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getstu();
  }

  void getstu() async {
  setState(() {
    isLoading = true;
  });

  try {
    var response = await MemberApi.Allbannedstudents();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        slist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data) {
          slist.add(appliedStudent.fromJson(i));
        }
        filtered = List.from(slist);  // Assign filtered list after updating slist
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


  void searchStudent(String regno) async {
    if (regno.isEmpty) {
      setState(() {
        filtered = slist;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await MemberApi.studentsearching(regno);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          filtered = [appliedStudent.fromJson(data)];
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

  void unblockStudent(int sid) async {
    bool response = await MemberApi.activatestudent(sid);
    if (response) {
      getstu();
      setState(() {
        filtered.remove(filtered.firstWhere((student) => student.sid == sid));
        filtered=slist;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student Activated successfully!',),backgroundColor: Colors.green,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Activate student. Try again!',), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(title: const Text('Banned Students')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            

            
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Reg-No',
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
                    "No Banned Student found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    appliedStudent student = filtered[index];
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
                                  Text('Name', style: Appconstant.appcardstyle),
                                  Text(student.name!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reg No', style: Appconstant.appcardstyle),
                                  Text(student.regno!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Semester', style: Appconstant.appcardstyle),
                                  Text(student.semester.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CGPA', style: Appconstant.appcardstyle),
                                  Text(student.cgpa.toString(), style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Gender', style: Appconstant.appcardstyle),
                                  Text(student.gender!, style: Appconstant.appcardstyle),
                                ],
                              ),
                              const SizedBox(height: 5),
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
                                            title: Text('Confirm Activation'),
                                            content: Text('Are you sure you want to Activate this student again?'),
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
                                                  unblockStudent(student.sid!);
                                                  Navigator.pop(context);
                                                 
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Activate'),
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
      ),

      
      
      
    );
    
  }
}

