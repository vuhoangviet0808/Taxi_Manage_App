// import 'package:flutter/material.dart';
// import 'package:flutter_app/admin/views/views.dart';
// import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
// import 'package:flutter_app/admin/viewmodels/cab_ride_viewmodels.dart';
// import 'package:flutter_app/admin/viewmodels/user_viewmodels.dart';
// import 'package:flutter_app/admin/viewmodels/shift_viewmodels.dart';
// import 'package:flutter_app/admin/viewmodels/cab_viewmodels.dart';

// class AdminPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final adminDashboardViewModel = AdminDashboardViewModel();
//     final cabRideDashboardViewModel = CabRideDashboardViewModel();
//     final userDashboardViewModel = UserDashboardViewModel();
//     final shiftDashboardViewModel = ShiftDashboardViewModel();
//     final cabDashboardViewModel = CabDashboardViewModel();

//     return MaterialApp(
//       title: 'My App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => AdminDashboardView(
//               viewModel: adminDashboardViewModel,
//               CabRideViewModel: cabRideDashboardViewModel,
//               UserViewModel: userDashboardViewModel,
//               ShiftViewModel: shiftDashboardViewModel,
//               CabViewModel: cabDashboardViewModel,
//             ),
//       },
//     );
//   }
// }
