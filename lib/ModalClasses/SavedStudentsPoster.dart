class PosterGroup {
  final String? fypTitle;
  final String? posterPath;
  final List<PosterStudent> students;
  final int? jid;

  PosterGroup({
    required this.fypTitle,
    this.posterPath,
    required this.students,
    this.jid,
  });

  // factory PosterGroup.fromJson(Map<String, dynamic> json) {
  //   return PosterGroup(
  //     fypTitle: json['FYPTitle'],
  //     posterPath: json['PosterPath'],
  //     students: (json['Students'] as List)
  //         .map((e) => PosterStudent.fromJson(e))
  //         .toList(),
  //     jid: json['activeJFId'],
  //   );
  // }
  factory PosterGroup.fromJson(Map<String, dynamic> json) {
  return PosterGroup(
    fypTitle: json['FYPTitle'],
    posterPath: json['PosterPath'],
    students: json['Students'] != null
        ? (json['Students'] as List)
            .map((e) => PosterStudent.fromJson(e))
            .toList()
        : [], // If Students is null, return empty list
    jid: json['activeJFId'],
  );
}

}

class PosterStudent {
  final int sid;
  final String sName;
  final double sCgpa;
  final int sSemester;
  final String? pptFile;
  final String? fyp_technology;
  final List<String> technologies;

  PosterStudent({
    this.fyp_technology,
    required this.sid,
    required this.sName,
    required this.sCgpa,
    required this.sSemester,
    this.pptFile,
    required this.technologies,
  });

  factory PosterStudent.fromJson(Map<String, dynamic> json) {
    return PosterStudent(
      fyp_technology:json['fyp_technology'],
      sid: json['sid'],
      sName: json['s_name'],
      sCgpa: (json['s_cgpa'] as num).toDouble(),
      sSemester: json['s_semester'],
      pptFile: json['pptFile'],
      technologies: List<String>.from(json['Technologies'] ?? []),
    );
  }
}
