// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:session16/session16%20%20(5-9-2024)/firebase_options.dart';
// // import 'package:session16/session18%20%20(12-9-2024)/postApp.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// //   runApp(const MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: PostApp(),
// //   )
// //   );
// // }
// //
//
// import 'package:flutter/material.dart';
// import 'package:market_we/user/cartProvider.dart';
// import 'package:provider/provider.dart';
// import 'admin/product_provider.dart';
// import 'login_screen.dart';
//
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ProductProvider()),
//         ChangeNotifierProvider(create: (_) => CartProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(), // Implement login to navigate to admin/user
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:market_we/user/user_dashboard.dart';
import 'admin/admin_dashboard.dart';
import 'login_screen.dart';
import 'test/session_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SessionManager _sessionManager = SessionManager();

  Future<Widget> _getInitialScreen() async {
    final session = await _sessionManager.getUserSession();
    if (session != null) {
      final userType = session['user_type'];
     // return userType == 'admin' ? AdminDashboard() : UserDashboard();
    }
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
