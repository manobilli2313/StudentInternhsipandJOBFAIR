// models/AssignPassesJF.dart
class AssignPassesJF {
  final int jobFairId;
  final List<PassSlabConfig> slabs;

  AssignPassesJF({required this.jobFairId, required this.slabs});

  Map<String, dynamic> toJson() {
    return {
      'JobFairId': jobFairId,
      'Slabs': slabs.map((e) => e.toJson()).toList(),
    };
  }
}

class PassSlabConfig {
  final double minCGPA;
  final double maxCGPA;
  final int passCount;

  PassSlabConfig({
    required this.minCGPA,
    required this.maxCGPA,
    required this.passCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'MinCGPA': minCGPA,
      'MaxCGPA': maxCGPA,
      'PassCount': passCount,
    };
  }
}
