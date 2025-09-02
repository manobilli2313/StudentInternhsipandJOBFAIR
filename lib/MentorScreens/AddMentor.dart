import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/AddSocietyMember.dart';

class AddSocietyMember extends StatefulWidget {
  const AddSocietyMember({super.key});

  @override
  State<AddSocietyMember> createState() => _AddSocietyMemberState();
}

class _AddSocietyMemberState extends State<AddSocietyMember> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController cnic = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  /// 🛠️ ✅ **Fixing API Call**
  void addingMember() async {
    Mentor ment = Mentor(
      name: name.text,
      email: email.text,
      phoneno: contact.text,
      password: password.text,
      cnic: cnic.text,
    );

    var response = await MemberApi.addmember(ment);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mentor Successfully Added"),backgroundColor: Colors.green,),
      );
      setState(() {
        name.clear();
        email.clear();
        contact.clear();
        cnic.clear();
        password.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue while adding mentor! Please try again.',), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(title: const Text('Add Member')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  CustomTextField(
                    controller: name,
                    label: 'Name',
                    hint: 'Enter Member Name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) => value == null || value.isEmpty ? "Name cannot be empty" : null,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: email,
                    label: 'Email',
                    hint: 'Enter Username',
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) => value == null || value.isEmpty ? "Email cannot be empty" : null,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: cnic,
                    label: 'CNIC Number',
                    hint: 'Enter CNIC Number',
                    prefixIcon: const Icon(Icons.credit_card),
                    validator: (value) => value == null || value.isEmpty ? "CNIC cannot be empty" : null,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: contact,
                    label: 'Contact',
                    hint: 'Enter Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    validator: (value) => value == null || value.isEmpty ? "Contact Number cannot be empty" : null,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: password,
                    label: 'Password',
                    hint: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty ? "Password cannot be empty" : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        
                      });
                      if (_formKey.currentState!.validate()) {
                        addingMember(); // ✅ Calling the function correctly
                      }
                    },
                    child: const Text('Add Member'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
