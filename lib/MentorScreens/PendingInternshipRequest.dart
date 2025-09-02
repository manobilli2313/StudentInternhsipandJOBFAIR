import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/EligibleInterns.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Internshipdrawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';

class PendingInternRequests extends StatefulWidget {
  const PendingInternRequests({super.key});

  @override
  State<PendingInternRequests> createState() => _PendingInternRequestsState();
}

class _PendingInternRequestsState extends State<PendingInternRequests> {
  List<InternsWithTechnologies> pendingRequests = [];
  bool isLoading = true; // added

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
  }

  void fetchPendingRequests() async {
    setState(() {
      isLoading = true; // show loader
    });

    var response = await MemberApi.peninginternrequest();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        pendingRequests = [];
        for (var i in data) {
          pendingRequests.add(InternsWithTechnologies.fromJson(i));
        }
        isLoading = false; // hide loader
      });
    } else {
      setState(() {
        isLoading = false; // hide loader on failure
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load requests: ${response.body}'),
        backgroundColor: Colors.red,
      ));
    }
  }
  String formatNumber(double? value) {
  if (value == null) return '--';
  return value.toStringAsFixed(2); // Shows only 2 decimal places
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: InetrnsDrawer(),
      appBar: AppBar(title: Text("Pending Internship Requests")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // show loader
              : pendingRequests.isEmpty
                  ? Center(
                      child: Text(
                        "No pending requests found",
                        style: Appconstant.appcardstyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: pendingRequests.length,
                      itemBuilder: (context, index) {
                        final request = pendingRequests[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Company", style: Appconstant.appcardstyle),
                                    Text("${request.companynmae}", style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 5),
                               Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("CGPA From", style: Appconstant.appcardstyle),
    Text(formatNumber(request.cgpa), style: Appconstant.appcardstyle),
  ],
),
const SizedBox(height: 5),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("CGPA To", style: Appconstant.appcardstyle),
    Text(formatNumber(request.cgpaTo), style: Appconstant.appcardstyle),
  ],
),

                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Start Date", style: Appconstant.appcardstyle),
                                    Text("${request.instdate.toLocal().toString().split(' ')[0]}",
                                        style: Appconstant.appcardstyle),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("End Date", style: Appconstant.appcardstyle),
                                    Text("${request.inenddate.toLocal().toString().split(' ')[0]}",
                                        style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Duration", style: Appconstant.appcardstyle),
                                    Text("${request.totalDuration}", style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Timing", style: Appconstant.appcardstyle),
                                    Text("${request.timing}", style: Appconstant.appcardstyle),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Description", style: Appconstant.appcardstyle),
                                    Text("${request.description ?? "N/A"}", style: Appconstant.appcardstyle),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text("Technologies:", style: Appconstant.appcardstyle),
                                ...request.technologies.map((tech) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 4),
                                      child: Text(
                                        "${tech.name} | Total: ${tech.noOfInterns} | Remain: ${tech.remainingInterns}",
                                        style: Appconstant.appcardstyle,
                                      ),
                                    )),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: 30,
                                    width: 110,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (request.cid != null && request.requestid != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ELigibleInetrns(
                                                cid: request.cid,
                                                requestid: request.requestid!,
                                                cname: request.companynmae,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text('Search'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
 