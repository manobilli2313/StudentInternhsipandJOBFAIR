import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Shortlistedstudent.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShortlistStudentsCompany extends StatefulWidget {
  const ShortlistStudentsCompany({super.key});

  @override
  State<ShortlistStudentsCompany> createState() => _ShortlistStudentsCompanyState();
}

class _ShortlistStudentsCompanyState extends State<ShortlistStudentsCompany> {
  List<Shortlisted> student = [];
  List<Shortlisted> filtered = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    int? cid=await pref.getInt('companyid');
    var response = await CompanyApiServices.Companyshortlistedstudent(cid!);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        student = data.map<Shortlisted>((json) => Shortlisted.fromJson(json)).toList();
        filtered = List.from(student); // Default filtered list is full list
      });
    } else {
      setState(() {
        student = [];
        filtered = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some Internal error!',),
         backgroundColor: Colors.red,),
      );
    }
  }

  void searchStudent(int year) async {
       SharedPreferences pref= await SharedPreferences.getInstance();
    int? cid=await pref.getInt('companyid');
    if (year==null || year==0) {
      setState(() {
        filtered = List.from(student); // Reset to all students
      });
      return;
    }

    try {
      var response = await CompanyApiServices.Companyshortlistedstudentbyyear(cid!, year);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          filtered = data.map<Shortlisted>((json) => Shortlisted.fromJson(json)).toList();
        });

        if (filtered.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No student found for the given year!',),
             backgroundColor: Colors.red,),
          );
          setState(() {
            filtered = List.from(student); // Reset to all students
          });
        }
      } else {
        setState(() {
          filtered = List.from(student); // Reset to all students
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No student found for the given year!',),
           backgroundColor: Colors.red,),
        );
      }
    } catch (e) {
      setState(() {
        filtered = List.from(student);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data!',),
         backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(title: Text('Shortlisted Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter Year to Search',
              suffixIcon: GestureDetector(
  onTap: () {
    String input = searchController.text.trim();
    int? year = int.tryParse(input);

    if (year == null || year == 0) {
      setState(() {
        filtered = List.from(student); // Reset the list
      });
      
    } else {
      searchStudent(year);
    }
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
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text('No students available'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        Shortlisted stu = filtered[index];
                        return Card(
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
                                    Text(stu.studentname?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Reg No', style: Appconstant.appcardstyle),
                                    Text(stu.regno ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Gender', style: Appconstant.appcardstyle),
                                    Text(stu.gender ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Skills Marks', style: Appconstant.appcardstyle),
                                    Text('${stu.skill}', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Communication', style: Appconstant.appcardstyle),
                                    Text(stu.communication?.toString() ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Personality Marks', style: Appconstant.appcardstyle),
                                    Text(stu.personality.toString() ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Problem Solving', style: Appconstant.appcardstyle),
                                    Text(stu.problemsolving?.toString() ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                 const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Year', style: Appconstant.appcardstyle),
                                    Text('${stu.year}', style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Status', style: Appconstant.appcardstyle),
                                    Text(stu.status?.toString() ?? '-', style: Appconstant.appcardstyle),
                                  ],
                                ),
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
}
