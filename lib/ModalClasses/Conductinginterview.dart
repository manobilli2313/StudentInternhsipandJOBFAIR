class ShortlistStudent {
 
  int? studentID;
  int? companyID;
  int? jobfairID;
  String? sInterviewed;
  String? sShortlist;
  double? communicationRating;
  double? personalityRating;
  double? problemSolvingRating;
  double? skillRating;

  ShortlistStudent({
    
    this.studentID,
    this.companyID,
    this.jobfairID,
    this.sInterviewed,
    this.sShortlist,
    this.communicationRating,
    this.personalityRating,
    this.problemSolvingRating,
    this.skillRating,
  });

  Map<String, dynamic> toJson() {
    return {
     
      'studentID': studentID,
      'companyID': companyID,
      'jobfairID': jobfairID,
      's_interviewed': sInterviewed,
      's_shortlist': sShortlist,
      'communication_rating': communicationRating,
      'personality_rating': personalityRating,
      'problem_solving_rating': problemSolvingRating,
      'skill_rating': skillRating,
    };
  }

  // factory ShortlistStudent.fromJson(Map<String, dynamic> json) {
  //   return ShortlistStudent(
  //     id: json['id'],
  //     studentID: json['studentID'],
  //     companyID: json['companyID'],
  //     jobfairID: json['jobfairID'],
  //     sInterviewed: json['s_interviewed'],
  //     sShortlist: json['s_shortlist'],
  //     communicationRating: (json['communication_rating'] as num?)?.toDouble(),
  //     personalityRating: (json['personality_rating'] as num?)?.toDouble(),
  //     problemSolvingRating: (json['problem_solving_rating'] as num?)?.toDouble(),
  //     skillRating: (json['skill_rating'] as num?)?.toDouble(),
  //   );
  // }
}
