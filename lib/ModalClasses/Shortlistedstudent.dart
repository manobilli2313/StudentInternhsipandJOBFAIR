class Shortlisted{
final int? id;  
final int? companyID;
final int? studentID;
final String? jobfairstatus;
//final String? shortlist;

  final String?companyname;
  final int? jid;
  final String? regno;
  final String? studentname;
  final String? interview;
  final String? shortlist;
  
  final int? year;
  final double? cgpa; 
  final String? gender;
  final int? semester;
  final String? status;
  final double? skill;
  final double? communication;
  final double? personality;
  final double? problemsolving;

  Shortlisted({
    this.id,
    this.companyID,
    this.studentID,
    this.jobfairstatus,
    
    this.companyname,
    this.jid,
    this.regno, 
    this.studentname, 
    this.interview,
    this.shortlist,
    this.year,
    this.cgpa,
    this.gender,
    this.semester,
    this.status,
    this.skill,
    this.communication,
    this.personality,
    this.problemsolving});

    factory Shortlisted.fromJson(Map<String,dynamic>  json){
      return Shortlisted(
        id: json['id'],
        companyID: json['companyID'],
        studentID: json['studentID'],
        companyname: json['name'],
        jid:json['jobfairID'],
        jobfairstatus: json['JobFairStatus'],
        regno:json['s_regno'],
        studentname:json['s_name'],
        interview:json['s_interviewed'],
        shortlist:json['s_shortlist'],
        year:json['year'],
        cgpa: json['s_cgpa'],
        gender: json['s_gender'],
        semester: json['s_semester'],
        status: json['status'],
        skill: json['skill_rating'],
        communication: json['communication_rating'],
        personality: json['personality_rating'],
        problemsolving: json['problem_solving_rating']






      );
    }

  
  
}