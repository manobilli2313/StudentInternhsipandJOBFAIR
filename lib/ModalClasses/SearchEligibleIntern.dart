class EligibeInternee{
  final int? sid;
  final String? studentname;
  final double? cgpa;
  final int? semester;
  final String? fyptitle;
  final int? tid;
  final String? techname;
  final String? regno;

  EligibeInternee({
    this.sid,
    this.studentname,
    this.cgpa,
    this.semester,
    this.fyptitle,
    this.tid,
    this.techname,
    this.regno,
  });

  factory EligibeInternee.fromJson(Map<String,dynamic> json){
    return EligibeInternee(
      sid: json['sid'],
      studentname: json['s_name'],
      cgpa: json['s_cgpa'],
      semester: json['s_semester'],
      fyptitle: json['fyp_title'],
      tid: json['TechnologyID'],
      techname: json['TechnologyName'],
      regno: json['s_regno']

    );
  }

}