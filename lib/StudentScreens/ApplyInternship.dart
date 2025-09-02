import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternshipAPply.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplytoInternship extends StatefulWidget {
  const ApplytoInternship({super.key});

  @override
  State<ApplytoInternship> createState() => _ApplytoInternshipState();
}

class _ApplytoInternshipState extends State<ApplytoInternship> {
  
   bool _showTechnologyDropdown = false; 
   List<TechnologyModel> _technologies = [];
  List<int> _selectedTechnologyIds = [];

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

  // apply internship method 
   void apply() async {
    SharedPreferences pref= await SharedPreferences.getInstance();

    int? studentId=pref.getInt('studentid');
    if (studentId == null) return;

     ApplyToInternship joinRequest=ApplyToInternship(
      studentId: studentId,
      technologies: _selectedTechnologyIds
      
     );

    var response = await StudentApiService.internshipApply(joinRequest);

    if (response.statusCode==200) {
      setState(() {
        _selectedTechnologyIds=[];
      });
      
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully applied!",),
        backgroundColor: Colors.green,),
      );
      
    } 
    else if(response.statusCode==406){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student already assigned an internship.",),
         backgroundColor: Colors.red,),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Applied.",),
         backgroundColor: Colors.red,),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(title: Text('Internship Apply'),
      
    ),
    body: Padding(padding: EdgeInsets.all(16),
    child: 
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
                onTap: () =>
                    setState(() => _showTechnologyDropdown = !_showTechnologyDropdown),
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
        
              SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                setState(() {
                  apply();
                });
              }, child: Text('Apply'))



      ],
    )



      


    ),);
    
  }
}