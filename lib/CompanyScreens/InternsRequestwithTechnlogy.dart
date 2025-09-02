import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:shared_preferences/shared_preferences.dart';





class InternshipRequestScreen extends StatefulWidget {
  @override
  _InternshipRequestScreenState createState() =>
      _InternshipRequestScreenState();
}

class _InternshipRequestScreenState extends State<InternshipRequestScreen> {
   @override
  void initState() {
    super.initState();
    _loadTechnologies();
  }
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showTechnologyDropdown = false;
List<TechnologyModel> _technologies = []; // Your full tech list
List<TechnologyModel> _selectedTechnologies = [];
  
  final _cgpaController = TextEditingController();
   final _maxcgpaController = TextEditingController();
  final _descController = TextEditingController();
  final _totalduration = TextEditingController();
  final _daysperweek = TextEditingController();
  final _time = TextEditingController();
  final _sttime = TextEditingController();
  final _endtime = TextEditingController();
  

  DateTime? _startDate;
  DateTime? _endDate;


   Future<void> _loadTechnologies() async {
    List<TechnologyModel> fetchedTechnologies =
        await StudentApiService.fetchTechnologies();
    setState(() {
       _technologies= fetchedTechnologies;
    });
  }

 
  


  void _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _sttime.text=picked.toString();
       
          controller.text = picked.toString();
      });
    }
  }

 void _showInternInputDialog(TechnologyModel tech) {
  final TextEditingController inputController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Enter number of interns for ${tech.name}"),
      content: TextField(
        controller: inputController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: "No. of interns"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final num = int.tryParse(inputController.text.trim());
            if (num != null && num > 0) {
              setState(() {
                tech.noOfInterns = num;
                tech.remainingInterns=num;
                _selectedTechnologies.add(tech);
              });
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter a valid number > 0")),
              );
            }
          },
          child: Text("Save"),
        ),
      ],
    ),
  );
}


  void _onTechCheckboxChanged(bool? value, TechnologyModel tech) {
    if (value == true) {
      _showInternInputDialog(tech);
    } else {
      setState(() {
        _selectedTechnologies.removeWhere((t) => t.id == tech.id);
      });
    }
  }

 void _submitRequest() async {
  if (!_formKey.currentState!.validate()) {
    return; // Form fields not valid
  }

  if (_startDate == null || _endDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please pick both start and end dates"),
       backgroundColor: Colors.red,),
    );
    return;
  }

  if (_selectedTechnologies.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select at least one technology"),
       backgroundColor: Colors.red,),
    );
    return;
  }

  SharedPreferences pref = await SharedPreferences.getInstance();
  int? cid = pref.getInt('companyid');
  

  final request = InternsWithTechnologies(
    cid: cid!,
    cgpa: double.parse(double.parse(_cgpaController.text).toStringAsFixed(2)),

    instdate: _startDate!,
    inenddate: _endDate!,
    description: _descController.text.trim(),
    technologies: _selectedTechnologies,
  cgpaTo: double.parse(double.parse(_maxcgpaController.text).toStringAsFixed(2)), // ✅ correct


    totalDuration: _totalduration.text,
    days_per_week: _daysperweek.text,
    timing: _time.text



  );

  var response = await CompanyApiServices.internrequest(request);

  if (response.statusCode == 200) {
    setState(() {
      _cgpaController.clear();
      _descController.clear();
      _maxcgpaController.clear();
      _time.clear();
      _daysperweek.clear();
      _totalduration.clear();
      _startDate = null;
      _endDate = null;
      _selectedTechnologies = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your request is submitted successfully!'),
      backgroundColor: Colors.green,),
    );
  } else if (response.statusCode == 409) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have already applied for this Job Fair!'),
       backgroundColor: Colors.red,),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error while applying: ${response.body}'),
       backgroundColor: Colors.red,),
    );
  }

  print("Request JSON:");
  print(request.toJson());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text("Internship Offer"),
       
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
             //  SizedBox(height: 5,),
          
              CustomTextField(
  controller: _cgpaController,
  label: 'CGPA From',
  hint: 'Minimum CGPA Required',
 // prefixIcon: Icon(Icons.numbers),
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) return 'CGPA is required';
    final cgpa = double.tryParse(value);
    if (cgpa == null || cgpa < 0 || cgpa > 4.0) return 'Enter a valid CGPA (0.0 - 4.0)';
    return null;
  },
),

                // TextField(
                //   controller: _descController,
                //   decoration: InputDecoration(labelText: "Description"),
                // ),
                SizedBox(height: 5),
                   CustomTextField(
  controller: _maxcgpaController,
  label: 'CGPA To',
  hint: 'Maximum CGPA Required',
 // prefixIcon: Icon(Icons.numbers),
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Max CGPA is required';
    final cgpa = double.tryParse(value);
    if (cgpa == null || cgpa < 0 || cgpa > 4.0) return 'Enter a valid CGPA (0.0 - 4.0)';
    return null;
  },
),
SizedBox(height: 5),
  CustomTextField(
  controller: _totalduration,
  label: 'Total Duration',
  hint: 'Internship Duration in Months',
 // prefixIcon: Icon(Icons.numbers),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Max CGPA is required';
  //  final cgpa = double.tryParse(value);
    if ( _totalduration== null) return 'Enter a valid Duration in Months';
    return null;
  },
),
SizedBox(height: 5),
  CustomTextField(
  controller: _daysperweek,
  label: 'Days Per Week',
  hint: 'Enter Days Per Week',
 // prefixIcon: Icon(Icons.numbers),
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Max CGPA is required';
   // final cgpa = double.tryParse(value);
    if ( _daysperweek== null) return 'Days cant be null!';
    return null;
  },
),
SizedBox(height: 5),

  CustomTextField(
  controller: _time,
  label: 'Time',
  hint: 'Enter work Timing',
 // prefixIcon: Icon(Icons.numbers),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Time is required';
   // final cgpa = double.tryParse(value);
    if ( _time== null) return 'Time cant be null!';
    return null;
  },
),
          
                CustomTextField(
  controller: _descController,
  label: 'Description',
  hint: 'Enter Description',
 // prefixIcon: Icon(Icons.description),
  // validator: (value) {
  //   if (value == null || value.trim().isEmpty) return 'Description is required';
  //   return null;
  // },
),

                SizedBox(height: 5,),
            TextFormField(
              controller: _sttime,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
  setState(() {
    // Truncate the time by creating a new DateTime object with only the date part
    _startDate = DateTime(picked.year, picked.month, picked.day);

    // Optionally, format the date to show it in a text field
    _sttime.text = DateFormat('dd-MM-yyyy').format(_startDate!);

  });
}

              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Pick Start Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) => value == null || value.isEmpty ? "Start date is required" : null,
            ),
          SizedBox(height: 5),
           
            TextFormField(
              controller: _endtime,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                   if (picked != null) {
  setState(() {
    // Truncate the time by creating a new DateTime object with only the date part
    _endDate = DateTime(picked.year, picked.month, picked.day);

    // Optionally, format the date to show it in a text field
    _endtime.text = DateFormat('dd-MM-yyyy').format(_endDate!);
  });
}
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Pick End Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) => value == null || value.isEmpty ? "End date is required" : null,
            ),
          
                SizedBox(height: 5),
              GestureDetector(
            onTap: () => setState(() => _showTechnologyDropdown = !_showTechnologyDropdown),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Technologies"),
            Icon(_showTechnologyDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ],
              ),
            ),
          ),
          if (_showTechnologyDropdown)
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
              ),
              constraints: BoxConstraints(maxHeight: 250),
              child: ListView(
          shrinkWrap: true,
          children: _technologies.map((tech) {
            bool isSelected = _selectedTechnologies.any((t) => t.id == tech.id);
            return CheckboxListTile(
              title: Text(tech.name ?? ''),
              value: isSelected,
              onChanged: (bool? selected) {
                if (selected == true && !isSelected) {
                  _showInternInputDialog(tech);

                } else {
                  setState(() {
                    _selectedTechnologies.removeWhere((t) => t.id == tech.id);
                  });
                }
              },
              subtitle: isSelected
                  ? Text("Requested: ${_selectedTechnologies.firstWhere((t) => t.id == tech.id).noOfInterns} interns")
                  : null,
            );
          }).toList(),
              ),
            ),
          if (_selectedTechnologies.isNotEmpty)
            Column(
              children: _selectedTechnologies.map((tech) {
          return ListTile(
            title: Text("${tech.name}"),
            subtitle: Text("Interns: ${tech.noOfInterns}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _selectedTechnologies.removeWhere((t) => t.id == tech.id);
                });
              },
            ),
          );
              }).toList(),
            ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text("Submit Internship Request"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
