class SignupCompanyModel {
  late String username;
  late String password;
  late String name;
  late String contact;
  late String description;
  late int noOfEmployees;
  int? userId; // Nullable, will be set after user creation

  // Role is hardcoded as 'company'
  final String role = "company"; 
  final String status="pending";

  SignupCompanyModel({
    required this.username,
    required this.password,
    required this.name,
    required this.contact,
    required this.description,
    required this.noOfEmployees,
    this.userId, // Nullable, will be assigned later
  });

  // Convert model to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      "user": {
        "username": username,
        "password": password,
        "role": role, // Always sends "company"
      },
      "comp": {
        "userID": userId, // Initially null, backend assigns it
        "name": name,
        "contact": contact,
        "description": description,
        "no_of_employees": noOfEmployees,
        "status":status
      }
    };
  }
}
