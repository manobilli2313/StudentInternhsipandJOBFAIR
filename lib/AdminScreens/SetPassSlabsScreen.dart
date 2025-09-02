// screens/SetPassSlabsScreen.dart
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AssignPassesJF.dart';


class SetPassSlabsScreen extends StatefulWidget {
  final int jobFairId;

  SetPassSlabsScreen({super.key, required this.jobFairId});

  @override
  State<SetPassSlabsScreen> createState() => _SetPassSlabsScreenState();
}

class _SetPassSlabsScreenState extends State<SetPassSlabsScreen> {
  List<PassSlabConfig> slabs = [];

  final TextEditingController minCgpaController = TextEditingController();
  final TextEditingController maxCgpaController = TextEditingController();
  final TextEditingController passCountController = TextEditingController();

  bool isSubmitting = false;

  void addSlab() {
    double? min = double.tryParse(minCgpaController.text);
    double? max = double.tryParse(maxCgpaController.text);
    int? count = int.tryParse(passCountController.text);

    if (min != null && max != null && count != null) {
      setState(() {
        slabs.add(PassSlabConfig(minCGPA: min, maxCGPA: max, passCount: count));
        minCgpaController.clear();
        maxCgpaController.clear();
        passCountController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid numbers."), backgroundColor: Colors.red,),
      );
    }
  }

  Future<void> submitSlabs() async {
    if (slabs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add at least one slab."), backgroundColor: Colors.red,),
      );
      return;
    }

    setState(() => isSubmitting = true);

    AssignPassesJF request = AssignPassesJF(
      jobFairId: widget.jobFairId,
      slabs: slabs,
    );

    var response = await AdminAPI.setPassSlabs(request);
    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pass slabs submitted successfully!"),backgroundColor: Colors.green,),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}"), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set Pass Slabs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            CustomTextField(
              controller: minCgpaController, 
              label: "Minimum CGPA", 
              hint: "Enter Min CGPA",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            CustomTextField(
              controller: maxCgpaController, 
              label: "Miximum CGPA", 
              hint: "Enter Mix CGPA",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            
            CustomTextField(
              controller: passCountController, 
              label: "Total Passes", 
              hint: "Enter Pass Count",
             // keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addSlab,
              icon: Icon(Icons.add),
              label: Text("Add Slab"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: slabs.length,
                itemBuilder: (context, index) {
                  var slab = slabs[index];
                  return ListTile(
                    title: Text("CGPA: ${slab.minCGPA} - ${slab.maxCGPA}"),
                    subtitle: Text("Passes: ${slab.passCount}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          slabs.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            isSubmitting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitSlabs,
                    child: Text("Submit All Slabs"),
                  ),
          ],
        ),
      ),
    );
  }
}
