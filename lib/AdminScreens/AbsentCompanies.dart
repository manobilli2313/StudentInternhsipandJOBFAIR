import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/PendingCompnies.dart';

class AbsentCompanies extends StatefulWidget {
  const AbsentCompanies({super.key});

  @override
  State<AbsentCompanies> createState() => _AbsentCompaniesState();
}

class _AbsentCompaniesState extends State<AbsentCompanies> {
  @override
  void initState() {
    super.initState();
    getallcompanies();
  }
  List<CompanyModel> clist=[];
  List<CompanyModel> filtered=[];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

 void getallcompanies() async {
   setState(() {
    isLoading = true;
  });
  try {
    var response = await AdminAPI.absentcompanies();



    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      setState(() {
        clist.clear();  // Clear old data
        filtered.clear();  
        for (var i in data['Data']) {
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
 

 //search company by yearly 

  void searchcompany(int year) async {
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
    var response = await AdminAPI.absentcompaniesyearly(year);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString()) ;
      setState(() {
        filtered=[];
       // clist=[];
        for(var i in data['Data']){
            filtered.add(CompanyModel.fromJson(i));
            

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
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('Absent Companies'),
      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.all(16),
      child: clist.isEmpty?Center(child: Text('Currently No Company for JobFair',style: Appconstant.appcardstyle,),
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
      searchcompany(year);
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
                    "No Company found currently",
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
    SizedBox(width: 10,),
    Flexible(
      flex: 2, // This is necessary
      child: Text(  
        company.name ?? '',
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
                                        Text('Contact', style: Appconstant.appcardstyle),
                                        Text(company.contact, style: Appconstant.appcardstyle),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 3),
                                       Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Description', style: Appconstant.appcardstyle),
    SizedBox(width: 10,),
    Flexible(
      flex: 2, // This is necessary
      child: Text(  
        company.description ?? '',
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
                                        //Text('Job Fair Status', style: Appconstant.appcardstyle),
                                       // Text(company.jstatus??'', style: Appconstant.appcardstyle),
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