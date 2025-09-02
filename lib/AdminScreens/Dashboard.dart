import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int? totalAppliedStudent;
  int? totalAppliedCompanies;
  int? totalShortlisted;
  int? absentCompanies;
  int? totalInterviewed;

  @override
  void initState() {
    super.initState();
    myhome();
  }

  void myhome() async {
    var response = await AdminAPI.admindashboard();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        totalAppliedStudent = data['AppliedStudents'];
        totalAppliedCompanies = data['AppliedCompanies'];
        totalShortlisted = data['ShortlistedStudents'];
        totalInterviewed = data['InterviewedStudents'];
        absentCompanies = data['AbsentCompanies'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some Internal Issue. Please try again later.'),
        ),
      );
    }
  }

  Widget dashboardCard(String title, int? count, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24, // Responsive width
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              count != null ? '$count' : '--',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      drawer: AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Dashboard Overview',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                dashboardCard("Applied Companies", totalAppliedCompanies, Icons.business, Colors.teal),
                dashboardCard("Applied Students", totalAppliedStudent, Icons.school, Colors.indigo),
                dashboardCard("Absent Companies", absentCompanies, Icons.block, Colors.redAccent),
                dashboardCard("Shortlisted Students", totalShortlisted, Icons.star, Colors.orange),
                dashboardCard("Interviewed Students", totalInterviewed, Icons.check_circle, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
// import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
// import 'package:fl_chart/fl_chart.dart';


// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   int? totalAppliedStudent;
//   int? totalAppliedCompanies;
//   int? totalShortlisted;
//   int? absentCompanies;
//   int? totalInterviewed;

//   @override
//   void initState() {
//     super.initState();
//     myhome();
//   }

//   void myhome() async {
//     var response = await AdminAPI.admindashboard();
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       setState(() {
//         totalAppliedStudent = data['AppliedStudents'];
//         totalAppliedCompanies = data['AppliedCompanies'];
//         totalShortlisted = data['ShortlistedStudents'];
//         totalInterviewed = data['InterviewedStudents'];
//         absentCompanies = data['AbsentCompanies'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Some Internal Issue. Please try again later.'),
//         ),
//       );
//     }
//   }

//   Widget dashboardCard(String title, int? count, IconData icon, Color color) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 160,
//         height: 240,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: color.withOpacity(0.1),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Icon(icon, size: 40, color: color),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               count != null ? '$count' : '--',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             SizedBox(
//               height: 60,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.center,
//                   maxY: (count ?? 0).toDouble() + 5,
//                   titlesData: FlTitlesData(show: false),
//                   gridData: FlGridData(show: false),
//                   borderData: FlBorderData(show: false),
//                   barGroups: [
//                     BarChartGroupData(
//                       x: 0,
//                       barRods: [
//                         BarChartRodData(
//                           toY: (count ?? 0).toDouble(),
//                           width: 18,
//                           color: color,
//                           borderRadius: BorderRadius.circular(6),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         centerTitle: true,
//       ),
//       drawer: AdminDrawer(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Dashboard Overview',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               alignment: WrapAlignment.center,
//               children: [
//                 dashboardCard("Applied Companies", totalAppliedCompanies, Icons.business, Colors.teal),
//                 dashboardCard("Applied Students", totalAppliedStudent, Icons.school, Colors.indigo),
//                 dashboardCard("Absent Companies", absentCompanies, Icons.block, Colors.redAccent),
//                 dashboardCard("Shortlisted Students", totalShortlisted, Icons.star, Colors.orange),
//                 dashboardCard("Interviewed Students", totalInterviewed, Icons.check_circle, Colors.green),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
// import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';

// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   int? applied;
//   int? shortlisted;
//   int? interviewed;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadData() async {
//     var response = await AdminAPI.admindashboard();
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       setState(() {
//         applied = data['AppliedStudents'];
//         shortlisted = data['ShortlistedStudents'];
//         interviewed = data['InterviewedStudents'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load data")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Graph"),
//         centerTitle: true,
//       ),
//       drawer: AdminDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: applied != null
//             ? LineChart(
//                 LineChartData(
//                   minX: 0,
//                   maxX: 4,
//                   minY: 0,
//                   maxY: ([
//                         applied ?? 0,
//                         shortlisted ?? 0,
//                         interviewed ?? 0
//                       ].reduce((a, b) => a > b ? a : b))
//                           .toDouble() +
//                       10,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         FlSpot(1, (applied ?? 0).toDouble()),
//                         FlSpot(2, (shortlisted ?? 0).toDouble()),
//                         FlSpot(3, (interviewed ?? 0).toDouble()),
//                       ],
//                       isCurved: true,
//                       barWidth: 4,
//                       color: Colors.indigo,
//                       dotData: FlDotData(show: true),
//                     ),
//                   ],
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         interval: 10,
//                         getTitlesWidget: (value, _) =>
//                             Text(value.toInt().toString()),
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, _) {
//                           switch (value.toInt()) {
//                             case 1:
//                               return const Text("Applied");
//                             case 2:
//                               return const Text("Shortlisted");
//                             case 3:
//                               return const Text("Interviewed");
//                             default:
//                               return const Text("");
//                           }
//                         },
//                       ),
//                     ),
//                     rightTitles:
//                         AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     topTitles:
//                         AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   gridData: FlGridData(show: true),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: const Border(
//                       left: BorderSide(color: Colors.black, width: 1),
//                       bottom: BorderSide(color: Colors.black, width: 1),
//                     ),
//                   ),
//                 ),
//               )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
// import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';

// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   int? totalAppliedStudent;
//   int? totalAppliedCompanies;
//   int? totalShortlisted;
//   int? absentCompanies;
//   int? totalInterviewed;

//   @override
//   void initState() {
//     super.initState();
//     fetchDashboardData();
//   }

//   void fetchDashboardData() async {
//     var response = await AdminAPI.admindashboard();
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       setState(() {
//         totalAppliedStudent = data['AppliedStudents'];
//         totalAppliedCompanies = data['AppliedCompanies'];
//         totalShortlisted = data['ShortlistedStudents'];
//         totalInterviewed = data['InterviewedStudents'];
//         absentCompanies = data['AbsentCompanies'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load dashboard data.')),
//       );
//     }
//   }

//   Widget graphCard(String title, int? count, Color color, IconData icon) {
//     double value = (count ?? 0).toDouble();
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 300,
//         height: 240,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: color.withOpacity(0.05),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 28),
//             const SizedBox(height: 6),
//             Text(title,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//             const SizedBox(height: 12),
//             Expanded(
//               child: BarChart(
//                 BarChartData(
//                   maxY: value + 10,
//                   barGroups: [
//                     BarChartGroupData(
//                       x: 0,
//                       barRods: [
//                         BarChartRodData(
//                           toY: value,
//                           color: color,
//                           width: 24,
//                           borderRadius: BorderRadius.circular(4),
//                         )
//                       ],
//                     ),
//                   ],
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, _) => const Text("Total"),
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         interval: 10,
//                         getTitlesWidget: (value, _) => Text('${value.toInt()}'),
//                       ),
//                     ),
//                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   gridData: FlGridData(show: true),
//                   borderData: FlBorderData(show: false),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         centerTitle: true,
//       ),
//       drawer: AdminDrawer(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Dashboard Graphs',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 graphCard("Applied Students", totalAppliedStudent, Colors.indigo, Icons.school),
//                 graphCard("Shortlisted Students", totalShortlisted, Colors.orange, Icons.star),
//                 graphCard("Interviewed Students", totalInterviewed, Colors.green, Icons.check_circle),
//                 graphCard("Applied Companies", totalAppliedCompanies, Colors.teal, Icons.business),
//                 graphCard("Absent Companies", absentCompanies, Colors.redAccent, Icons.block),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
// import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';

// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   int? totalAppliedStudent;
//   int? totalAppliedCompanies;
//   int? totalShortlisted;
//   int? absentCompanies;
//   int? totalInterviewed;

//   @override
//   void initState() {
//     super.initState();
//     fetchDashboardData();
//   }

//   void fetchDashboardData() async {
//     var response = await AdminAPI.admindashboard();
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       setState(() {
//         totalAppliedStudent = data['AppliedStudents'];
//         totalAppliedCompanies = data['AppliedCompanies'];
//         totalShortlisted = data['ShortlistedStudents'];
//         totalInterviewed = data['InterviewedStudents'];
//         absentCompanies = data['AbsentCompanies'];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load dashboard data.')),
//       );
//     }
//   }

//   double _getMaxY() {
//     final allCounts = [
//       totalAppliedStudent ?? 0,
//       totalShortlisted ?? 0,
//       totalInterviewed ?? 0,
//       totalAppliedCompanies ?? 0,
//       absentCompanies ?? 0,
//     ];
//     return (allCounts.reduce((a, b) => a > b ? a : b)).toDouble() + 10;
//   }

//   List<BarChartGroupData> _buildGroupedBars() {
//     return [
//       // Group 0: Students
//       BarChartGroupData(x: 0, barRods: [
//         BarChartRodData(toY: (totalAppliedStudent ?? 0).toDouble(), color: Colors.indigo, width: 12),
//         BarChartRodData(toY: (totalShortlisted ?? 0).toDouble(), color: Colors.orange, width: 12),
//         BarChartRodData(toY: (totalInterviewed ?? 0).toDouble(), color: Colors.green, width: 12),
//       ]),
//       // Group 1: Companies
//       BarChartGroupData(x: 1, barRods: [
//         BarChartRodData(toY: (totalAppliedCompanies ?? 0).toDouble(), color: Colors.teal, width: 12),
//         BarChartRodData(toY: (absentCompanies ?? 0).toDouble(), color: Colors.redAccent, width: 12),
//       ]),
//     ];
//   }

//   Widget _legendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(width: 12, height: 12, color: color),
//         const SizedBox(width: 4),
//         Text(label, style: TextStyle(fontSize: 13)),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         centerTitle: true,
//       ),
//       drawer: AdminDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Dashboard Overview',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: _getMaxY(),
//                   barGroups: _buildGroupedBars(),
//                   barTouchData: BarTouchData(enabled: true),
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, _) {
//                           switch (value.toInt()) {
//                             case 0:
//                               return const Text('Students');
//                             case 1:
//                               return const Text('Companies');
//                             default:
//                               return const Text('');
//                           }
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         interval: 10,
//                         getTitlesWidget: (value, _) => Text('${value.toInt()}'),
//                       ),
//                     ),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   gridData: FlGridData(show: true),
//                   borderData: FlBorderData(show: false),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Wrap(
//               spacing: 20,
//               runSpacing: 10,
//               children: [
//                 _legendItem("Applied Students", Colors.indigo),
//                 _legendItem("Shortlisted Students", Colors.orange),
//                 _legendItem("Interviewed Students", Colors.green),
//                 _legendItem("Applied Companies", Colors.teal),
//                 _legendItem("Absent Companies", Colors.redAccent),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


