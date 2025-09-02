class SearchStudent {
  final int sid;
  final String sName;
  final double sCgpa;
  final int sSemester;
  final String fypTitle;
  final String fypTechnology;
  final String posterPath;
  final List<String> technologies;
  final int jid;

  SearchStudent({
    required this.sid,
    required this.sName,
    required this.sCgpa,
    required this.sSemester,
    required this.fypTitle,
    required this.fypTechnology,
    required this.posterPath,
    required this.technologies,
    required this.jid
  });

  factory SearchStudent.fromJson(Map<String, dynamic> json) {
    return SearchStudent(
      sid: json['sid'],
      sName: json['s_name'],
      sCgpa: (json['s_cgpa'] as num).toDouble(),
      sSemester: json['s_semester'],
      fypTitle: json['fyp_title'],
      fypTechnology: json['fyp_technology'],
      posterPath: json['PosterPath'],
      technologies: List<String>.from(json['Technologies'] ?? []),
      jid:json['jid']
    );
  }
}
