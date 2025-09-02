import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/SubmitInternFeedback.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Internshipdrawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AllInterns.dart';

class AllSelectedInterns extends StatefulWidget {
  const AllSelectedInterns({super.key});

  @override
  State<AllSelectedInterns> createState() => _AllSelectedInternsState();
}

class _AllSelectedInternsState extends State<AllSelectedInterns> {
  List<Interns> internslist = [];
  List<Interns> filteredList = [];

  int selectedbtn = 0;

  @override
  void initState() {
    super.initState();
    companyinterns();
  }

  void companyinterns() async {
    var response = await MemberApi.allinterns();
    if (response.statusCode == 200) {
      setState(() {
        internslist = [];
        var data = jsonDecode(response.body.toString());
        for (var i in data) {
          internslist.add(Interns.fromJson(i));
        }
        filteredList = List.from(internslist); 
        selectedbtn = 0; // Show all initially
      });
    } else if (response.statusCode == 400) {
      internslist = [];
      filteredList = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Student Yet '), backgroundColor: Colors.red),
      );
    } else if (response.statusCode == 500) {
      internslist = [];
      filteredList = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some thing went Wrong.${response.body} '), backgroundColor: Colors.red),
      );
    } else {
      internslist = [];
      filteredList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: InetrnsDrawer(),
      appBar: AppBar(
        title: Text('All Interns'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: internslist.isEmpty
              ? Center(
                  child: Text('Currently No Student assigned to you', style: Appconstant.appcardstyle),
                )
              : Column(
                  children: [
                   SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Container(
        height: 30,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selectedbtn == 1 ? Colors.amber : Appconstant.appcolor,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedbtn == 1 ? Colors.amber : Colors.blue, // Change button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedbtn = 1;
              filteredList = internslist
                  .where((element) => element.internshipStatus == 'Passed')
                  .toList();
            });
          },
          child: Text('Passed'),
        ),
      ),
      SizedBox(width: 10),
      Container(
        height: 30,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selectedbtn == 2 ? Colors.amber : Appconstant.appcolor,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedbtn == 2 ? Colors.amber : Colors.blue, // Change button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedbtn = 2;
              filteredList = internslist
                  .where((element) => element.internshipStatus == 'Pending')
                  .toList();
            });
          },
          child: Text('Pending'),
        ),
      ),
      SizedBox(width: 10),
      Container(
        height: 30,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selectedbtn == 3 ? Colors.amber : Appconstant.appcolor,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedbtn == 3 ? Colors.amber : Colors.blue, // Change button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedbtn = 3;
              filteredList = internslist
                  .where((element) => element.internshipStatus == 'Failed')
                  .toList();
            });
          },
          child: Text('Failed'),
        ),
      ),
    ],
  ),
),

                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final data = filteredList[index];
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
                                        Text(data.sname ?? ' ', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Company Name', style: Appconstant.appcardstyle),
                                        Text(data.companyname ?? ' ', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('CGPA', style: Appconstant.appcardstyle),
                                        Text('${data.scgpa!}', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Semester', style: Appconstant.appcardstyle),
                                        Text('${data.semester}', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Gender', style: Appconstant.appcardstyle),
                                        Text(data.sgender ?? ' ', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Reg-No', style: Appconstant.appcardstyle),
                                        Text(data.sregno ?? ' ', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Internship Status', style: Appconstant.appcardstyle),
                                        Text(data.internshipStatus ?? ' ', style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
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
      ),
    );
  }
}
