import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ApplytoCompany.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/MatchedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';

class MatchedCompanies extends StatefulWidget {
  const MatchedCompanies({super.key});

  @override
  State<MatchedCompanies> createState() => _MatchedCompaniesState();
}

class _MatchedCompaniesState extends State<MatchedCompanies> {
  List<MatchCompanies> slist = [];
  List<MatchCompanies> filtered = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  int? studentId;

  @override
  void initState() {
    super.initState();
    getStudentIdAndLoadCompanies();
  }

  Future<void> getStudentIdAndLoadCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    studentId = prefs.getInt('studentid');
    if (studentId != null) {
      getMatchedCompanies();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student ID not found", style: Appconstant.scaffoldcolor)),
      );
    }
  }

  void getMatchedCompanies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await StudentApiService.fetchCompany(studentId!);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body.toString()) as List;
        setState(() {
          slist = data.map((e) => MatchCompanies.fromJson(e)).toList();
          filtered = slist;
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

  void filterMatchedCompanies(String tech) async {
    if (tech.isEmpty) {
      setState(() {
        filtered = slist;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await StudentApiService.filtermatchedCompany(studentId!, tech);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body.toString()) as List;
        setState(() {
          filtered = data.map((e) => MatchCompanies.fromJson(e)).toList();
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
//   void filterMatchedCompanies(String tech) {
//   setState(() {
//     filtered = slist.where((company) =>
//       company.description.toLowerCase().startsWith(tech.toLowerCase()) ||
//       company.name.toLowerCase().startsWith(tech.toLowerCase())
//     ).toList();
//   });
// }


  void joinCompany(int companyId, int jobfairId) async {
    if (studentId == null) return;

    JoinCompany request = JoinCompany(
      studentID: studentId!,
      companyID: companyId,
      jobFairID: jobfairId,
    );

    var response = await StudentApiService.companysignup(request);

    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
           "Joined successfully!",
          
        ),
      ),
    );

    }else if(response.statusCode==401){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(

           "You have already applied for that Company..",
         
        ),
      ),
    );

    }

    else if(response.statusCode==406){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(

           "You are not eligible for apply Your account as been deaactivated.",
         
        ),
      ),
    );

    }
    else if(response.statusCode==404){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(

           "No Company Found",
         
        ),
      ),
    );

    }
     else if(response.statusCode==204){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(

           "Slots already filled No Remaining Slots in that Company",
         
        ),
      ),
    );

    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(title: const Text('Matched Companies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           TextFormField(
  controller: searchController,
  onChanged: (value) {
    if (value.isEmpty) {
      setState(() {
        filtered = slist; // Restore original list
      });
    } else {
      filterMatchedCompanies(value.trim());
    }
  },
  decoration: InputDecoration(
    hintText: 'Enter Technology',
    suffixIcon: GestureDetector(
      onTap: () {
        filterMatchedCompanies(searchController.text.trim());
      },
      child: const Icon(Icons.search),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(218, 97, 233, 70), width: 2),
    ),
  ),
),

            const SizedBox(height: 10),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (filtered.isEmpty)
              const Expanded(child: Center(child: Text("No companies found")))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final company = filtered[index];
                    return Card(
                      elevation: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow("Company Name", company.name),
                            buildRow("Contact", company.contact),
                            buildRow("Description", company.description),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 30,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    joinCompany(company.companyID, company.id);
                                  },
                                  child: const Text('Apply'),
                                ),
                              ),
                            )
                          ],
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

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Appconstant.appcardstyle),
          Expanded(
            child: Text(value, style: Appconstant.appcardstyle, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
