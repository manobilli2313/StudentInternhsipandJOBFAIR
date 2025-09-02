import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/AddMentor.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AddSocietyMember.dart';

class AllSocietyMentor extends StatefulWidget {
  const AllSocietyMentor({super.key});

  @override
  State<AllSocietyMentor> createState() => _AllSocietyMentorState();
}

class _AllSocietyMentorState extends State<AllSocietyMentor> {
  List<Mentor> mlist = [];

  @override
  void initState() {
    super.initState();
    allmembers();
  }

  void allmembers() async {
    var response = await MemberApi.Allmentors();
    if (response.statusCode == 200) {
      setState(() {
        mlist.clear();
        var data = jsonDecode(response.body.toString());
        for (var i in data) {
          mlist.add(Mentor.fromJson(i));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Internal Issue Check it again plz!',), backgroundColor: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return AddSocietyMember();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
      drawer: MentorDrawer(),
      appBar: AppBar(
        title: Text('All Members'),
      ),
      body: mlist.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Currently No mentor available',
                  style: Appconstant.appcardstyle,
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: mlist.length,
                      itemBuilder: (context, index) {
                        Mentor mentor = mlist[index];
                        return SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 7,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Member Name',
                                          style: Appconstant.appcardstyle),
                                      Text(mentor.name,
                                          style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Member CNIC',
                                          style: Appconstant.appcardstyle),
                                      Text(mentor.cnic,
                                          style: Appconstant.appcardstyle),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Contact',
                                          style: Appconstant.appcardstyle),
                                      Text(mentor.phoneno,
                                          style: Appconstant.appcardstyle),
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
                ),
              ],
            ),
    );
  }
}
