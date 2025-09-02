class StudentFeedbackJB {
 
  final int companyID;
  final int jobfairID;
  final int studentID;
  final String interviewSkills;
  final String dressing;
  final String confidence;
  final String knowledge;
  final String problemSolving;
  final String? studentname;
  final String? companyname;
  final int? year;

  // Constructor
  StudentFeedbackJB({
   
    required this.companyID,
    required this.jobfairID,
    required this.studentID,
    required this.interviewSkills,
    required this.dressing,
    required this.confidence,
    required this.knowledge,
    required this.problemSolving,
    this.studentname,
    this.companyname,
    this.year
  });

  // To convert a StudentFeedback object into a map (for API requests)
  Map<String, dynamic> toMap() {
    return {
     
      'companyID': companyID,
      'jobfairID': jobfairID,
      'studentID': studentID,
      'interviewSkills': interviewSkills,
      'dressing': dressing,
      'confidence': confidence,
      'knowledge': knowledge,
      'problemSolving': problemSolving,
    };
  }

  // To create a StudentFeedback object from a map (for API responses)
  factory StudentFeedbackJB.fromJson(Map<String, dynamic> map) {
    return StudentFeedbackJB(
      
      companyID: map['id'],
      jobfairID: map['jid'],
      studentID: map['sid'],
      interviewSkills: map['interviewSkills'],
      dressing: map['dressing'],
      confidence: map['Confidence'],
      knowledge: map['Knowledge'],
      problemSolving: map['problemSolving'],
      studentname: map['StudentName'],
      companyname: map['CompanyName'],
      year:map['year']
    );
  }
}
