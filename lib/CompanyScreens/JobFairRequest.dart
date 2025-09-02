import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanyJobRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyJbRequest extends StatefulWidget {
  final jid;
  CompanyJbRequest({super.key, required this.jid});

  @override
  State<CompanyJbRequest> createState() => _CompanyJbRequestState();
}

class _CompanyJbRequestState extends State<CompanyJbRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showTechnologyDropdown = false;
  List<int> _selectedTechnologyIds = [];
  List<TechnologyModel> _technologies = [];
  TextEditingController noofinterviewers = TextEditingController();
  TextEditingController slottime = TextEditingController();
  String? arrivaltime;
  String? leavetime;
  int selectedvalue = 1;

  @override
  void initState() {
    super.initState();
    _loadTechnologies();
  }

  Future<void> _loadTechnologies() async {
    List<TechnologyModel> fetchedTechnologies =
        await StudentApiService.fetchTechnologies();
    setState(() {
      _technologies = fetchedTechnologies;
    });
  }

  void submitmyrequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (selectedvalue == 3) {
      arrivaltime = '8:00:00.0000000';
      leavetime = '17:00:00.0000000';
    } else if (selectedvalue == 2) {
      arrivaltime = '14:00:00.0000000';
      leavetime = '17:00:00.0000000';
    } else {
      arrivaltime = '8:00:00.0000000';
      leavetime = '12:00:00.0000000';
    }

    int? cid = await pref.getInt('companyid');

    jbRequest req = jbRequest(
      cid: cid!,
      jid: widget.jid,
      noOfInterviewers: int.parse(noofinterviewers.text),
      slotTime: int.parse(slottime.text),
      selectedTechnologies: _selectedTechnologyIds,
      arrivaltime: arrivaltime,
      leavetime: leavetime,
    );

    var response = await CompanyApiServices.submitrequest(req);

    if (response.statusCode == 200) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Request is submitted Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      selectedvalue = 1;
      noofinterviewers.clear();
      slottime.clear();
      _selectedTechnologyIds = [];
    } else if (response.statusCode == 409) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your have already applied for this Job Fair!'),
          backgroundColor: Colors.red,
        ),
      );
      selectedvalue = 1;
      noofinterviewers.clear();
      slottime.clear();
      _selectedTechnologyIds = [];
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error whilw applying JOb Fair ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('Submit Request'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () => setState(() =>
                      _showTechnologyDropdown = !_showTechnologyDropdown),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Technologies"),
                        Icon(_showTechnologyDropdown
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                if (_showTechnologyDropdown)
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      children: _technologies.map((tech) {
                        return CheckboxListTile(
                          title: Text(tech.name!),
                          value: _selectedTechnologyIds.contains(tech.id),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedTechnologyIds.add(tech.id!);
                              } else {
                                _selectedTechnologyIds.remove(tech.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: noofinterviewers,
                  label: 'No Of Interviewers',
                  hint: 'Total Interviewers',
                  prefixIcon: Icon(Icons.person),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No of Interviewers cannot be Empty';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: slottime,
                  label: 'Slot Time',
                  hint: 'Enter Slor Time',
                  prefixIcon: Icon(Icons.watch),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Slot Time cannot be Empty';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: selectedvalue,
                              onChanged: (value) {
                                setState(() {
                                  selectedvalue = value!;
                                });
                              },
                            ),
                            Text("8:00-12:00"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: selectedvalue,
                              onChanged: (value) {
                                setState(() {
                                  selectedvalue = value!;
                                });
                              },
                            ),
                            Text("2:00-5:00"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 3,
                              groupValue: selectedvalue,
                              onChanged: (value) {
                                setState(() {
                                  selectedvalue = value!;
                                });
                              },
                            ),
                            Text("8:00-5:00"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitmyrequest();
                    }
                  },
                  child: Text('Post Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
