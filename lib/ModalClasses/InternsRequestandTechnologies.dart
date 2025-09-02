class TechnologyModel {
  int? id;
  String? name;
  int noOfInterns;
  int remainingInterns;

  TechnologyModel({
    this.id,
    this.name,
    this.noOfInterns = 0,
    this.remainingInterns=0,
  }) ; // Set default at construction

  factory TechnologyModel.fromJson(Map<String, dynamic> json) {
    return TechnologyModel(
      id: json['id'],
     name: json['name'],
     //name: json['TechnologyName'],
      noOfInterns: json['NoOfInterns'] ?? 0,
      remainingInterns: json['RemainingInterns']??0
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'noOfInterns': noOfInterns,
      'RemainingInterns': remainingInterns, // 👈 include this for backend
    };
  }
}


// interns with technoogy now together 

class InternsWithTechnologies {

  final int? requestid;
  final String? companynmae;
  final bool? status;

  final int cid;
  final double cgpa;
  final DateTime instdate;
  final DateTime inenddate;
  final String? description;
  final List<TechnologyModel> technologies;
  final double?cgpaTo;
  final String? totalDuration;
  final String? days_per_week;
  final String? timing;


  InternsWithTechnologies({
    this.cgpaTo,
    this.totalDuration,
    this.days_per_week,
    this.timing,
    this.requestid,
    this.companynmae,
    this.status,
    this.description,
    required this.cid,
    required this.cgpa,
    required this.instdate,
    required this.inenddate,
   
    required this.technologies,
  });

  factory InternsWithTechnologies.fromJson(Map<String,dynamic> json){
    return InternsWithTechnologies(

      requestid: json['id'],
      companynmae: json['CompanyName'],
      cid: json['companyID'], 
      cgpa: json['cgpa'], 
      description: json['description'],
      instdate: DateTime.parse(json['in_sdate']), 
      inenddate: DateTime.parse(json['in_edate']),
      cgpaTo:json['cgpaTo'],
      totalDuration: json['totalDuration'],
      days_per_week: json['days_per_week'],
      timing: json['timing'],


       technologies: (json['Technologies'] as List)
          .map((tech) => TechnologyModel.fromJson(tech))
          .toList(),
      );
      
      

  }

  Map<String, dynamic> toJson() => {
        'cid': cid,
        'cgpa': cgpa,
        'instdate': instdate.toIso8601String(),
        'inenddate': inenddate.toIso8601String(),
        'description': description,
        'cgpaTo':cgpaTo,
        'totalDuration':totalDuration,
        'days_per_week':days_per_week,
        'timing':timing,



        'technologies': technologies.map((e) => e.tomap()).toList(),
      };
}

class Addtechnology{
  int? id;
  String? name;
 

  Addtechnology({
    this.id,
    this.name,
  
  }) ;



   Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name':name
    };
  }

}

