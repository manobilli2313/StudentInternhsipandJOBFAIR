class RoomModel{
  final int? id;
  final String? name;

  RoomModel({this.id,this.name});

  

  // To convert a StudentFeedback object into a map (for API requests)
  Map<String, dynamic> toMap() {
    return {
     
      'id': id,
      'roomName': name,
      
    };
  }

  // To create a StudentFeedback object from a map (for API responses)
  factory RoomModel.fromJson(Map<String, dynamic> map) {
    return RoomModel(
      
      id: map['id'],
      name: map['roomName'],
     
    );
  }
}