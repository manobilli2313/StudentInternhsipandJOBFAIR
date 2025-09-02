class Eventfeedbackcompany {
 
  final int CompanyID;
  final int JobFairID;
  final String? managmentRating;
  final String? facilityRating;
  final String? overallRating;
  final String? futureattandance;
  final String? studentquality;
 
  
  final String? companyname;

  // Constructor
  Eventfeedbackcompany({

    required this.CompanyID,
    required this.JobFairID,
    this.managmentRating,
    this.facilityRating,
    this.overallRating,
    this.futureattandance,
    this.studentquality,
    this.companyname

   
    
  });

  // To convert a StudentFeedback object into a map (for API requests)
  Map<String, dynamic> toMap() {
    return {
     
      'CompanyID': CompanyID,
      'JobFairID': JobFairID,
      
      'managmentRating': managmentRating,
      'facilityRating': facilityRating,
      'overallRating': overallRating,
      'future_attandance': futureattandance,
      'studentquality': studentquality,
    };
  }

  // To create a StudentFeedback object from a map (for API responses)
  factory Eventfeedbackcompany.fromJson(Map<String, dynamic> map) {
    return Eventfeedbackcompany(
      
      CompanyID: map['CompanyID'],
      JobFairID: map['JobFairID'],
      
      managmentRating: map['managmentRating'],
      facilityRating: map['facilityRating'],
      overallRating: map['overallRating'],
      futureattandance: map['future_attandance'],
      studentquality: map['studentquality'],
    
      companyname: map['CompanyName']
    );
  }
}
