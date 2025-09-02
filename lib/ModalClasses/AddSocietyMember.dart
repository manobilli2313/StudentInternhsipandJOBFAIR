class Mentor {
  final int? id; // Optional for new mentors
  final String name; // Name is now optional
  final String? email;
  final String phoneno;
  final String? password;
  final String cnic;
  final String role;

  Mentor({
    this.id, 
    required this.name, // Made optional
    this.email,
    required this.phoneno,
    this.password,
    required this.cnic,
    this.role = 'societymember', 
  });

  // Factory constructor to extract only contact, email, and cnic
  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id:json['id'],
      phoneno: json['contact'], 
      email: json['email'],  
      cnic: json['cnic'],
      name: json['name'],
    );
  }

  // Convert to JSON (for API request)
  Map<String, dynamic> toMap() {
    return {
      'Username': email,  
      'Password': password, 
      'Role': role, 
      'Name': name,  // Optional
      'CNIC': cnic, 
      'Contact': phoneno,
    };
  }
}
