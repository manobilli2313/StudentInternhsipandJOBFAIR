class CompanyModel {
  String? jstatus;
  int? jobfairid;
  int? requestId; // Nullable because it's only in GetPendingRequestsJF
  int? companyId; // Nullable because it's not present in PendingCompanies
  String name;
  String contact;
  String description;
  String? arrivalTime; // Nullable
  String? leaveTime;   // Nullable
  int? slotTime;    // Only in AllCompanies
  String? status;      // Only in AllCompanies
  int? noOfInterviews; // Nullable because it's missing in PendingCompanies

  CompanyModel({
    this.jstatus,
    this.jobfairid,
    this.requestId,
    this.companyId,
    required this.name,
    required this.contact,
    required this.description,
    this.arrivalTime,
    this.leaveTime,
    this.slotTime,
    this.status,
    this.noOfInterviews,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      jstatus: json['jobFairStatus'],
      jobfairid: json['jobFairId'],
      requestId: json['requestid'],  // Only for GetPendingRequestsJF
      companyId: json['cid'] ?? json['id'], // Used in different APIs
      name: json['name'],
      contact: json['contact'],
      description: json['description'] ,
      arrivalTime: json['arrivaltime'], // Might be null
      leaveTime: json['leavetime'],     // Might be null
      slotTime: json['slottime'],       // Only in AllCompanies
      status: json['status'],           // Only in AllCompanies
      noOfInterviews: json['no_of_interviews'], // Nullable
    );
  }

 
}
