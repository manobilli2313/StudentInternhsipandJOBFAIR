class MatchCompanies {
  final int companyID;
  final String name;
  final String contact;
  final String description;
  final int id; // Renamed to match the JSON key

  MatchCompanies({
    required this.companyID,
    required this.name,
    required this.contact,
    required this.description,
    required this.id, // Updated variable name
  });

  factory MatchCompanies.fromJson(Map<String, dynamic> json) {
    return MatchCompanies(
      companyID: json['CompanyID'], 
      name: json['name'], 
      contact: json['contact'], 
      description: json['description'], 
      id: json['id'], // Updated to match JSON key
    );
  }
}
